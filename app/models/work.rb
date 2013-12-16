class Work < ActiveRecord::Base
	has_translations :title, :subtitle, :description, :credits, :synopsis, :program, :notes
end