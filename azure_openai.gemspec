# frozen_string_literal: true

require_relative "lib/azure_openai/version"

Gem::Specification.new do |spec|
  spec.name = "azure_openai"
  spec.version = AzureOpenAI::VERSION
  spec.authors = ["Devran Cosmo Uenal"]
  spec.email = ["maccosmo@gmail.com"]

  spec.summary = "Unofficial Azure OpenAI API Client"
  spec.description = "An unofficial client for the Azure OpenAI API."
  spec.homepage = "https://bavmind.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/bavmind"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bavmind/azure_openai"
  spec.metadata["changelog_uri"] = "https://github.com/bavmind/azure_openai/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "event_stream_parser", "~> 1.0"
  spec.add_dependency "faraday", "~> 2.9"
  spec.add_dependency "json", "~> 2.7.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
