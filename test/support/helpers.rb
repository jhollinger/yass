require 'fileutils'

module TestHelpers
  def with_config
    Dir.mktmpdir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.root = Pathname.new(dir)
      FileUtils.mkdir_p config.src_dir
      FileUtils.mkdir_p config.layout_dir
      FileUtils.mkdir_p config.template_dir
      FileUtils.mkdir_p config.dest_dir
      yield config
    end
  end

  def relative_paths(paths, from:)
    paths.map do |path|
      Pathname.new(path).relative_path_from(from)
    end
  end
end
