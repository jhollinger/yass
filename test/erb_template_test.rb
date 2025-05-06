require 'test_helper'

class ErbTemplateTest < Minitest::Test
  class Page
    def initialize(name) = @name = name
    def render(template) = template.result binding
  end

  def test_compile_and_eval
    template = Yass::ErbTemplate.compile("<p>Hi, <%= @name %></p>")
    result = Page.new("Foo").render(template)
    assert_equal "<p>Hi, Foo</p>", result
  end
end
