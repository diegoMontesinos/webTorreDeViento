class ColaboratorGridElement < ActiveRecord::Base
  belongs_to :colaborator

  mount_uploader :sprocket, SprocketUploader
  mount_uploader :sprocket2, SprocketUploader
end
