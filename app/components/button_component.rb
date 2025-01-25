# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  attr_reader :attributes, :html_attributes

  def initialize(href:, **attributes)
    @href = href
    @attributes = attributes
    @html_attributes = attributes[:html] || {}

    set_classes
    set_tag
  end

  def link?
    @link
  end

  private
  def set_classes
    # default
    classes = "hidden rounded-md bg-white px-2.5 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:block cursor-pointer"

    case attributes[:type]
    when :primary
      classes = "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    when :secondary
      classes = "bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded"
    when :danger
      classes = "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
    end

    @html_attributes[:class] = class_names(@html_attributes[:class], classes)
  end

  def set_tag
    case attributes[:as]
    when :link
      @link = true
      @html_attributes[:href] = @href || "#"
      @html_attributes[:role] = "button"
    else
      @link = false
    end
  end
end
