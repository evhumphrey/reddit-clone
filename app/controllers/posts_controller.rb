class PostsController < ApplicationController\

  before_action :require_login, except: [:show]

  def new
    @post = Post.new
    @sub = params[:id]
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user

    if @post.save
      redirect_to post_url(@post.sub)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @author = @post.author.username
    if @post
      render :show
    else
      flash[:errors] = cant_find_resource("post")
      redirect_to subs_url
    end
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
