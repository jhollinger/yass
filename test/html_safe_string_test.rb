require 'test_helper'

class HtmlSafeStringTest < Minitest::Test
  def test_appends_and_escapes_html
    str = Yass::HtmlSafeString.new
    str << "<p>Hi</p>"
    assert_equal "&lt;p&gt;Hi&lt;/p&gt;", str
  end

  def test_appends_safe_html
    str = Yass::HtmlSafeString.new
    str << Yass::HtmlSafeString.new("<p>Hi</p>")
    assert_equal "<p>Hi</p>", str
  end

  def test_safe_concat
    str = Yass::HtmlSafeString.new
    str.safe_concat "<p>Hi</p>"
    assert_equal "<p>Hi</p>", str
  end
end
