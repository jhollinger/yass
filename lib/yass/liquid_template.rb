module Yass
  class LiquidTemplate
    def self.compile(src)
      template = Liquid::Template.parse(src)#, environment: TODO)
      new template
    end

    def initialize(template)
      @template = template
    end

    def render(config, page)
      # TODO pages, files
      vars = { "page" => page_attrs(page), "files" => files_attrs(config), "pages" => pages_attrs(config) }
      vars["content"] = yield if block_given?
      content = @template.render(vars, { strict_variables: true, strict_filters: true })
      # TODO @template.errors
      content
    end

    private

    def page_attrs(page) = { "title" => page.title, "url" => page.url.to_s, "path" => page.path.to_s }

    def pages_attrs(config) = [] # TODO

    def files_attrs(config) = [] # TODO
  end
end
