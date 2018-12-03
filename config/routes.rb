Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'staff#login'

  get :license, to: 'license#index',
    as: :license_root

  get :developer, to: 'developer#index',
    as: :developer_root

  scope :admin do
    get '/', to: 'admin#index',
      as: :admin_root

    get :login, to: 'admin#login',
      as: :admin_login

    post :login, to: 'admin#login_validation',
      as: :admin_login_validation

    get :logout, to: 'admin#logout',
      as: :admin_logout

    scope :recover do
      get '/', to: 'admin#recover',
        as: :admin_recover_root

      post '/', to: 'admin#recover_post',
        as: :admin_recover_root_post

      get :question, to: 'admin#recover_question',
        as: :admin_recover_question

      post :question, to: 'admin#recover_validation',
        as: :admin_recover_validation

      get :reset_password, to: 'admin#reset_password',
        as: :admin_recover_reset_password_root

      post :reset_password, to: 'admin#reset_password_validation',
        as: :admin_recover_reset_password_validation
    end

    scope :dashboard do
      get '/', to: 'admin#dashboard',
        as: :admin_dashboard

      get :change_password, to: 'admin#change_password',
        as: :admin_change_password_root

      post :change_password, to: 'admin#change_password_validation',
        as: :admin_change_password_validation

      get :staff, to: 'admin#manage_staff',
        as: :admin_manage_staff_root

      get :new_staff, to: 'admin#new_staff',
        as: :admin_new_staff_root

      post :new_staff, to: 'admin#new_staff_validation',
        as: :admin_new_staff_validation

      get '/edit_staff/:username', to: 'admin#edit_staff',
        as: :admin_edit_staff_root

      post '/edit_staff/:username', to: 'admin#edit_staff_validation',
        as: :admin_edit_staff_validation

      get '/remove_staff/:username', to: 'admin#remove_staff',
        as: :admin_remove_staff
    end
  end

  scope :staff do
    get :login, to: 'staff#login',
      as: :staff_login
  end
end
