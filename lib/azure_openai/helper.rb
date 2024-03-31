# frozen_string_literal: true

module AzureOpenAI
  # Helper methods for the Azure OpenAI API
  class Helper
    def self.clean_body(body)
      body.merge({
                   "choices" => clean_choices(body["choices"])
                 })
          .except("object")
          .except("created")
          .except("model")
          .except("prompt_filter_results")
          .except("system_fingerprint")
          .except("id")
    end

    def self.clean_choices(choices)
      choices.map do |choice|
        choice
          .except("content_filter_results")
          .except("finish_reason")
          .except("index")
      end
    end
  end
end
