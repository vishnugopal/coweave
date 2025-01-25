# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  attr_reader :attributes, :html_attributes

  def initialize(**attributes)
    @href = attributes[:href]
    @attributes = attributes
    @html_attributes = attributes[:html] || {}

    set_classes
    set_tag
  end

  def tag_type
    @tag_type
  end

  private
  def set_classes
    # default
    classes = "hidden rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:block cursor-pointer"

    case attributes[:type]
    when :primary
      classes = "inline-flex items-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
    when :secondary
      classes = "inline-flex items-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
    end

    @html_attributes[:class] = class_names(@html_attributes[:class], classes)
  end

  def set_tag
    if attributes[:as] === :link
      @tag_type = :link
      @html_attributes[:href] = @href || "#"
      @html_attributes[:role] = "button"
    elsif attributes[:form].present?
      if @html_attributes[:type] === "submit"
        @tag_type = :submit_button_inside_form
        @form = attributes[:form]
      else
        @tag_type = :button_inside_form
        @form = attributes[:form]
      end
    elsif @href.blank?
      @tag_type = :button
    else
      @tag_type = :button_with_href
    end
  end
end
