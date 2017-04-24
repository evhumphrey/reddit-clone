class SubsController < ApplicationController

  before_action :require_login, except: [:index, :show]
  before_action :require_mod, only: [:edit, :update, :destroy]

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator = current_user

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def index
    @subs = Sub.all # TODO: sort????
    render :index
  end

  def show
    @sub = Sub.find_by(id: params[:id])

    if @sub
      render :show
    else
      # TODO :404???
      flash[:errors] = [" 🕵️ Can't find sub you're looking for 🕵️‍♀️ "]
      redirect_to subs_url
    end
  end

  def edit
    @sub = Sub.find_by(id: params[:id])

    if @sub.nil?
      flash[:errors] = [" 🕵️ Can't find sub you're looking for 🕵️‍♀️ "]
      redirect_to subs_url
      return
    end
  end

  def update

    @sub = Sub.find_by(id: params[:id])

    if @sub.update_attributes(sub_params)
      @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    @sub = Sub.find_by(id: params[:id])
    @sub.destroy
    redirect_to subs_url
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_mod
    @sub = Sub.find_by(id: params[:id])
    if current_user != @sub.moderator
      flash.now[:errors] = [" 🚫 Must be moderator 🚫 "]
      render :show
      return
    end
  end

  def require_login
    unless logged_in?
      redirect_to new_session_url
    end
  end
end
