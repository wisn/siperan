Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'staff#login'

  scope :admin do
    get '/', to: 'admin#index',
      as: :admin_root

    get :login, to: 'admin#login',
      as: :admin_login

    post :login, to: 'admin#login_validation',
      as: :admin_login_validation

    get '/logout', to: 'admin#logout',
      as: :admin_logout

    scope '/dashboard' do
      get '/', to: 'admin#dashboard',
        as: :admin_dashboard

      get '/password', to: 'admin#password',
        as: :admin_password

      put '/password', to: 'admin#update_password',
        as: :admin_update_pasword

      get '/staff', to: 'admin#new_staff',
        as: :admin_new_staff

      post '/staff', to: 'admin#create_staff',
        as: :admin_create_staff
    end
  end

  scope :staff do
    get :login, to: 'staff#login',
      as: :staff_login
  end
end
