class BooksController < ApplicationController
  # before_filter :authenticate_user!

  # GET /books
  # GET /books.json
  def index
    # @books = Book.all
    
    if current_user.present?
      # why set @user to current_user.id instead of just sticking current_user.id into Book.where
      @user = current_user.id
      @books = Book.where(user_id: @user)
    else
      @books = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new

    # This puts "My fancy title" in the blank title field
    # @book = Book.new :title => "My fancy title"

    @book = Book.new 

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json

  def create
    @book = Book.new(params[:book])
    @book.user_id = current_user.id
    # can alternatively use:
    # @book = current_user.books.build(params[:book])

    # I used the below code before I had added before_create to book model
    # client = Goodreads.new
    # book_info = client.book_by_isbn(params[:book][:isbn])
    # @book.title = book_info.title if @book.title.blank?
    


    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])
    @book.attributes = params[:book]
    # a break point for debugging:
    # debugger
    client = Goodreads.new
    book_info = client.book_by_isbn(params[:book][:isbn])
    @book.title = book_info.title if @book.title.blank?
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end
end
