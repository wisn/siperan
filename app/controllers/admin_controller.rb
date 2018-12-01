class AdminController < ApplicationController
  before_action :redirect_if_not_admin,
    except: [:login, :login_validation]
  before_action :redirect_if_admin,
    only: [:login, :login_validation]

  def index
    redirect_to :admin_dashboard
  end

  def login
  end

  def login_validation
    @admin = Admin.new admin_login_params

    if @admin.valid?
      @admin = Admin.find_by username: admin_login_params['username']

      if @admin and @admin.authenticate(admin_login_params['password'])
        create_session @admin
        redirect_to :admin_dashboard
      else
        @admin = Admin.new
        @admin.errors.messages[:account] = [
          'credentials invalid or it is doesn\'t exists'
        ]

        render 'login'
      end
    else
      render 'login'
    end
  end

  def logout
    session.delete :user_type
    session.delete :user_data

    redirect_to :admin_login
  end

  def dashboard
  end

  private
    def redirect_if_not_admin
      is_logged_in = not(session[:user_type].nil?)

      if is_logged_in
        is_staff = session[:user_type] == 'staff'
        redirect_to(:staff_dashboard) if is_staff
      else
        redirect_to :admin_login
      end
    end

    def redirect_if_admin
      is_admin = session[:user_type] == 'admin'
      redirect_to(:admin_dashboard) if is_admin
    end

    def admin_login_params
      params.require(:admin).permit :username, :password
    end

    def create_session admin
      session[:user_type] = 'admin'
      session[:user_data] = { username: admin[:username] }
    end
end

