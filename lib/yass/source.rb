require 'yaml'

module Yass
  class Source
    EXT_CONVERSIONS = {"md" => "html"}.freeze
    YAML_HEADER = /\A---\s*\n/
    FRONT_MATTER = /\A(?<matter>---\s*\n.*^---\s*\n?)(?<content>.+)?$/m

    attr_reader :site, :front_matter, :path, :src_path, :dest_path, :outfile

    def initialize(site, path)
      @site = site
      @path = path
      @src_path = path.relative_path_from site.src_dir
      @dest_path = src_path.dirname.join(dest_filename)
      @outfile = site.dest_dir.join(dest_path)

      @front_matter, @content = parse_content
      @title = front_matter.delete "title" if front_matter.key? "title"
      @layout_name = front_matter.delete "layout" if front_matter.key? "layout"
    end

    def layout
      return nil if @layout_name == false

      ext = dest_path.extname
      site.layout_cache["#{@layout_name}#{ext}"] || site.layout_cache["default#{ext}"]
    end

    def title
      return @title if @title

      fname = dest_path.basename.sub(/\..+$/, "").to_s
      fname = src_path.dirname.basename.to_s if fname == "index"
      fname = "Home" if fname == "."
      @title = fname.gsub(/[_-]+/, " ").split(/ +/).map(&:capitalize).join(" ")
    end

    def dynamic? = !!(/\.(liquid|md)(\..+)?$/ =~ path.basename.to_s || layout || @has_front_matter)

    def content = @content ||= path.read

    def published? = front_matter["published"].nil? ? true : !!front_matter["published"]

    def size = @size ||= File.stat(path).size

    private

    def dest_filename
      name, exts = path.basename.to_s.split(".", 2)
      exts = (exts || "").split(".").map { |x| EXT_CONVERSIONS[x] || x } - %w[liquid]
      [name, *exts].join(".")
    end

    def parse_content
      @has_front_matter = YAML_HEADER.match? path.read(10)
      return {}, nil unless @has_front_matter

      @has_front_matter = true
      captures = FRONT_MATTER.match(path.read).named_captures
      return YAML.safe_load(captures["matter"].to_s) || {}, captures["content"].to_s
    rescue Psych::SyntaxError => e
      site.stderr.puts "Error parsing front matter for #{path}: #{e.message}"
      return {}, ""
    end
  end
end
