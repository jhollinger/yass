require 'erb'

class ErbTemplate
  def self.compile(src)
    compiler = ERB::Compiler.new("<>")
    compiler.pre_cmd = ["_erbout=+HtmlSafeString.new"]
    compiler.put_cmd = "_erbout.safe_concat"
    compiler.insert_cmd = "_erbout.<<"
    compiler.post_cmd = ["_erbout"]
    code, _enc = compiler.compile(src)
    code
  end

  def initialize(code)
    @code = code.freeze
  end

  def render(options = {})
    context = Context.new(options)
    eval @code, context.binding
  end

  class Context
    def initialize(options)
      @options = options
    end

    def pages
      [] # TODO
    end

    def raw(str) = HtmlSafeString.new(str)
  end
end
