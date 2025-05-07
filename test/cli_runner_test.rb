require 'test_helper'

class CliRunnerTest < Minitest::Test
  include TestHelpers

  def test_build
    with_config do |config|
      config.stderr = StringIO.new
      File.write(config.src_dir.join("index.html"), "")
      retval = Yass::CLI::Runner.build(config, argv: ["yass", config.root.to_s])

      config.stderr.rewind
      assert_equal "", config.stderr.read
      assert_equal 0, retval
      assert config.dest_dir.join("index.html").exist?
    end
  end

  def test_init
    Dir.mktmpdir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.stderr = StringIO.new
      config.stdout = StringIO.new
      retval = Yass::CLI::Runner.init(config, argv: ["yass", dir])

      config.stderr.rewind
      assert_equal "", config.stderr.read
      assert_equal 0, retval
      assert config.src_dir.exist?
      assert config.template_dir.exist?
      assert config.template_dir.join("layouts").exist?

      dir = Pathname.new(dir)
      init_dir = ::Yass::CLI::Runner::INIT_DIR
      expected_files = relative_paths(Dir[init_dir.join("**/*.*")], from: init_dir)
      created_files = relative_paths(Dir[dir.join("**/*.*")], from: dir)
      assert_equal expected_files, created_files
    end
  end
end
