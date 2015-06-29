class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
    def user_root_path
        current_user
    end
  def after_sign_in_path_for(resource)
    current_user 
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :g_comment, :d_comment, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :g_comment, :d_comment, :current_password, :password, :password_confirmation) }
  end
end
