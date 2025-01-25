# frozen_string_literal: true

require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def test_component_renders
    render_inline(ButtonComponent.new) { "Hello, components!" }
    assert_component_rendered
    assert_text "Hello, components!"
  end

  def test_as_link
    render_inline(ButtonComponent.new(as: :link, href: "world")) { "Hello, components!" }
    assert_selector "a[href='world']", text: "Hello, components!"
  end

  def test_button
    render_inline(ButtonComponent.new(type: "submit")) { "Hello, components!" }
    assert_selector "button[type='submit']", text: "Hello, components!"
  end

  def test_submit_button_inside_form
    with_controller_class (StoriesController) do
      render_in_view_context do
        form_for Story.new do |form|
        render(ButtonComponent.new(form: form)) { "Hello, components 2!" }
        end
      end
    end

    assert_selector "form[action='/stories']"
    assert_selector "button[type='submit']", text: "Hello, components 2!"
  end

  def test_button_inside_form
    with_controller_class (StoriesController) do
      render_in_view_context do
        form_for Story.new do |form|
          render(ButtonComponent.new(form: form, html: { type: :button })) { "Hello, components 2!" }
        end
      end
    end

    assert_selector "form[action='/stories']"
    assert_selector "button[type='button']", text: "Hello, components 2!"
  end

  def test_button_with_href
    render_inline(ButtonComponent.new(href: "world")) { "Hello, components!" }
    assert_selector "form[action='world']"
    assert_selector "button", text: "Hello, components!"
  end
end
