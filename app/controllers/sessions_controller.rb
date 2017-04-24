class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user
      login!(@user)
      redirect_to subs_url
    else
      @user = User.new(user_params)
      flash.now[:errors] = ["Whoops! Can't find username or password"]
      render :new
    end
  end

  def destroy
    logout!(current_user)
    redirect_to new_session_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
