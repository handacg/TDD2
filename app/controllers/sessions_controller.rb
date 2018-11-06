class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "Successfully logged in!"
      redirect_to root_path
    else
      flash[:danger] = "Invalid username/password"
      render '/signup'
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:info] = "Logged out!"
  end
end
