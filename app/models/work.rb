class Work < ActiveRecord::Base
	has_translations :titles_text, :credits, :synopsis, :program, :notes
end