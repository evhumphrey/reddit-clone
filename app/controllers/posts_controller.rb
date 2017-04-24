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
      redirect_to post_url(@post)
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
    @post = Post.find_by(id: params[:id])

    if current_user == @post.author
      render :edit
    else
      render.now[:errors] = [" 🚫 Can't edit someone else's posts 🚫 "]
      render :show
    end
  end

  def update
    @post = Post.find_by(id: params[:id])

    if current_user == @post.author
      if @post.update_attributes(post_params)
        @post.update(post_params)
        redirect_to post_url(@post)
      else
        flash.now[:errors] = @post.errors.full_messages
        render :edit
      end
    else
      render[:errors] = [" 🚫 Can't edit someone else's posts 🚫 "]
      redirect_to post_url(@post)
    end
  end

  # author only
  def destroy
    post = Post.find_by(id: params[:id])
    if current_user == post.author
      post.destroy
      redirect_to subs_url
    else
      flash.now[:errors] = [" 🚫 Can't edit someone else's posts 🚫 "]
      render :show
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end

end
