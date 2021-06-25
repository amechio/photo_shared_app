class Post < ApplicationRecord
  mount_uploader :picture, ImageUploader
end
