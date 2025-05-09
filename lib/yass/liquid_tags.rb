module Yass
  module LiquidTags
    # Works like `render`, but passes the block content to the template as a variable named `content`
    class RenderContent < Liquid::Block
      def render(context)
        context.stack({}) do
          context["block_content"] = super
          r = Liquid::Render.parse("render", "#{@markup}, content: block_content", nil, @parse_context)
          r.render_tag(context, +"")
        end
      end
    end

    # Wraps the block content in HTML for Highlight.js
    class Highlight < Liquid::Block
      def render(_context) = %(<pre><code class="language-#{@markup.strip}">#{super}</code></pre>)
    end
  end
end
