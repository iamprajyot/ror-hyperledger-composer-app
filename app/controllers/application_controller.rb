class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  helper_method [:access_token, :user?, :it_admin?, :extract_resource_id]

  def access_token
    cookies['access_token'].present? ? cookies['access_token'].split(/[:|.]/)[1] : ''
  end

  def authenticated?
    session[:user].present? && (session[:user][:authenticated] || session[:user]['authenticated'])
  end

  def user?
    session[:user].present? && session[:user]['role'].present? && session[:user]['role'] == USER_ROLE
  end

  def it_admin?
    session[:user].present? && session[:user]['role'].present? && session[:user]['role'] == IT_ADMIN_ROLE 
  end

  def participant_id
    session[:user]['$class']+'#'+session[:user]['employeeId']
  end

  def generate_random_id
    SecureRandom.hex(6)
  end

  def extract_resource_id(resource)
    resource.split(/#/).last
  end
end
