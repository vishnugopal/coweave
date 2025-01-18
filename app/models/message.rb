class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  enum :role, developer: 0, assistant: 10, user: 20

  belongs_to :playthrough

  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  def broadcast_created
    broadcast_append_later_to(
      "#{dom_id(playthrough)}_messages",
      partial: "messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(playthrough)}_messages"
    )
  end

  def broadcast_updated
    broadcast_append_to(
      "#{dom_id(playthrough)}_messages",
      partial: "messages/message",
      locals: { message: self, scroll_to: true },
      target: "#{dom_id(playthrough)}_messages"
    )
  end

  def self.for_openai(messages)
    messages.map { |message| { role: message.role, content: message.content } }
  end
end
