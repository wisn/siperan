class StaffController < ApplicationController
  def index
    redirect_if_not_staff

    redirect_to :staff_dashboard
  end

  def login
    redirect_if_staff

    redirect_if_admin
  end

  def login_validation
    redirect_if_staff

    @staff = Staff.new login_params
    if @staff.valid? :login
      @staff = Staff.find_by username: login_params['username']
      if @staff and @staff.authenticate(login_params['password'])
        create_session @staff
        redirect_to :staff_dashboard
      else
        @staff = Staff.new
        @staff.errors.message[:account] = ['does not exists']

        render 'login'
      end
    else
      render 'login'
    end
  end

  def dashboard
    redirect_if_not_staff

    @visitors_total = Visitor.count
    @books_total = Book.count
    @transactions_total = Transaction.count
  end

  def logout
    session.delete :user_type
    session.delete :user_data

    redirect_to :staff_login
  end

  def change_password
    redirect_if_not_staff
  end

  def change_password_validation
    @staff = Staff.new change_password_params
    @staff.username = session[:user_data]['username']

    if @staff.valid? :reset_password
      password = @staff.password

      @staff = Staff.find_by username: @staff.username
      @staff.password = password

      if @staff.save
        logout
      else
        @staff.errors.messages[:server] = ['encounter a problem']
      end
    else
      render 'change_password'
    end
  end

  def manage_visitor
    redirect_if_not_staff

    @visitor = Visitor.all
  end

  def new_visitor
    redirect_if_not_staff
  end

  def new_visitor_validation
    @visitor = Visitor.new new_visitor_params
    if @visitor.save context: :adds
      redirect_to :staff_manage_visitor
    else
      render 'new_visitor'
    end
  end

  def edit_visitor
    redirect_if_not_staff

    visitor = Visitor.find_by username: params[:username]
    if visitor.present?
      @visitor = visitor
    else
      redirect_to :staff_manage_visitor
    end
  end

  def edit_visitor_validation
    username = params[:username]
    visitor = Visitor.find_by username: username
    if visitor.present?
      params = edit_visitor_params
      visitor.fullname = params[:fullname]
      visitor.age = params[:age]

      if visitor.save context: :edits
        redirect_to :staff_manage_visitor
      else
        @visitor = visitor
        render 'edit_visitor'
      end
    else
      redirect_to :staff_manage_visitor
    end
  end

  def remove_visitor
    visitor = Visitor.find_by username: params[:username]
    visitor.delete if visitor.present?

    redirect_to :staff_manage_visitor
  end
  
  def manage_book
    redirect_if_not_staff

    @book = Book.all
  end

  def new_book
    redirect_if_not_staff
  end

  def new_book_validation
    @book = Book.new new_book_params
    if @book.save context: :adds
      redirect_to :staff_manage_book
    else
      render 'new_book'
    end
  end

  def edit_book
    redirect_if_not_staff

    book = Book.find_by isbn: params[:isbn]
    if book.present?
      @book = book
    else
      redirect_to :staff_manage_book
    end
  end

  def edit_book_validation
    isbn = params[:isbn]
    book = Book.find_by isbn: isbn
    if book.present?
      params = edit_book_params
      book.title = params[:title]
      book.author = params[:author]
      book.synopsis = params[:synopsis]

      if book.save context: :edits
        redirect_to :staff_manage_book
      else
        @book = book
        render 'edit_book'
      end
    else
      redirect_to :staff_manage_book
    end
  end

  def manage_transaction
    redirect_if_not_staff

    @transaction = Transaction.all
  end

  def new_borrowing
    redirect_if_not_staff
  end

  def new_borrowing_validation
    if Visitor.find_by(username: transaction_params[:visitor_username]).present?
      if Book.find_by(isbn: transaction_params[:book_isbn]).present?
        @transaction = Transaction.new transaction_params
        @transaction.staff_username = session[:user_data]['username']
        @transaction.is_borrowing = true

        if @transaction.save context: :transaction
          redirect_to :staff_manage_transaction
        else
          render 'new_borrowing'
        end
      else
        @transaction = Transaction.new
        @transaction.errors.messages[:book_isbn] = ['does not exists']

        render 'new_borrowing'
      end
    else
      @transaction = Transaction.new
      @transaction.errors.messages[:visitor_username] = ['does not exists']

      render 'new_borrowing'
    end
  end

  def new_returning
    redirect_if_not_staff
  end

  def new_returning_validation
    if Visitor.find_by(username: transaction_params[:visitor_username]).present?
      if Book.find_by(isbn: transaction_params[:book_isbn]).present?
        @transaction = Transaction.new transaction_params
        @transaction.staff_username = session[:user_data]['username']
        @transaction.is_borrowing = false

        if @transaction.save context: :transaction
          redirect_to :staff_manage_transaction
        else
          render 'new_returning'
        end
      else
        @transaction = Transaction.new
        @transaction.errors.messages[:book_isbn] = ['does not exists']

        render 'new_returning'
      end
    else
      @transaction = Transaction.new
      @transaction.errors.messages[:visitor_username] = ['does no exists']

      render 'new_returning'
    end
  end

  private
    def redirect_if_not_staff
      is_logged_in = session[:user_type].present?

      if is_logged_in
        is_admin = session[:user_type] == 'admin'
        redirect_to(:admin_dashboard) if is_admin
      else
        redirect_to :staff_login
      end
    end

    def redirect_if_staff
      is_staff = session[:user_type] == 'staff'
      redirect_to(:staff_dashboard) if is_staff
    end

    def redirect_if_admin
      is_admin = session[:user_type] == 'admin'
      redirect_to(:admin_dashboard) if is_admin
    end

    def login_params
      params.require(:staff).permit :username, :password
    end

    def change_password_params
      params.require(:staff).permit :password, :password_confirmation
    end

    def new_visitor_params
      params.require(:visitor).permit :fullname, :username, :age
    end

    def edit_visitor_params
      params.require(:visitor).permit :fullname, :age
    end

    def new_book_params
      params.require(:book).permit :isbn, :title, :author, :synopsis
    end

    def edit_book_params
      params.require(:book).permit :title, :author, :synopsis
    end

    def transaction_params
      params.require(:transaction).permit :visitor_username, :book_isbn
    end

    def create_session staff
      session[:user_type] = 'staff'
      session[:user_data] = { username: staff[:username] }
    end
end
