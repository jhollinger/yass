module Yass
  class LiquidTemplate
    def self.compile(config, name, src)
      template = Liquid::Template.parse(src, environment: config.liquid_env)
      new(name, template)
    end

    attr_reader :name

    def initialize(name, template)
      @name = name
      @template = template
    end

    def render(source)
      vars = { "page" => file_attrs(source), "files" => files_attrs(source.config.sources) }
      vars["content"] = yield if block_given?
      content = @template.render(vars, { strict_variables: true, strict_filters: true, registers: { source: source } })
      if @template.errors.any?
        source.config.stderr.puts "Errors found in #{name}:"
        source.config.stderr.puts @template.errors.map { |e| "  #{e}" }.join("\n")
      end
      content
    end

    private

    def file_attrs(source)
      {
        "title" => source.title,
        "path" => source.dest_path.to_s,
        "src_path" => source.src_path.to_s,
        "dirname" => source.dest_path.dirname.to_s,
        "filename" => source.dest_path.basename.to_s,
        "extname" => source.dest_path.basename.extname,
        "filesize" => File.stat(source.path).size,
      }
    end

    def files_attrs(sources) = sources.map { |s| file_attrs s }
  end
end
