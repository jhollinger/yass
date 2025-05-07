require 'erb'

module Yass
  class ErbTemplate
    def self.compile(src)
      compiler = ERB::Compiler.new("<>")
      compiler.pre_cmd = ["_erbout=+::Yass::HtmlSafeString.new"]
      compiler.put_cmd = "_erbout.safe_concat"
      compiler.insert_cmd = "_erbout.<<"
      compiler.post_cmd = ["_erbout"]
      code, _enc = compiler.compile(src)
      new code
    end

    def initialize(code)
      @code = code.freeze
    end

    def render(config, page, &)
      Context.new(config, page).render(@code, &)
    end

    class Context
      attr_reader :config, :page

      def initialize(config, page)
        @config = config
        @page = page
      end

      def raw(str) = HtmlSafeString.new(str)

      def template(name)
        t = config.template_cache.fetch(name)
        t.render(config, page)
      end

      def pages = files "**/*.{html,md}*"

      def files(glob = "**/*.*")
        paths = Dir[config.src_dir.join(glob)]
        paths.map { |path| Source.new(config, Pathname.new(path)) }
      end

      def relative_path_to(file)
        in_root = page.path.dirname.to_s == "."
        updirs = in_root ? [] : page.path.dirname.to_s.split("/").map { ".." }
        path = Pathname.new([*updirs, file].join("/"))
        path.basename.to_s == "index.html" && !config.local ? path.dirname : path
      end

      def render(code)
        _erbout = HtmlSafeString.new
        eval code, binding { yield }
      end
    end
  end
end
