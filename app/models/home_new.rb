class HomeNew < ActiveRecord::Base
  belongs_to :new

  mount_uploader :img_link, HomeNewLinkUploader
end
