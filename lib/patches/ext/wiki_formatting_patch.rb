module Pwfmt
  # This patch extends Redmine::WikiFormatting module.
  module WikiFormattingPatch
    # render html with self format instead of setting.
    def to_html(format, text, options = {})
      if text.respond_to?(:wiki_format) && Redmine::WikiFormatting.format_names.include?(text.wiki_format)
        super(text.wiki_format, text, options).tap do |result|
          result.wiki_format = text.wiki_format
        end
      else
        super(format, text, options)
      end
    end
  end
end

Redmine::WikiFormatting.singleton_class.prepend(Pwfmt::WikiFormattingPatch)

module Redmine::WikiFormatting::Macros::Definitions
  alias __exec_macro__ exec_macro

  # Propagate 'wiki_format' to inner content of collapse macro.
  def exec_macro(name, obj, args, text, options={})
    if name == 'collapse'
      text.wiki_format = options[:wiki_format]
    end
    __exec_macro__(name, obj, args, text, options)
  end
end
