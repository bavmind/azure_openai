# frozen_string_literal: true

module AzureOpenAI
  # StreamMerger takes an OpenAI stream of data and collects it into a single object
  class StreamMerger
    attr_accessor :merged

    def initialize
      @merged = {}
    end

    def merge(stream_chunk)
      stream_chunk.each do |key, value|
        next if !@merged[key].nil? && (key == "choices")

        @merged[key] = value if @merged[key].to_s.empty?
      end

      stream_chunk["choices"]&.each do |choice|
        merge_choice(choice)
      end
    end

    def any_choice_finished?
      choices.any? { |choice| !choice["finish_reason"].nil? }
    end

    def all_choices_finished?
      return false if choices.empty?

      choices.all? { |choice| !choice["finish_reason"].nil? }
    end

    private

    def merge_choice(choice)
      choice_index = choice["index"]
      merged_choice = find_choice_by_index(choice_index)

      if merged_choice
        update_choice(merged_choice, choice)
        merge_delta(merged_choice["delta"], choice)
      else
        @merged["choices"] << choice
      end
    end

    def find_choice_by_index(choice_index)
      @merged["choices"].find { |c| c["index"] == choice_index }
    end

    def update_choice(merged_choice, choice)
      choice.each do |key, value|
        # Skip if the key is "delta" and it's already set, or if the existing value is not empty.
        next if key == "delta" && !merged_choice[key].nil?

        merged_choice[key] = value if merged_choice[key].to_s.empty?
      end
    end

    def merge_delta(merged_delta, choice)
      return unless merged_delta

      merged_delta.each do |key, value|
        next if !merged_delta[key].nil? && (%w[content tool_calls].any? key)

        merged_delta[key] = value if merged_delta[key].to_s.empty?
      end

      merge_delta_content(choice.dig("delta", "content"), merged_delta)
      merge_delta_tool_calls(choice.dig("delta", "tool_calls"), merged_delta)
    end

    def merge_delta_content(content, merged_delta)
      return if content.nil?

      previous_content = merged_delta["content"] || ""
      merged_delta["content"] = (previous_content + content)
    end

    def merge_delta_tool_calls(tool_calls, merged_delta)
      # Proceed only if tool_calls is not nil and not empty.
      return if tool_calls.nil? || tool_calls.empty?

      tool_calls.each do |tool_call|
        process_tool_call(tool_call, merged_delta)
      end
    end

    def process_tool_call(tool_call, merged_delta)
      tool_call_index = tool_call["index"]
      merged_tool_call = find_merged_tool_call_by_index(tool_call_index, merged_delta)

      return unless merged_tool_call

      tool_call.each do |key, value|
        next if !merged_tool_call[key].nil? && (key == "function")

        merged_tool_call[key] = value if merged_tool_call[key].to_s.empty?
      end

      append_function_arguments(tool_call["function"]["arguments"], merged_tool_call)
    end

    def find_merged_tool_call_by_index(index, merged_delta)
      merged_delta["tool_calls"].find { |tc| tc["index"] == index }
    end

    def append_function_arguments(function_arguments, merged_tool_call)
      # Early return if function_arguments is nil to avoid unnecessary processing
      return if function_arguments.nil?

      # Ensure there's a "function" key with a default hash, and
      # "arguments" key initialized to an empty string if not present
      merged_tool_call["function"] ||= {}
      merged_tool_call["function"]["arguments"] ||= ""

      # Append new function arguments to the existing ones
      merged_tool_call["function"]["arguments"] << function_arguments
    end

    def choices
      @merged["choices"] || []
    end
  end
end
