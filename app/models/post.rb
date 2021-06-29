class Post < ApplicationRecord
  mount_uploader :picture, ImageUploader
  belongs_to :user
end
