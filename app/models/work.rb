class Work < ActiveRecord::Base
	has_translations :titles_text, :credits, :synopsis, :program, :notes

	has_many :file_folders, as: :holdable
	accepts_nested_attributes_for :file_folders, :allow_destroy => true

end