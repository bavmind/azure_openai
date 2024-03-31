# frozen_string_literal: true

require_relative "azure_openai/version"
require_relative "azure_openai/completion"
require_relative "azure_openai/completion_multi_model"
require_relative "azure_openai/helper"

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
