class Book < ActiveRecord::Base
  attr_accessible :author, :isbn, :picture, :publisher, :title, :user_id, :goodreadscover

  # :picture is user uploaded picture of book cover, :goodreadscover is goodreads picture of book cover
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



# am using before_create here.. it works but if user enters a bad isbn, the app blows up
  # if not :isbn.blank?

  #   before_create do 
  #     client = Goodreads.new

      #how is self understood here? -seems to be regarded as an instance .self rather than class. would it be understood in controller in same way? 

      # book = client.book_by_isbn(self.isbn)
      # self.title = book.title if self.title.blank?
      # if self.author.blank?
      #   if book.authors.author.is_a?(Array)
      #     self.author = book.authors.author[0].name
      #   else 
      #     self.author = book.authors.author.name
      #   end
      # end

      # if self.publisher.blank?
      #   self.publisher = book.publisher
      # end
      # something interesting to try later when add description column to books table. Uses the sanitize gem
      # self.description = Sanitize.clean(book.description) if self.description.blank?

  #     self.goodreadscover= book.image_url
         
  #   end
  # end

#checking out lydia's solution for when an isbn doesn't exist - preventing the app from blowing up when isbn is bad
     before_save do |book|
        if book[:isbn].present?
            # initializes access to Goodreads with authentication. 
        client = Goodreads.new
            # this begin/rescue pair tests for errors if goodreads does not return 
            # any book information and allows the user to enter the data manually.
            begin

            # this block checks to see if an ISBN was provided. If it was, any empty field 
            # is populated with Goodreads data.

            if client.book_by_isbn(book[:isbn]).is_a?(Hashie::Mash)
              @goodreadbook = client.book_by_isbn(book[:isbn])
                # this is for debugging purposes and is not visible to the user
                puts @goodreadbook["authors"]
                # these blocks test to see if the user has provided details. If they did, 
                # the manual data overrides the goodreads data
                if book[:author].present? == false
                    if @goodreadbook["authors"]["author"].is_a?(Array)
                     # goodreads returns author information differently depending on how 
                     # many authors there are. This block solves for errors.
                        book[:author]=@goodreadbook["authors"]["author"][0]["name"]
                    else
                        book[:author]=@goodreadbook["authors"]["author"]["name"]
                    end
                end
                if book[:title].present? == false
                   book[:title]=@goodreadbook["title"]
                end

                # Me - commented out since I'm not using a description column
                # if book[:description].present? == false
                    #Sanitize is a sweet gem that removes the html tags that are returned 
                    #in the desciption from goodreads
                #    book[:description]= Sanitize.clean(@goodreadbook["description"])
                # end

                if book[:publisher].present? == false
                   book[:publisher]=@goodreadbook["publisher"]
                end

                # if book[:year].present? == false
                #    book[:year]=@goodreadbook["work"]["original_publication_year"]
                # end

                # :picture is user uploaded img, :goodreadscover is the picture from goodreads
                if book[:picture].present? == false
                   book[:goodreadscover]=@goodreadbook["image_url"]
                end 
            end   

            rescue 
            end
        end
  end

end
