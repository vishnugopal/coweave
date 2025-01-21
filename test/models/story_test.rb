require "test_helper"

class StoryTest < ActiveSupport::TestCase
  def setup
    @story = stories(203451238)
  end

  test "should extract scenes correctly" do
    expected_scenes = [ "Start", "Jail Room", "Escape", "The Chest", "The Staircase", "To Kill or Not to Kill", "Loot!", "The Final Corridor", "Out at Last!" ]
    assert_equal expected_scenes, @story.scenes
  end

  test "should count scenes correctly" do
    assert_equal 8, @story.scene_count
  end
end
