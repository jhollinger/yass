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
      site = Yass::Site.new(config)

      assert_equal dir, site.cwd.to_s
      assert_equal File.join(dir, "site"), site.src_dir.to_s
      assert_equal File.join(dir, "layouts"), site.layout_dir.to_s
      assert_equal File.join(dir, "templates"), site.template_dir.to_s
      assert_equal File.join(dir, "dist"), site.dest_dir.to_s
    end
  end

  def test_get_working_dir_default_with_relative_sibling_dest
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.dest = "dist2"
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      site = Yass::Site.new(config)

      assert_equal dir, site.cwd.to_s
      assert_equal File.join(dir, "site"), site.src_dir.to_s
      assert_equal File.join(dir, "layouts"), site.layout_dir.to_s
      assert_equal File.join(dir, "templates"), site.template_dir.to_s
      assert_equal File.join(dir, "dist2"), site.dest_dir.to_s
    end
  end

  def test_get_working_dir_default_with_relative_dest_above
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.dest = "../dist2"
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      site = Yass::Site.new(config)

      assert_equal dir, site.cwd.to_s
      assert_equal File.join(dir, "site"), site.src_dir.to_s
      assert_equal File.join(dir, "layouts"), site.layout_dir.to_s
      assert_equal File.join(dir, "templates"), site.template_dir.to_s
      assert_equal Pathname.new(dir).dirname.join("dist2").to_s, site.dest_dir.to_s
    end
  end

  def test_get_working_dir_default_with_absolute_dest
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.dest = "/tmp/dist"
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass]
      site = Yass::Site.new(config)

      assert_equal dir, site.cwd.to_s
      assert_equal File.join(dir, "site"), site.src_dir.to_s
      assert_equal File.join(dir, "layouts"), site.layout_dir.to_s
      assert_equal File.join(dir, "templates"), site.template_dir.to_s
      assert_equal "/tmp/dist", site.dest_dir.to_s
    end
  end

  def test_get_working_dir_absolute
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass /tmp/foo]
      site = Yass::Site.new(config)

      assert_equal "/tmp/foo", site.cwd.to_s
      assert_equal "/tmp/foo/site", site.src_dir.to_s
      assert_equal "/tmp/foo/layouts", site.layout_dir.to_s
      assert_equal "/tmp/foo/templates", site.template_dir.to_s
      assert_equal "/tmp/foo/dist", site.dest_dir.to_s
    end
  end

  def test_get_working_dir_relative_below
    in_temp_dir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass foo]
      site = Yass::Site.new(config)

      assert_equal File.join(dir, "foo"), site.cwd.to_s
      assert_equal File.join(dir, "foo", "site"), site.src_dir.to_s
      assert_equal File.join(dir, "foo", "layouts"), site.layout_dir.to_s
      assert_equal File.join(dir, "foo", "templates"), site.template_dir.to_s
      assert_equal File.join(dir, "foo", "dist"), site.dest_dir.to_s
    end
  end

  def test_get_working_dir_relative_above
    in_temp_dir do |dir|
      parent_dir = Pathname.new(dir).dirname
      config = Yass::CLI::Helpers.default_config
      config.cwd = Yass::CLI::Helpers.get_working_dir! %w[yass ../foo]
      site = Yass::Site.new(config)

      assert_equal parent_dir.join("foo").to_s, site.cwd.to_s
      assert_equal parent_dir.join("foo", "site").to_s, site.src_dir.to_s
      assert_equal parent_dir.join("foo", "layouts").to_s, site.layout_dir.to_s
      assert_equal parent_dir.join("foo", "templates").to_s, site.template_dir.to_s
      assert_equal parent_dir.join("foo", "dist").to_s, site.dest_dir.to_s
    end
  end

  private

  def get_site(argv)
    config = Yass::CLI::Helpers.default_config
    config.cwd = Yass::CLI::Helpers.get_working_dir! argv
    Yass::Site.new(config)
  end
end
