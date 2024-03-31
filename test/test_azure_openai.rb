# frozen_string_literal: true

require "test_helper"
require "json"

class TestAzureOpenAI < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AzureOpenAI::VERSION
  end

  def test_helper_clean_body # rubocop:disable Metrics/MethodLength
    response = File.read(File.expand_path("fixtures/response.json", __dir__))
    json = JSON.parse(response)

    result = {
      "choices" => [
        {
          "message" => {
            "role" => "assistant",
            "content" => "Why don't scientists trust atoms?\n\nBecause they make up everything!"
          }
        }
      ],
      "usage" => {
        "prompt_tokens" => 11,
        "completion_tokens" => 13,
        "total_tokens" => 24
      }
    }

    assert_equal result, AzureOpenAI::Helper.clean_body(json)
  end
end
