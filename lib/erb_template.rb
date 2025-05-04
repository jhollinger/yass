require 'erb'

class ErbTemplate
  def self.compile(src)
    compiler = ERB::Compiler.new("<>")
    compiler.pre_cmd = ["_erbout=+HtmlSafeString.new"]
    compiler.put_cmd = "_erbout.safe_concat"
    compiler.insert_cmd = "_erbout.<<"
    compiler.post_cmd = ["_erbout"]
    code, _enc = compiler.compile(src)
    new code
  end

  def initialize(code)
    @code = code.freeze
  end

  def result(bind)
    _erbout = HtmlSafeString.new
    eval @code, bind
  end
end
