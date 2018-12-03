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

    def create_session staff
      session[:user_type] = 'staff'
      session[:user_data] = { username: staff[:username] }
    end
end
