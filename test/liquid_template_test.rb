require 'test_helper'

class LiquidTemplateTest < Minitest::Test
  include TestHelpers

  def test_page
    with_config do |config|
      source = create Yass::Source.new(config, config.src_dir.join("foo/index.html.liquid"))
      template = compile config, "<h1>{{ page.title }}</h1><p>{{ page.path }}</p>"

      result = template.render(source)
      assert_equal "<h1>Foo</h1><p>foo/index.html</p>", result
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

      source = create Yass::Source.new(config, config.src_dir.join("bar/foo.html.liquid"))
      run = ->(attr) {
        template = compile config, "{% for f in files %}{{ f.#{attr} }}|{% endfor %}"
        template.render(source).sub(/\|$/, "").split("|").sort
      }

      assert_equal ["Home", "No Ext", "Foo", "Foo", "First"].sort, run.call("title")
      assert_equal %w[index.html no-ext bar/foo.html foo/index.html posts/first.html].sort, run.call("path")
      assert_equal %w[. . bar foo posts].sort, run.call("dirname")
      assert_equal %w[index.html foo.html index.html no-ext first.html].sort, run.call("filename")
      assert_equal [".html", "", ".html", ".html", ".html"].sort, run.call("extname")
      assert_equal %w[index.html.liquid bar/foo.html.liquid no-ext foo/index.md.liquid posts/first.md].sort, run.call("src_path")
      assert_equal %w[0] * 5, run.call("filesize")
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

      source = create Yass::Source.new(config, config.src_dir.join("bar/foo/index.html"))
      template = make_template.call 'foo/[^.]+\.html$'
      assert_equal "Yes", template.render(source)

      source = create Yass::Source.new(config, config.src_dir.join("bar/index.html"))
      template = make_template.call 'foo/[^.]+\.html$'
      assert_equal "No", template.render(source)
    end
  end

  def test_where_match
    with_config do |config|
      source = create Yass::Source.new(config, config.src_dir.join("index.html"))
      create Yass::Source.new(config, config.src_dir.join("posts", "a.html"))
      create Yass::Source.new(config, config.src_dir.join("posts", "b.html"))
      create Yass::Source.new(config, config.src_dir.join("posts", "x.jpeg"))

      template = compile config, %(
        {%- assign posts = files | where_match: "path", "posts/.+\.html" -%}
        {{- posts | sort:"path" | map:"title" | join:", " -}}
      )
      assert_equal "A, B", template.render(source)
    end
  end

  def test_relative_in_root
    with_config do |config|
      source = create Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))

      template = compile config, '{{ "bar.js" | relative }}'
      assert_equal "bar.js", template.render(source)

      template = compile config, '{{ "foo/bar.js" | relative }}'
      assert_equal "foo/bar.js", template.render(source)
    end
  end

  def test_relative_in_dir
    with_config do |config|
      source = create Yass::Source.new(config, config.src_dir.join("zorp/bar/foo.html.liquid"))

      template = compile config, '{{ "bar.js" | relative }}'
      assert_equal "../../bar.js", template.render(source)

      template = compile config, '{{ "foo/bar.js" | relative }}'
      assert_equal "../../foo/bar.js", template.render(source)
    end
  end

  def test_render_tag
    with_config do |config|
      File.write(config.template_dir.join("my_template.liquid"), "My template said '{{ message }}'")
      source = create Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))
      template = compile config, 'main: {% render "my_template", message: "foo" %}'
      assert_equal "main: My template said 'foo'", template.render(source)
    end
  end

  def test_render_content_tag
    with_config do |config|
      File.write(config.template_dir.join("section.liquid"), "<section><h2>{{ page.title }}</h2>{{ content }}</section>")
      source = create Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))
      template = compile config, 'main: {% render_content "section", page: page %}<p>Content!</p>{% endrender_content %}'
      assert_equal "main: <section><h2>Foo</h2><p>Content!</p></section>", template.render(source)
    end
  end

  def test_highlight_tag
    with_config do |config|
      source = create Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))
      template = compile config, '{% highlight ruby %}puts "Hello, world!"{% endhighlight %}'
      assert_equal %(<pre><code class="language-ruby">puts &quot;Hello, world!&quot;</code></pre>), template.render(source)
    end

    def test_strip_index_on
      with_config do |config|
        config.strip_index = true
        source = create Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))

        template = compile config, '{% "foo.html" | strip_index %}'
        assert_equal "foo.html", template.render(source)

        template = compile config, '{% "index.html" | strip_index %}'
        assert_equal "", template.render(source)

        template = compile config, '{% "foo/index.html" | strip_index %}'
        assert_equal "foo", template.render(source)

        source = create Yass::Source.new(config, config.src_dir.join("bar/foo.html.liquid"))
        template = compile config, '{% "foo/index.html" | strip_index %}'
        assert_equal "../foo", template.render(source)
      end
    end

    def test_strip_index_off
      with_config do |config|
        config.strip_index = false
        source = create Yass::Source.new(config, config.src_dir.join("foo.html.liquid"))

        template = compile config, '{% "foo.html" | strip_index %}'
        assert_equal "foo.html", template.render(source)

        template = compile config, '{% "index.html" | strip_index %}'
        assert_equal "index.html", template.render(source)

        template = compile config, '{% "foo/index.html" | strip_index %}'
        assert_equal "foo/index.html", template.render(source)

        source = create Yass::Source.new(config, config.src_dir.join("bar/foo.html.liquid"))
        template = compile config, '{% "foo/index.html" | strip_index %}'
        assert_equal "../foo/index.html", template.render(source)
      end
    end
  end

  private

  def create(source)
    FileUtils.mkdir_p source.path.dirname unless source.path.dirname.exist?
    File.write(source.path, "")
    source
  end

  def compile(config, src) = Yass::LiquidTemplate.compile(config, "foo.html.liquid", src)
end
