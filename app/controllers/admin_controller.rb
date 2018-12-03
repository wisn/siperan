class AdminController < ApplicationController
  def index
    redirect_if_not_admin

    redirect_to :admin_dashboard
  end

  def login
    redirect_if_admin

    redirect_if_staff
  end

  def login_validation
    redirect_if_admin

    @admin = Admin.new login_params
    if @admin.valid? :login
      @admin = Admin.find_by username: login_params['username']

      if @admin and @admin.authenticate(login_params['password'])
        create_session @admin
        redirect_to :admin_dashboard
      else
        @admin = Admin.new
        @admin.errors.messages[:account] = ['does not exists']

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

  def recover
  end

  def recover_post
    @admin = Admin.new recover_user_params
    @admin.password = 'dummy_password'

    if @admin.valid? :recover
      @admin = Admin.find_by username: @admin.username
      if @admin.present?
        session[:admin_username] = @admin.username
        session[:admin_recover] = {
          question: @admin.recovery_question,
          answer: @admin.recovery_answer,
        }

        redirect_to :admin_recover_question
      else
        @admin = Admin.new
        @admin.errors.messages[:account] = ['does not exists']

        render 'recover'
      end
    else
      render 'recover'
    end
  end

  def recover_question
    if session[:admin_recover].present?
      recover = session[:admin_recover]
      unless recover['question'].present? && recover['answer'].present?
        redirect_to :admin_recover_root
      end
    else
      redirect_to :admin_recover_root
    end
  end

  def recover_validation
    if session[:admin_recover].present?
      recover = session[:admin_recover]
      unless recover['question'].present? && recover['answer'].present?
        redirect_to :admin_recover_root
      end

      answer = recover_question_params[:answer]
      if answer == recover['answer']
        session.delete :admin_recover
        session[:admin_reset_password] = 'granted'

        redirect_to :admin_recover_reset_password_root
      else
        @admin = Admin.new
        @admin.errors.messages[:answer] = ['does not match']

        render 'recover_question'
      end
    else
      redirect_to :admin_recover_root
    end
  end

  def reset_password
  end

  def reset_password_validation
    if session[:admin_reset_password] != 'granted'
      redirect_to :admin_recover_root
    end

    @admin = Admin.new reset_password_params
    @admin.username = session[:admin_username]
    
    if @admin.valid? :reset_password
      password = @admin.password

      @admin = Admin.find_by(username: @admin.username)
      @admin.password = password

      if @admin.save
        session.delete :admin_reset_password
        redirect_to :admin_login
      else
        @admin.errors.messages[:server] = ['encounter a problem']
      end
    else
      render 'reset_password'
    end
  end

  def change_password
    redirect_if_not_admin
  end

  def change_password_validation
    @admin = Admin.new reset_password_params
    @admin.username = session[:admin_username]
    
    if @admin.valid? :reset_password
      password = @admin.password

      @admin = Admin.find_by(username: @admin.username)
      @admin.password = password

      if @admin.save
        logout
      else
        @admin.errors.messages[:server] = ['encounter a problem']
      end
    else
      render 'change_password'
    end
  end

  def dashboard
    redirect_if_not_admin

    @staff_total = Staff.count
    @books_total = Book.count
    @transactions_total = Transaction.count
  end

  def manage_staff
    redirect_if_not_admin

    @staff = Staff.all
  end

  def new_staff
    redirect_if_not_admin
  end

  def new_staff_validation
    @staff = Staff.new new_staff_params
    if @staff.save context: :adds
      redirect_to :admin_manage_staff_root
    else
      render 'new_staff'
    end
  end

  def edit_staff
    redirect_if_not_admin

    staff = Staff.find_by username: params[:username]
    if staff.present?
      @staff = staff
    else
      redirect_to :admin_manage_staff_root
    end
  end

  def edit_staff_validation
    username = params[:username]
    staff = Staff.find_by username: username
    if staff.present?
      params = edit_staff_params
      staff.fullname = params[:fullname]

      if params[:password] != ''
        staff.password = params[:password]
      end

      if staff.save context: :edits
        redirect_to :admin_manage_staff_root
      else
        @staff = staff
        render 'edit_staff', params: { username: username }
      end
    else
      redirect_to :admin_manage_staff_root
    end
  end

  def remove_staff
    staff = Staff.find_by username: params[:username]
    staff.delete if staff.present?

    redirect_to :admin_manage_staff_root
  end

  private
    def redirect_if_not_admin
      is_logged_in = session[:user_type].present?

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

    def redirect_if_staff
      is_staff = session[:user_type] == 'staff'
      redirect_to(:staff_dashbaord) if is_staff
    end

    def login_params
      params.require(:admin).permit :username, :password
    end

    def recover_user_params
      params.require(:admin).permit :username
    end

    def recover_question_params
      params.require(:admin).permit :answer
    end

    def reset_password_params
      params.require(:admin).permit :password, :password_confirmation
    end

    def new_staff_params
      params.require(:staff).permit :fullname, :username, :password, :password_confirmation
    end

    def edit_staff_params
      params.require(:staff).permit :fullname, :password, :password_confirmation
    end

    def create_session admin
      session[:user_type] = 'admin'
      session[:user_data] = { username: admin[:username] }
    end
end

