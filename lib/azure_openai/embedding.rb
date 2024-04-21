# frozen_string_literal: true

module AzureOpenAI
  # A class to call the Azure OpenAI API with a single model
  class Embedding
    attr_reader :name, :host, :deployment, :api_key, :api_version, :api_url

    def initialize(model)
      @name = model.name
      @host = model.configuration["host"]
      @deployment = model.configuration["deployment"]
      @api_key = model.configuration["api_key"]
      @api_version = model.configuration["api_version"]
      @api_url = "https://#{@host}/openai/deployments/#{@deployment}/embeddings"
    end

    def embed(parameters)
      # Rails.logger.info("Embedding with \"#{@name}\" model with URL: #{@api_url}.")
      response = connection.post do |request|
        request.params = params
        request.body = parameters.to_json
      end
      handle_response(response)
    rescue Faraday::ConnectionFailed => e
      # Rails.logger.error("API connection failed: #{e.message}")
      raise AzureOpenAI::ConnectionError, "Connection to API failed: #{e}"
    rescue Faraday::TimeoutError => e
      # Rails.logger.error("API request timed out: #{e.message}")
      raise AzureOpenAI::TimeoutError, "API request timed out: #{e}"
    end

    private

    def connection
      @connection ||= Faraday.new(url: @api_url, headers: request_headers) do |faraday|
        faraday.options.open_timeout = 10    # set connection timeout
        faraday.options.timeout = 60         # set read timeout
      end
    end

    def request_headers
      {
        "Content-Type" => "application/json",
        "api-key" => api_key
      }
    end

    def params
      {
        "api-version" => api_version
      }
    end

    def handle_response(response)
      return JSON.parse(response.body) if response.status == 200

      handle_error(response.status, response.body)
    end

    def handle_error(status, response_body = nil)
      error_response = parse_error_response(response_body)
      case status
      when 400 then handle_error400(error_response)
      when 401 then raise AzureOpenAI::AuthenticationError, "Invalid API key: \n#{error_response}"
      when 404 then handle_error404(error_response)
      when 429 then raise AzureOpenAI::RateLimitError, "Rate limit exceeded: \n#{error_response}"
      else handle_unknown_error(status, error_response)
      end
    end

    def handle_error404(error_response)
      case error_response["code"]
      when "DeploymentNotFound"
        raise AzureOpenAI::DeploymentNotFoundError, "Deployment not found: \n#{error_response}"
      else
        raise AzureOpenAI::NotFoundError, "Resource not found: \n#{error_response}"
      end
    end

    def handle_error400(error_response)
      case error_response["code"]
      when "content_filter"
        raise AzureOpenAI::ContentFilterError, "Content filter triggered: \n#{error_response}"
      else
        raise AzureOpenAI::InvalidRequestError, "Invalid request: \n#{error_response}"
      end
    end

    def handle_unknown_error(status, error_response)
      error_message = "Unexpected response from API: \n#{status}"
      error_message += " - #{error_response}" unless error_response.empty?
      raise AzureOpenAI::UnexpectedResponseError, error_message
    end

    def parse_error_response(body)
      return "" if body.nil? || body.empty?

      begin
        JSON.parse(body)["error"]
      rescue AzureOpenAI::Error
        "Error details not available"
      end
    end
  end
end
