require 'test_helper'

class CliRunnerTest < Minitest::Test
  include TestHelpers

  def test_build
    with_config do |config|
      config.stderr = StringIO.new
      File.write(config.src_dir.join("index.html"), "")
      retval = Yass::CLI::Runner.build(config, argv: ["yass", config.cwd.to_s])

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

      dir = Pathname.new(dir)
      init_dir = ::Yass::CLI::Runner::INIT_DIR
      expected_files = relative_paths(Dir[init_dir.join("**/*.*")], from: init_dir).map(&:to_s)
      created_files = relative_paths(Dir[dir.join("**/*.*")], from: dir).map(&:to_s)
      assert_operator expected_files.size, :>, 0
      assert_equal expected_files, created_files
    end
  end

  def test_watch
    skip unless ENV["TEST_WATCH"] == "1"
    with_config do |config|
      config.stderr = StringIO.new
      config.stdout = StringIO.new
      dest_files = -> {
        Dir[config.dest_dir.join("**/*.*")].map { |f| Pathname.new(f).relative_path_from config.dest_dir }
      }

      retval = nil
      watcher = nil
      Thread.new do
        retval = Yass::CLI::Runner.watch(config, argv: ["yass", config.cwd.to_s]) do |w|
          watcher = w
        end
      end
      sleep 0.25

      template_path = config.template_dir.join("title.liquid")
      File.write(template_path, "<h1>{{ page.title }}</h1>")
      sleep 0.5

      layout_path = config.layout_dir.join("page.html.liquid")
      File.write(layout_path, "<html><body>{{ content }}</body></html>")
      sleep 0.5

      index_path = config.src_dir.join("index.page.html.liquid")
      index_dest_path = config.dest_dir.join("index.html")
      File.write(index_path, '{% render "title", page: page %}<p>Some content</p>')
      sleep 0.5

      assert_equal ["index.html"].sort, dest_files.call.map(&:to_s).sort
      assert_equal "<html><body><h1>Home</h1><p>Some content</p></body></html>", index_dest_path.read

      File.write(index_path, '{% render "title", page: page %}<p>Some other content</p>')
      sleep 0.5
      assert_equal "<html><body><h1>Home</h1><p>Some other content</p></body></html>", index_dest_path.read

      styles_path = config.src_dir.join("styles.css")
      File.write(styles_path, "")
      sleep 0.5
      assert_equal ["index.html", "styles.css"].sort, dest_files.call.map(&:to_s).sort

      watcher.stop
      sleep 0.5
      assert_equal 0, retval

      config.stdout.rewind
      assert_equal [
        "Watching for changes...",
        "Building #{template_path.relative_path_from config.cwd}",
        "Building #{layout_path.relative_path_from config.cwd}",
        "Building #{index_path.relative_path_from config.cwd}",
        "Building #{index_path.relative_path_from config.cwd}",
        "Building #{styles_path.relative_path_from config.cwd}",
      ], config.stdout.readlines.map(&:chomp)

      config.stderr.rewind
      assert_equal "", config.stderr.read.chomp

    end
  end
end
