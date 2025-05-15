module Yass
  class LiquidTemplate
    def self.compile(site, filename, src)
      template = Liquid::Template.parse(src, environment: site.liquid_env)
      new(filename, template)
    end

    attr_reader :filename

    def initialize(filename, template)
      @filename = filename
      @template = template
    end

    def name = filename.sub(/\.liquid$/, "")

    def render(source)
      vars = {}
      vars["page"] = SourceDrop.new(source)
      vars["files"] = source.site.sources.map { |s| SourceDrop.new(s) }
      vars["content"] = yield if block_given?

      content = @template.render(vars, { strict_variables: true, strict_filters: true, registers: { source: source } })
      if @template.errors.any?
        source.site.stderr.puts "Errors found in #{filename}:"
        source.site.stderr.puts @template.errors.map { |e| "  #{e}" }.join("\n")
      end
      content
    end

    class SourceDrop < Liquid::Drop
      def initialize(source) = @source = source

      def title = @source.title

      def layout = @source.layout&.name

      def path = @source.dest_path.to_s

      def src_path = @source.src_path.to_s

      def dirname = @source.dest_path.dirname.to_s

      def filename = @source.dest_path.basename.to_s

      def extname = @source.dest_path.extname.to_s

      def filesize = @source.size

      def published = @source.published?

      def content = @source.content

      def method_missing(attr) = @source.front_matter[attr.to_s]
    end
  end
end
