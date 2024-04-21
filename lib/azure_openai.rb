# frozen_string_literal: true

require "faraday"

require_relative "azure_openai/version"
require_relative "azure_openai/completion"
require_relative "azure_openai/completion_multi_model"
require_relative "azure_openai/embedding"
require_relative "azure_openai/helper"
require_relative "azure_openai/stream_merger"

module AzureOpenAI
  class Error < StandardError; end
  class ConnectionError < Error; end
  class TimeoutError < Error; end
  class AuthenticationError < Error; end
  class RateLimitError < Error; end
  class DeploymentNotFoundError < Error; end
  class NotFoundError < Error; end
  class ContentFilterError < Error; end
  class InvalidRequestError < Error; end
  class UnexpectedResponseError < Error; end
end
