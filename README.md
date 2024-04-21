# AzureOpenAI

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add azure_openai
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install azure_openai
```

## Usage

```ruby
class LanguageModel
  attr_accessor :name, :kind, :provider, :configuration

  def initialize(name:, kind:, provider:, configuration:)
    @name = name
    @kind = kind
    @provider = provider
    @configuration = configuration
  end

  def self.all
    gpt_4_turbo = LanguageModel.new(
      name: "GPT-4 Turbo",
      kind: "completion",
      provider: "azure",
      configuration: {
        "host" => "your_instance.openai.azure.com",
        "api_key" => "your_key",
        "deployment" => "gpt-4-turbo",
        "api_version" => "2023-12-01-preview"
      }
    )

    ada2 = LanguageModel.new(
      name: "Ada2",
      kind: "embedding",
      provider: "azure",
      configuration: {
        "host" => "your_instance.openai.azure.com",
        "api_key" => "your_key",
        "deployment" => "ada2",
        "api_version" => "2023-12-01-preview"
      }
    )

    [gpt_4_turbo, ada2]
  end
end

first_completion_model = LanguageModel.all.find { |model| model.kind == "completion" }

parameters = {
  "messages" => [
    {
      "role" => "system",
      "content" => "Tell me a joke"
    }
  ]
}
response = AzureOpenAI::Completion
  .new(first_completion_model)
  .chat(parameters)
puts response


first_embedding_model = LanguageModel.all.find { |model| model.kind == "embedding" }

parameters = {
  "input" => "Once upon a time"
}
response = AzureOpenAI::Embedding
  .new(first_embedding_model)
  .embed(parameters)
puts response
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AzureOpenAI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/azure_openai/blob/main/CODE_OF_CONDUCT.md).
