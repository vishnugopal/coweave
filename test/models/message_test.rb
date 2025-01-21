require "test_helper"

class MessageTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @message = messages(1)
  end

  test "should have correct content" do
    assert_equal "Hello", @message.content
  end

  test "should have correct sender" do
    assert_equal "user", @message.role
  end

  test "should broadcast to messages on update" do
    @message.content += "New Title"
    @message.save

    assert_broadcasts "#{dom_id(@message.playthrough)}_messages", 1
    assert_broadcasts "#{dom_id(@message.playthrough)}_progress", 0
  end

  test "should broadcast to progress if scene_number > 0" do
    @message.scene_number = 1
    @message.content += "New Title"
    @message.save

    assert_broadcasts "#{dom_id(@message.playthrough)}_progress", 1
  end

  test "should broadcast to turbo_stream on create" do
    message = Message.new(content: "Hello", role: "user", playthrough: playthroughs(1))
    message.save

    # Create is broadcast_append_later_to
    perform_enqueued_jobs

    assert_broadcasts "#{dom_id(message.playthrough)}_messages", 1
  end
end
