class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  enum :role, developer: 0, assistant: 10, user: 20
  enum :transition, within_scene: 0, new_scene: 10, story_over: 20

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

    if scene_number > 0
      broadcast_replace_to(
        "#{dom_id(playthrough)}_progress",
        partial: "playthroughs/progress",
        locals: { playthrough: playthrough, current_scene: scene_number },
        target: "#{dom_id(playthrough)}_progress"
      )
    end
  end

  def self.for_openai(messages)
    messages.map { |message| { role: message.role, content: message.content } }
  end
end
