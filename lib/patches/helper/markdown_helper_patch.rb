module Pwfmt::MarkdownHelperPatch
  include Pwfmt::Helper

  def wikitoolbar_for(field_id, preview_url = preview_text_path)
    super(field_id, preview_url) + javascript_tag(pwfmt_select_script(field_id, 'markdown'))
  end
end

Redmine::WikiFormatting::Markdown::Helper.prepend(Pwfmt::MarkdownHelperPatch)
