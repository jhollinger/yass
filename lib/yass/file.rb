module YASS
  class File
    attr_reader :config, :path

    def initialize(config, path)
      @config = config
      @path = path
    end

    def title
      fname = path.basename.sub(/\..+$/, "")
      fname = path.dirname.basename if fname.to_s == "index"
      fname = "" if fname.to_s == "."
      fname = fname.to_s.sub(/[_-]+/, " ")
      fname.split(/ +/).map(&:capitalize).join(" ")
    end

    def url
      config.local ? final_path : final_path.sub(/index\.html$/, "")
    end

    def final_path
      fname = path.basename.sub(/\.md/, "").sub(/\.erb/, "").to_s
      path.dirname.join(fname)
    end

    def relative_path_to(target_path)
      in_root = path.dirname.to_s == "."
      updirs = in_root ? [] : path.dirname.to_s.split("/").map { ".." }
      Pathname.new([*updirs, target_path].join("/"))
    end
  end
end
