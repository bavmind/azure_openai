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
  end
end

response = AzureOpenAI::Completion
  .new(models.first)
  .chat(parameters)
puts response
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AzureOpenAI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/azure_openai/blob/main/CODE_OF_CONDUCT.md).
