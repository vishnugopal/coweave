# frozen_string_literal: true

require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def test_component_renders
    render_inline(ButtonComponent.new) { "Hello, components!" }
    assert_component_rendered
    assert_text "Hello, components!"
  end
end
