class FileFolder < ActiveRecord::Base
	belongs_to :holdable, polymorphic: true

	has_many :photos
end