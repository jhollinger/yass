require 'test_helper'

class SourceTest < Minitest::Test
  include TestHelpers

  def test_src_path
    with_site do |site|
      source = create(site, site.src_dir.join("index.html"))
      assert_equal "index.html", source.src_path.to_s

      source = create(site, site.src_dir.join("index.foo.html"))
      assert_equal "index.foo.html", source.src_path.to_s

      source = create(site, site.src_dir.join("index.md"))
      assert_equal "index.md", source.src_path.to_s

      source = create(site, site.src_dir.join("foo/bar/index.md.liquid"))
      assert_equal "foo/bar/index.md.liquid", source.src_path.to_s

      source = create(site, site.src_dir.join("foo/bar/index.liquid"))
      assert_equal "foo/bar/index.liquid", source.src_path.to_s

      source = create(site, site.src_dir.join("downloads/file"))
      assert_equal "downloads/file", source.src_path.to_s
    end
  end

  def test_dest_path
    with_site do |site|
      source = create(site, site.src_dir.join("index.html"))
      assert_equal "index.html", source.dest_path.to_s

      source = create(site, site.src_dir.join("index.foo.html"))
      assert_equal "index.foo.html", source.dest_path.to_s

      source = create(site, site.src_dir.join("index.md"))
      assert_equal "index.html", source.dest_path.to_s

      source = create(site, site.src_dir.join("foo/bar/index.md.liquid"))
      assert_equal "foo/bar/index.html", source.dest_path.to_s

      source = create(site, site.src_dir.join("foo/bar/index.liquid"))
      assert_equal "foo/bar/index", source.dest_path.to_s

      source = create(site, site.src_dir.join("downloads/file"))
      assert_equal "downloads/file", source.dest_path.to_s
    end
  end

  def test_outfile
    with_site do |site|
      source = create(site, site.src_dir.join("index.html"))
      assert_equal site.dest_dir.join("index.html").to_s, source.outfile.to_s

      source = create(site, site.src_dir.join("index.foo.html"))
      assert_equal site.dest_dir.join("index.foo.html").to_s, source.outfile.to_s

      source = create(site, site.src_dir.join("index.md"))
      assert_equal site.dest_dir.join("index.html").to_s, source.outfile.to_s

      source = create(site, site.src_dir.join("foo/bar/index.md.liquid"))
      assert_equal site.dest_dir.join("foo/bar/index.html").to_s, source.outfile.to_s

      source = create(site, site.src_dir.join("foo/bar/index.liquid"))
      assert_equal site.dest_dir.join("foo/bar/index").to_s, source.outfile.to_s

      source = create(site, site.src_dir.join("downloads/file"))
      assert_equal site.dest_dir.join("downloads/file").to_s, source.outfile.to_s
    end
  end

  def test_size
    with_site do |site|
      source = create(site, site.src_dir.join("index.html"), "Hi")
      assert_equal File.stat(source.path).size, source.size
    end
  end

  def test_front_matter
    with_site do |site|
      source = create(site, site.src_dir.join("foo.html"), "---\nfoo: Bar\nzip: Zorp\n---")
      assert_equal({"foo" => "Bar", "zip" => "Zorp"}, source.front_matter)

      source = create(site, site.src_dir.join("foo.html"), "---\n---")
      assert_equal({}, source.front_matter)

      source = create(site, site.src_dir.join("foo.md"), "# My Text")
      assert_equal({}, source.front_matter)

      source = create(site, site.src_dir.join("foo.html"))
      assert_equal({}, source.front_matter)
    end
  end

  def test_title
    with_site do |site|
      source = create(site, site.src_dir.join("index.html"))
      assert_equal "Home", source.title

      source = create(site, site.src_dir.join("foo.html"))
      assert_equal "Foo", source.title

      source = create(site, site.src_dir.join("foo/index.html"))
      assert_equal "Foo", source.title

      source = create(site, site.src_dir.join("foo/foo-bar-zorp.html"))
      assert_equal "Foo Bar Zorp", source.title

      source = create(site, site.src_dir.join("foo/foo-bar-zorp.html"), "---\ntitle: My Post\n---")
      assert_equal "My Post", source.title
    end
  end

  def test_layout
    with_site do |site|
      source = create(site, site.src_dir.join("foo.html"))
      assert_nil source.layout

      site.clear_cache!
      File.write(site.layout_dir.join("default.html.liquid"), "")
      File.write(site.layout_dir.join("foo.html.liquid"), "")
      File.write(site.layout_dir.join("foo.css.liquid"), "")

      source = create(site, site.src_dir.join("foo.html"))
      assert_equal site.layout_cache["default.html"], source.layout

      source = create(site, site.src_dir.join("foo.html"), "---\nlayout: false\n---")
      assert_nil source.layout

      source = create(site, site.src_dir.join("foo.html"), "---\nlayout: foo\n---")
      assert_equal site.layout_cache["foo.html"], source.layout

      source = create(site, site.src_dir.join("foo.css"), "---\nlayout: foo\n---")
      assert_equal site.layout_cache["foo.css"], source.layout
    end
  end

  def test_content
    with_site do |site|
      content = "# My Post\nSome thoughts"

      source = create(site, site.src_dir.join("foo.html"), content)
      assert_equal content, source.content.chomp

      source = create(site, site.src_dir.join("foo.html"), "---\nfoo: Bar\n---\n#{content}")
      assert_equal content, source.content.chomp

      source = create(site, site.src_dir.join("foo.html"), "---\nfoo: Bar\n---\n\n\n\n\n\n#{content}")
      assert_equal content, source.content.chomp

      source = create(site, site.src_dir.join("foo.html"), "---\nfoo: Bar\n---")
      assert_equal "", source.content.chomp

      source = create(site, site.src_dir.join("foo.html"), "---\nfoo: Bar\n---\n")
      assert_equal "", source.content.chomp
    end
  end

  def test_dynamic
    with_site do |site|
      source = create(site, site.src_dir.join("foo.html"))
      refute source.dynamic?

      site.clear_cache!
      File.write(site.layout_dir.join("default.html.liquid"), "")
      assert source.dynamic?

      source = create(site, site.src_dir.join("foo.md"))
      assert source.dynamic?

      source = create(site, site.src_dir.join("foo.liquid"))
      assert source.dynamic?

      source = create(site, site.src_dir.join("foo.md.liquid"))
      assert source.dynamic?

      source = create(site, site.src_dir.join("foo.js"), "---\nfoo: bar\n---")
      assert source.dynamic?
    end
  end

  def test_published
    with_site do |site|
      source = create(site, site.src_dir.join("foo.html"))
      assert source.published?

      source = create(site, site.src_dir.join("foo.html"), "---\nfoo: bar\n---")
      assert source.published?

      source = create(site, site.src_dir.join("foo.html"), "---\npublished:\n---")
      assert source.published?

      source = create(site, site.src_dir.join("foo.html"), "---\npublished: true\n---")
      assert source.published?

      source = create(site, site.src_dir.join("foo.html"), "---\npublished: false\n---")
      refute source.published?
    end
  end
end
