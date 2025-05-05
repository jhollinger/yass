module YASS
  module Sources
    class Base
      attr_reader :config, :fs_path, :rel_path

      def initialize(config, path_str)
        @config = config
        @fs_path = Pathname.new(path_str)
        @rel_path = @fs_path.relative_path_from(config.src_dir)
      end
    end
  end
end
