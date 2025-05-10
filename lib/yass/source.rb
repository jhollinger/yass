module Yass
  class Source
    EXT_CONVERSIONS = {"md" => "html"}.freeze
    attr_reader :config, :path, :layout, :src_path, :dest_path, :outfile

    def initialize(config, path)
      @config = config
      @path = path
      @src_path = path.relative_path_from config.src_dir
      dest_filename, @layout = parse_name
      @dest_path = src_path.dirname.join(dest_filename)
      @outfile = config.dest_dir.join(dest_path)
    end

    def title
      fname = dest_path.basename.sub(/\..+$/, "").to_s
      fname = src_path.dirname.basename.to_s if fname == "index"
      fname = "Home" if fname == "."
      fname.sub(/[_-]+/, " ").split(/ +/).map(&:capitalize).join(" ")
    end

    def dynamic? = !!(/\.(liquid|md)(\..+)?$/ =~ path.basename.to_s || layout)

    private

    def parse_name
      name, exts = path.basename.to_s.split(".", 2)
      return name, nil if exts.nil?

      exts = exts.split(".").map { |x| EXT_CONVERSIONS[x] || x } - %w[liquid]
      return "#{name}.#{exts[0]}", config.layout_cache["default.#{exts[0]}"] if exts.size == 1

      layout = config.layout_cache["#{exts[-2..].join(".")}"]
      exts.delete_at(-2) if layout
      layout ||= config.layout_cache["default.#{exts[-1]}"]

      return "#{name}.#{exts.join "."}", layout
    end
  end
end
