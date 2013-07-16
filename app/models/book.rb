class Book < ActiveRecord::Base
  attr_accessible :author, :isbn, :picture, :publisher, :title
end
