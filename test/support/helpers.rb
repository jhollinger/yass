require 'fileutils'

module TestHelpers
  def with_site
    with_config { |config| Yass::Site.new(config.dup.freeze) }
  end

  def with_config
    Dir.mktmpdir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.cwd = Pathname.new(dir)
      site = Yass::Site.new(config)
      FileUtils.mkdir_p site.src_dir
      FileUtils.mkdir_p site.layout_dir
      FileUtils.mkdir_p site.template_dir
      FileUtils.mkdir_p site.dest_dir
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
