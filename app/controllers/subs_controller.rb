class SubsController < ApplicationController

  before_action :require_mod, only: [:edit, :update, :destroy]

  def new
    # any creation actions must verify that user is logged in
    if logged_in?
      @sub = Sub.new
      render :new
    else
      redirect_to new_session_url
    end
  end

  def create
    if logged_in?
      @sub = Sub.new(sub_params)
      @sub.moderator = current_user
      if @sub.save
        redirect_to sub_url(@sub)
      else
        flash.now[:errors] = @sub.errors.full_messages
        render :new
      end
    else
      redirect_to new_session_url
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
      flash[:errors] = [" 🕵️ Can't find sub you're looking for 🕵️‍♀️ "]
      redirect_to subs_url
    end
  end

  def edit
    if logged_in?
      @sub = Sub.find_by(id: params[:id])
      if @sub.nil?
        flash[:errors] = [" 🕵️ Can't find sub you're looking for 🕵️‍♀️ "]
        redirect_to subs_url
        return
      end
    else
      redirect_to new_session_url
    end
  end

  def update
    if logged_in?
      @sub = Sub.find_by(id: params[:id])

      if @sub.update_attributes(sub_params)
        @sub.update(sub_params)
        redirect_to sub_url(@sub)
      else
        flash.now[:errors] = @sub.errors.full_messages
        render :edit
      end
    else
      redirect_to new_session_url
    end
  end

  def destroy
    if logged_in?
      @sub = Sub.find_by(id: params[:id])
      @sub.destroy
      redirect_to subs_url
    else
      redirect_to new_session_url
    end
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
end
