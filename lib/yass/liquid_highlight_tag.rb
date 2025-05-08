module Yass
  class LiquidHighlightTag < Liquid::Block
    attr_reader :lang

    def initialize(_tag_name, lang, _tokens)
      super
      @lang = lang.strip
    end

    def render(_context)
      %(<pre><code class="language-#{lang}">#{super}</code></pre>)
    end
  end
end
