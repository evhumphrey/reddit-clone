class PostsController < ApplicationController\

  before_action :require_login, except: [:show]

  def new
    @post = Post.new
    @sub = params[:id]
    render :new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
  end

  # author only
  def edit
  end

  def update
  end

  # moderator only
  def delete
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end

end
