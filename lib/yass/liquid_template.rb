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
      content = @template.render(vars, { strict_variables: true, strict_filters: true })
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
        "url" => source.url.to_s,
        "path" => source.relative_path.dirname.join(source.rendered_filename).to_s,
        "src_path" => source.relative_path.to_s,
        "dirname" => source.relative_path.dirname.to_s,
        "filename" => source.rendered_filename,
        "extname" => source.rendered_filename[/\.[^.]+$/],
      }
    end

    def files_attrs(sources) = sources.map { |s| file_attrs s }
  end
end
