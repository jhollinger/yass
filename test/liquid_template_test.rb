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
      FileUtils.mkdir_p config.src_dir.join("foo")
      File.write(config.template_dir.join("default.html.liquid"), "")
      File.write(config.src_dir.join("index.html.liquid"), "")
      File.write(config.src_dir.join("foo/index.md.liquid"), "")
      File.write(config.src_dir.join("no-ext"), "")
      File.write(config.src_dir.join("posts", "first.md"), "")

      source = Yass::Source.new(config, config.src_dir.join("bar/foo.html.liquid"))
      run = ->(attr) {
        template = compile config, "{% for f in files %}{{ f.#{attr} }}|{% endfor %}"
        template.render(source).sub(/\|$/, "").split("|").sort
      }

      assert_equal ["Home", "No Ext", "Foo", "First"].sort, run.call("title")
      assert_equal %w[. no-ext foo posts/first.html].sort, run.call("url")
      assert_equal %w[index.html no-ext foo/index.html posts/first.html].sort, run.call("path")
      assert_equal %w[. . foo posts].sort, run.call("dirname")
      assert_equal %w[index.html index.html no-ext first.html].sort, run.call("filename")
      assert_equal [".html", "", ".html", ".html"].sort, run.call("extname")
      assert_equal %w[index.html.liquid no-ext foo/index.md.liquid posts/first.md].sort, run.call("src_path")
    end
  end

  def test_match
    with_config do |config|
      make_template = ->(regex) {
        compile config, %(
          {%- assign x = page.path | match:"#{regex}" -%}
          {%- if x -%}Yes{%- else -%}No{%- endif -%}
        )
      }

      source = Yass::Source.new(config, config.src_dir.join("bar/foo/index.html"))
      template = make_template.call 'foo/[^.]+\.html$'
      assert_equal "Yes", template.render(source)

      source = Yass::Source.new(config, config.src_dir.join("bar/index.html"))
      template = make_template.call 'foo/[^.]+\.html$'
      assert_equal "No", template.render(source)
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

  def test_highlight_tag
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))
      template = compile config, '{% highlight ruby %}puts "Hello, world!"{% endhighlight %}'
      assert_equal %(<pre><code class="language-ruby">puts "Hello, world!"</code></pre>), template.render(source)
    end
  end

  private

  def compile(config, src) = Yass::LiquidTemplate.compile(config, "foo.html.liquid", src)
end
