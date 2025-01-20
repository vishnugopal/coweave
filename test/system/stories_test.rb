require "application_system_test_case"

class StoriesTest < ApplicationSystemTestCase
  setup do
    @story = Story.first
  end

  test "visiting index" do
    visit stories_url

    assert_selector "h1", text: "Stories"
    assert_selector "a", text: @story.title
  end

  test "editing a story" do
    visit stories_url

    click_on @story.title
    assert_selector "h3", text: "Editing: #{@story.title}"
    assert_text "# Scene 1"
    fill_in "Title", with: "The Moon Mage version 2"
    click_on "Save"

    assert_selector "h3", text: "Editing: The Moon Mage version 2"
  end

  test "playing a story" do
    visit stories_url
    story = find_link(@story.title).ancestor("li")
    story.click_on "Play"

    connect_turbo_cable_stream_sources
    assert_selector "h3", text: "Playing: #{@story.title}"
    assert_text "Start"
    assert_text "Scene 0"
    assert_text @story.scenes.second

    # TODO: Not able to test turbo streams yet here.
  end
end
