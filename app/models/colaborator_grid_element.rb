class ColaboratorGridElement < ActiveRecord::Base
  belongs_to :colaborator

  mount_uploader :sprocket, SprocketUploader
end
