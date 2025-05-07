require 'test_helper'

class PageTest < Minitest::Test
  include TestHelpers

  def test_attributes
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("foo.html.erb"))
      page = Yass::Page.new(source)

      assert_equal "Foo", page.title
      assert_equal "foo.html", page.url.to_s
      assert_equal "foo.html.erb", page.path.to_s
    end
  end
end
