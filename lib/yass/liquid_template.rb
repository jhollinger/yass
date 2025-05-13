module Yass
  class LiquidTemplate
    def self.compile(config, filename, src)
      template = Liquid::Template.parse(src, environment: config.liquid_env)
      new(filename, template)
    end

    attr_reader :filename

    def initialize(filename, template)
      @filename = filename
      @template = template
    end

    def name = filename.sub(/\.liquid$/, "")

    def render(source)
      vars = { "page" => file_attrs(source), "files" => files_attrs(source.config.sources) }
      vars["content"] = yield if block_given?
      content = @template.render(vars, { strict_variables: true, strict_filters: true, registers: { source: source } })
      if @template.errors.any?
        source.config.stderr.puts "Errors found in #{filename}:"
        source.config.stderr.puts @template.errors.map { |e| "  #{e}" }.join("\n")
      end
      content
    end

    private

    def file_attrs(source)
      source.front_matter.merge({
        "title" => source.title,
        "layout" => source.layout&.name,
        "path" => source.dest_path.to_s,
        "src_path" => source.src_path.to_s,
        "dirname" => source.dest_path.dirname.to_s,
        "filename" => source.dest_path.basename.to_s,
        "extname" => source.dest_path.basename.extname,
        "filesize" => source.size,
      })
    end

    def files_attrs(sources) = sources.map { |s| file_attrs s }
  end
end
