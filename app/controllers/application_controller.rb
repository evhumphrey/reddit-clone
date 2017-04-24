class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !current_user.nil?
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout!(user)
    user.reset_session_token!
    session[:session_token] = nil
  end

  def require_login
    unless logged_in?
      redirect_to new_session_url
    end
  end

  def cant_find_resource(name)
    [" 🕵️ Can't find #{name} you're looking for 🕵️‍♀️ "]
  end
end
