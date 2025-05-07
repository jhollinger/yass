require 'test_helper'

class ErbTemplateTest < Minitest::Test
  include TestHelpers

  def test_compile_and_render
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("foo.html.erb"))
      template = Yass::ErbTemplate.compile("<h1><%= page.title %></h1>")

      result = template.render(config, Yass::Page.new(source))
      assert_equal "<h1>Foo</h1>", result
    end
  end

  def test_relative_path_to_in_root
    with_config do |config|
      File.write(config.template_dir.join("layouts", "default.html.erb"), "")
      source = Yass::Source.new(config, config.src_dir.join("foo.html.erb"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))

      assert_equal "bar.js", ctx.relative_path_to("bar.js").to_s
      assert_equal "foo/bar.js", ctx.relative_path_to("foo/bar.js").to_s
    end
  end

  def test_relative_path_to_in_dir
    with_config do |config|
      File.write(config.template_dir.join("layouts", "default.html.erb"), "")
      source = Yass::Source.new(config, config.src_dir.join("foo/bar/foo.html.erb"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))

      assert_equal "../../bar.js", ctx.relative_path_to("bar.js").to_s
      assert_equal "../../zorp/bin.js", ctx.relative_path_to("zorp/bin.js").to_s
    end
  end

  def test_raw_returns_html_safe_string
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("foo.html.erb"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))

      result = ctx.raw "<h1>Hi</h1>"
      assert_equal "<h1>Hi</h1>", result
      assert result.is_a? Yass::HtmlSafeString
    end
  end

  def test_list_all_files
    with_config do |config|
      create_files config
      source = Yass::Source.new(config, config.src_dir.join("index.html.erb"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))
      assert_equal [
        "index.html.erb",
        "posts/first.md",
        "styles.css",
      ], ctx.files.map(&:relative_path).map(&:to_s).sort
    end
  end

  def test_list_some_files
    with_config do |config|
      create_files config
      source = Yass::Source.new(config, config.src_dir.join("index.html.erb"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))
      assert_equal [
        "styles.css",
      ], ctx.files("**/*.css").map(&:relative_path).map(&:to_s).sort
    end
  end

  def test_list_pages
    with_config do |config|
      create_files config
      source = Yass::Source.new(config, config.src_dir.join("index.html.erb"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))
      assert_equal [
        "index.html.erb",
        "posts/first.md",
      ], ctx.pages.map(&:relative_path).map(&:to_s).sort
    end
  end

  def test_template
    with_config do |config|
      File.write(config.template_dir.join("title.html.erb"), "<h1><%= page.title %></h1>")
      source = Yass::Source.new(config, config.src_dir.join("foo.html"))
      ctx = Yass::ErbTemplate::Context.new(config, Yass::Page.new(source))

      result = ctx.template("title.html")
      assert_equal result, "<h1>Foo</h1>"
    end
  end

  private

  def create_files(config)
    FileUtils.mkdir_p config.src_dir.join("posts")
    File.write(config.src_dir.join("index.html.erb"), "")
    File.write(config.src_dir.join("styles.css"), "")
    File.write(config.src_dir.join("posts", "first.md"), "")
  end
end
