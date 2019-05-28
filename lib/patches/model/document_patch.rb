# This patch extends document that allows load and save wiki format of description
module Pwfmt::DocumentPatch
  extend ActiveSupport::Concern

  included do
    after_save :persist_wiki_format
  end

  # load wiki format of description from database
  def load_wiki_format!
    pwfmt = PwfmtFormat.where(target_id: self.id, field: 'document_description').first
    description.wiki_format = pwfmt.format if description && pwfmt
  end

  # save wiki format of description to database.
  def persist_wiki_format
    PwfmtFormat.persist(self, 'document_description')
  end
end

require 'document'
Document.__send__(:include, Pwfmt::DocumentPatch)
