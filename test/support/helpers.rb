require 'fileutils'

module TestHelpers
  def with_config
    Dir.mktmpdir do |dir|
      config = Yass::CLI::Helpers.default_config
      config.root = Pathname.new(dir)
      FileUtils.mkdir_p config.src_dir
      FileUtils.mkdir_p config.template_dir.join("layouts")
      FileUtils.mkdir_p config.dest_dir
      yield config
    end
  end
end
