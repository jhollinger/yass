require 'test_helper'

class CliHelpersTest < Minitest::Test
  include TestHelpers

  def test_get_cmd
    assert_equal :build, Yass::CLI::Helpers.get_cmd(["build"])
    assert_equal :build, Yass::CLI::Helpers.get_cmd(["build", "foo"])
  end

  def test_find_path_relative
    dest = "dist"
    assert_equal "/home/foo/blog/dist", Yass::CLI::Helpers.find_path(dest, cwd: "/home/foo/blog").to_s
    assert_equal "foo/blog/dist", Yass::CLI::Helpers.find_path(dest, cwd: "foo/blog").to_s
  end

  def test_find_path_relative_above
    dest = "../blog-dist"
    assert_equal "/home/foo/blog-dist", Yass::CLI::Helpers.find_path(dest, cwd: "/home/foo/blog").to_s
    assert_equal "foo/blog-dist", Yass::CLI::Helpers.find_path(dest, cwd: "foo/blog").to_s
  end

  def test_find_path_relative_below
    dest = "dist/real-dist"
    assert_equal "/home/foo/blog/dist/real-dist", Yass::CLI::Helpers.find_path(dest, cwd: "/home/foo/blog").to_s
    assert_equal "foo/blog/dist/real-dist", Yass::CLI::Helpers.find_path(dest, cwd: "foo/blog").to_s
  end

  def test_find_path_absolute
    dest = "/srv/blog"
    assert_equal "/srv/blog", Yass::CLI::Helpers.find_path(dest, cwd: "/home/foo/blog").to_s
    assert_equal "/srv/blog", Yass::CLI::Helpers.find_path(dest, cwd: "foo/blog").to_s
  end

  def test_get_working_dir_default
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      assert_equal dir, config.cwd.to_s
      assert_equal File.join(dir, "site"), config.src_dir.to_s
      assert_equal File.join(dir, "layouts"), config.layout_dir.to_s
      assert_equal File.join(dir, "templates"), config.template_dir.to_s
      assert_equal File.join(dir, "dist"), config.dest_dir.to_s
    end
  end

  def test_get_working_dir_default_with_relative_sibling_dest
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.dest = "dist2"
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      assert_equal dir, config.cwd.to_s
      assert_equal File.join(dir, "site"), config.src_dir.to_s
      assert_equal File.join(dir, "layouts"), config.layout_dir.to_s
      assert_equal File.join(dir, "templates"), config.template_dir.to_s
      assert_equal File.join(dir, "dist2"), config.dest_dir.to_s
    end
  end

  def test_get_working_dir_default_with_relative_dest_above
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.dest = "../dist2"
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      assert_equal dir, config.cwd.to_s
      assert_equal File.join(dir, "site"), config.src_dir.to_s
      assert_equal File.join(dir, "layouts"), config.layout_dir.to_s
      assert_equal File.join(dir, "templates"), config.template_dir.to_s
      assert_equal Pathname.new(dir).dirname.join("dist2").to_s, config.dest_dir.to_s
    end
  end

  def test_get_working_dir_default_with_absolute_dest
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.dest = "/tmp/dist"
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      assert_equal dir, config.cwd.to_s
      assert_equal File.join(dir, "site"), config.src_dir.to_s
      assert_equal File.join(dir, "layouts"), config.layout_dir.to_s
      assert_equal File.join(dir, "templates"), config.template_dir.to_s
      assert_equal "/tmp/dist", config.dest_dir.to_s
    end
  end

  def test_get_working_dir_absolute
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass /tmp/foo]
      assert_equal "/tmp/foo", config.cwd.to_s
      assert_equal "/tmp/foo/site", config.src_dir.to_s
      assert_equal "/tmp/foo/layouts", config.layout_dir.to_s
      assert_equal "/tmp/foo/templates", config.template_dir.to_s
      assert_equal "/tmp/foo/dist", config.dest_dir.to_s
    end
  end

  def test_get_working_dir_relative_below
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass foo]
      assert_equal File.join(dir, "foo"), config.cwd.to_s
      assert_equal File.join(dir, "foo", "site"), config.src_dir.to_s
      assert_equal File.join(dir, "foo", "layouts"), config.layout_dir.to_s
      assert_equal File.join(dir, "foo", "templates"), config.template_dir.to_s
      assert_equal File.join(dir, "foo", "dist"), config.dest_dir.to_s
    end
  end

  def test_get_working_dir_relative_above
    in_temp_dir do |dir|
      parent_dir = Pathname.new(dir).dirname
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass ../foo]
      assert_equal parent_dir.join("foo").to_s, config.cwd.to_s
      assert_equal parent_dir.join("foo", "site").to_s, config.src_dir.to_s
      assert_equal parent_dir.join("foo", "layouts").to_s, config.layout_dir.to_s
      assert_equal parent_dir.join("foo", "templates").to_s, config.template_dir.to_s
      assert_equal parent_dir.join("foo", "dist").to_s, config.dest_dir.to_s
    end
  end
end
