require 'test_helper'

class SourceTest < Minitest::Test
  include TestHelpers

  def test_index
    with_config do |config|
      File.write(config.layout_dir.join("default.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("index.html"))

      assert_equal "index.html", source.relative_path.to_s
      assert_equal "index.html", source.dest_path.basename.to_s
      assert_equal ".", source.url.to_s
      assert_equal "Home", source.title
      assert_nil source.layout
      refute source.dynamic?
    end
  end

  def test_nested_index
    with_config do |config|
      File.write(config.layout_dir.join("default.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("foo", "bar", "index.html"))

      assert_equal "foo/bar/index.html", source.relative_path.to_s
      assert_equal "index.html", source.dest_path.basename.to_s
      assert_equal "foo/bar", source.url.to_s
      assert_equal "Bar", source.title
      assert_nil source.layout
      refute source.dynamic?
    end
  end

  def test_root_files
    with_config do |config|
      File.write(config.layout_dir.join("default.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("foo.html"))

      assert_equal "foo.html", source.relative_path.to_s
      assert_equal "foo.html", source.dest_path.basename.to_s
      assert_equal "foo.html", source.url.to_s
      assert_equal "Foo", source.title
      assert_nil source.layout
      refute source.dynamic?
    end
  end

  def test_nested_files
    with_config do |config|
      File.write(config.layout_dir.join("default.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("foo/bar/foo.html"))

      assert_equal "foo/bar/foo.html", source.relative_path.to_s
      assert_equal "foo.html", source.dest_path.basename.to_s
      assert_equal "foo/bar/foo.html", source.url.to_s
      assert_equal "Foo", source.title
      assert_nil source.layout
      refute source.dynamic?
    end
  end

  def test_files_with_layout
    with_config do |config|
      File.write(config.layout_dir.join("default.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("foo/bar/foo.default.html"))

      assert_equal "foo/bar/foo.default.html", source.relative_path.to_s
      assert_equal "foo.html", source.dest_path.basename.to_s
      assert_equal "foo/bar/foo.html", source.url.to_s
      assert_equal "Foo", source.title
      refute_nil source.layout
      assert_equal config.layout_cache["default.html"], source.layout
      assert source.dynamic?
    end
  end

  def test_md_files_with_layout
    with_config do |config|
      File.write(config.layout_dir.join("post.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("2025/01/01/my-post.post.md"))

      assert_equal "2025/01/01/my-post.post.md", source.relative_path.to_s
      assert_equal "my-post.html", source.dest_path.basename.to_s
      assert_equal "2025/01/01/my-post.html", source.url.to_s
      assert_equal "My Post", source.title
      refute_nil source.layout
      assert_equal config.layout_cache["post.html"], source.layout
      assert source.dynamic?
    end
  end

  def test_md_files
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("2025/01/01/my-post.md"))
      assert_equal "2025/01/01/my-post.md", source.relative_path.to_s
      assert_equal "my-post.html", source.dest_path.basename.to_s
      assert_equal "2025/01/01/my-post.html", source.url.to_s
      assert_equal "My Post", source.title
      assert_nil source.layout
      assert source.dynamic?
    end
  end

  def test_liquid_files_with_layout
    with_config do |config|
      File.write(config.layout_dir.join("post.html.liquid"), "")
      source = Yass::Source.new(config, config.src_dir.join("2025/01/01/my-post.post.html.liquid"))

      assert_equal "2025/01/01/my-post.post.html.liquid", source.relative_path.to_s
      assert_equal "my-post.html", source.dest_path.basename.to_s
      assert_equal "2025/01/01/my-post.html", source.url.to_s
      assert_equal "My Post", source.title
      refute_nil source.layout
      assert_equal config.layout_cache["post.html"], source.layout
      assert source.dynamic?
    end
  end

  def test_liquid_files
    with_config do |config|
      source = Yass::Source.new(config, config.src_dir.join("2025/01/01/my-post.html.liquid"))
      assert_equal "2025/01/01/my-post.html.liquid", source.relative_path.to_s
      assert_equal "my-post.html", source.dest_path.basename.to_s
      assert_equal "2025/01/01/my-post.html", source.url.to_s
      assert_equal "My Post", source.title
      assert_nil source.layout
      assert source.dynamic?
    end
  end
end
