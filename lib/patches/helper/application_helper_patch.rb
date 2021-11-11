module Pwfmt
  # This patch extends ApplicationHelper.
  module ApplicationHelperPatch
    # truncate_lines returns new string instance, so need to reset wiki fortmat.
    def truncate_lines(string, options = {})
      fmt = string.wiki_format
      super(string, options).tap do |s|
        s.wiki_format = fmt if fmt
      end
    end
  end
end

require 'application_helper'
ApplicationHelper.prepend(Pwfmt::ApplicationHelperPatch)

module ApplicationHelper
  alias __parse_non_pre_blocks__ parse_non_pre_blocks

  # propagate 'wiki_format' to macro expansion.
  def parse_non_pre_blocks(text, obj, macros, options={}, &block)
    if text.respond_to?(:wiki_format)
      options[:wiki_format] = text.wiki_format
    end
    __parse_non_pre_blocks__(text, obj, macros, options, &block)
  end
end
