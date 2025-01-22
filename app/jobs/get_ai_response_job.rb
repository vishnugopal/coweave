class GetAiResponseJob < ApplicationJob
  RESPONSES_PER_MESSAGE = 1

  queue_as :default

  def perform(playthrough_id)
    playthrough = Playthrough.find(playthrough_id)
    call_openai(playthrough: playthrough)
  end

  private

  def call_openai(playthrough:)
    client = OpenAI::Client.new(access_token: Rails.application.credentials.openai.access_token!)
    client.chat(
      parameters: {
        model: "gpt-4o",
        response_format: { type: "json_object" },
        messages: Message.for_openai(playthrough.messages),
        temperature: 0.8,
        stream: stream_proc(playthrough: playthrough),
        n: RESPONSES_PER_MESSAGE
      }
    )
  end

  def create_messages(playthrough:)
    messages = []
    RESPONSES_PER_MESSAGE.times do |i|
      message = playthrough.messages.create(role: "assistant", content: "", response_number: i)
      message.broadcast_created
      messages << message
    end
    messages
  end

  def stream_proc(playthrough:)
    messages = create_messages(playthrough: playthrough)
    proc do |chunk, _bytesize|
      new_content = chunk.dig("choices", 0, "delta", "content")
      finish_reason = chunk.dig("choices", 0, "finish_reason")

      message = messages.find { |m| m.response_number == chunk.dig("choices", 0, "index") }

      json_fragment = "#{message.json_content}#{new_content}"

      scene_content = parse_json_fragment(
        fragment: json_fragment,
        field: "message",
        current_value: message.content,
        fallback: ""
      )

      scene_number = parse_json_fragment(
        fragment: json_fragment,
        field: "scene_number",
        current_value: message.scene_number,
        fallback: 0
      )

      transition = parse_json_fragment(
        fragment: json_fragment,
        field: "transition",
        current_value: message.transition,
        fallback: "within_scene",
        allowed_values: Message.transitions.keys
      )

      if new_content.present?
        message.content = scene_content
        message.transition = transition
        message.scene_number = scene_number
        message.json_content = message.json_content + new_content
        message.broadcast_updated
      end

      if finish_reason.present?
        message.save!
      end
    end
  end

  def parse_json_fragment(fragment:, field:, current_value:, fallback: "", allowed_values: false)
    value = json_parser.parse(fragment)[field] || fallback

    raise TypeError if allowed_values && !allowed_values.include?(value)
    value
  rescue Optimistic::Json::Parser::MissingParser, NoMethodError, TypeError
    current_value || fallback
  end

  # An optimistic JSON parser that can parse fragments.
  def json_parser
    Optimistic::Json::Parser.new
  end
end
