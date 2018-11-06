class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def index
    unless logged_in?
      flash[:warning] = "You must be logged in to access to this page"
      redirect_to login_path
    end
    @users = User.all
  end
  
  def show
    if logged_in?
     @user = User.find(params[:id])
     else
      flash[:warning] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "You've successfully signed up, welcome !"
      redirect_to root_path
    else
      flash[:danger] = "Sign-up failed, please try again."
      redirect_to signup_path
    end
  end
  
  def edit
    if logged_in?
      if session[:user_id] == params[:id].to_i
        @user = User.find(session[:user_id])
      else
        flash[:warning] = "You can't edit this page"
        redirect_to club_path
      end
    else
      flash[:warning] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end
  
  def update
    @user = User.find(session[:user_id])
    @user.update_attributes(user_params)
    if @user.save(:validate => false)
      redirect_to user_path
    else
      flash[:danger] = "Something went wrong, make sure to enter a valid email address."
      redirect_to edit_user_path
    end
  end


  def destroy
    @user.destroy
    flash[:info] = "Account successfully deleted, sorry to see you go."
  end
  
  private
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
