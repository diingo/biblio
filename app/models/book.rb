class Book < ActiveRecord::Base
  attr_accessible :author, :isbn, :picture, :publisher, :title

  mount_uploader :picture, PictureUploader
end
