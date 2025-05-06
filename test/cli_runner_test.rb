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
    end
  end
end
