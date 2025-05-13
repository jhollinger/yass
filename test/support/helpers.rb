require 'fileutils'

module TestHelpers
  def with_config
    Dir.mktmpdir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Pathname.new(dir)
      FileUtils.mkdir_p config.src_dir
      FileUtils.mkdir_p config.layout_dir
      FileUtils.mkdir_p config.template_dir
      FileUtils.mkdir_p config.dest_dir
      yield config
    end
  end

  def in_temp_dir
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        yield Dir.pwd
      end
    end
  end

  def relative_paths(paths, from:)
    paths.map do |path|
      Pathname.new(path).relative_path_from(from)
    end
  end

  def create(config, path, data = "")
    FileUtils.mkdir_p path.dirname unless path.dirname.exist?
    File.write(path, data)
    Yass::Source.new(config, path)
  end
end
