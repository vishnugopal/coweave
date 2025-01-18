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
      message = messages.find { |m| m.response_number == chunk.dig("choices", 0, "index") }
      message.update(content: message.content + new_content) if new_content
    end
  end
end
