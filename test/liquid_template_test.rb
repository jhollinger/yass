require 'test_helper'

class LiquidTemplateTest < Minitest::Test
  include TestHelpers

  def test_page
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("foo/index.html.liquid"))
      template = compile config, "<h1>{{ page.title }}</h1><p>{{ page.url }}</p><p>{{ page.path }}</p>"

      result = template.render(source)
      assert_equal "<h1>Foo</h1><p>foo</p><p>foo/index.html</p>", result
    end
  end

  def test_files
    with_config do |config|
      FileUtils.mkdir_p config.src_dir.join("posts")
      FileUtils.mkdir_p config.src_dir.join("empty_dir")
      File.write(config.template_dir.join("default.html.liquid"), "")
      File.write(config.src_dir.join("index.html.liquid"), "")
      File.write(config.src_dir.join("no-ext"), "")
      File.write(config.src_dir.join("posts", "first.md"), "")

      source = Yass::Source.new(config, config.src_dir.join("bar/foo.html.liquid"))
      run = ->(attr) {
        template = compile config, "{% for f in files %}{{ f.#{attr} }}|{% endfor %}"
        template.render(source).sub(/\|$/, "").split("|").sort
      }

      assert_equal %w[. no-ext posts/first.html].sort, run.call("url")
      assert_equal %w[index.html no-ext posts/first.html].sort, run.call("path")
      assert_equal %w[. . posts].sort, run.call("dirname")
      assert_equal %w[index.html no-ext first.html].sort, run.call("filename")
      assert_equal [".html", "", ".html"].sort, run.call("extname")
      assert_equal ["Home", "No Ext", "First"].sort, run.call("title")
    end
  end

  def test_relative_to_in_root
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))

      template = compile config, '{{ "bar.js" | relative_to: page.url }}'
      assert_equal "bar.js", template.render(source)

      template = compile config, '{{ "foo/bar.js" | relative_to: page.url }}'
      assert_equal "foo/bar.js", template.render(source)
    end
  end

  def test_relative_to_in_dir
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("zorp/bar/foo.html.liquid"))

      template = compile config, '{{ "bar.js" | relative_to: page.url }}'
      assert_equal "../../bar.js", template.render(source)

      template = compile config, '{{ "foo/bar.js" | relative_to: page.url }}'
      assert_equal "../../foo/bar.js", template.render(source)
    end
  end

  def test_render_tag
    with_config do |config|
      File.write(config.template_dir.join("my_template.liquid"), "My template said '{{ message }}'")
      source = Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))
      template = compile config, 'main: {% render "my_template", message: "foo" %}'
      assert_equal "main: My template said 'foo'", template.render(source)
    end
  end

  private

  def compile(config, src) = Yass::LiquidTemplate.compile(config, "foo.html.liquid", src)

  def create_files(config)
    FileUtils.mkdir_p config.src_dir.join("posts")
    File.write(config.src_dir.join("index.html.liquid"), "")
    File.write(config.src_dir.join("styles.css"), "")
    File.write(config.src_dir.join("posts", "first.md"), "")
  end
end
