module Sources
  class Base
    attr_reader :fs_path, :rel_path

    def initialize(path_str, src_dir)
      @fs_path = Pathname.new(path_str)
      @rel_path = @fs_path.relative_path_from(src_dir)
    end
  end
end
