class Book < ActiveRecord::Base
  attr_accessible :author, :isbn, :picture, :publisher, :title, :user_id

  mount_uploader :picture, PictureUploader

  belongs_to :user

  #working on adding before_create callback THIS IS THE NONWORKING VERSION. I thought @book would be understood because declared in books controller.. but no
  # before_create do
    # self.name = login.capitalize if name.blank?

    # client = Goodreads.new

    #params not understood here
    # book_info = client.book_by_isbn(params[:book][:isbn])

  #   @book.title = book_info.title if @book.title.blank?
  # end



  if not :isbn.blank?

    before_create do 
      client = Goodreads.new

      #how is self understood here? -seems to be regarded as an instance .self rather than class. would it be understood in controller in same way? 
      book = client.book_by_isbn(self.isbn)
      self.title = book.title if self.title.blank?
      if self.author.blank?
        if book.authors.author.is_a?(Array)
          self.author = book.authors.author[0].name
        else 
          self.author = book.authors.author.name
        end
      end
      # something interesting to try later when add description column to books table. Uses the sanitize gem
      # self.description = Sanitize.clean(book.description) if self.description.blank?
      self.picture = book.image_url
    end
  end
end
