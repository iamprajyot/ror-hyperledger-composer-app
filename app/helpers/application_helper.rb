require 'securerandom'

module ApplicationHelper
	def current_month_date_range
		Time.now.beginning_of_month.to_date.to_s + ' to ' + Time.now.to_date.to_s
	end

  def user_name
    if session[:user].present? && session[:user]['firstName']
      session[:user]['firstName'].capitalize + ' ' + session[:user]['lastName'].capitalize
    else
      'Welcome Guest'
    end
  end

  def user_email
    session[:user]['email']
  end

  def user_id
    session[:user]['employeeId']
  end

  def user_role
    session[:user]['role']
  end

end
