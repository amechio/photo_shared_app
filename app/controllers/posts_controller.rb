class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all
  end

  def show
    @favorite = current_user.favorites.find_by(post_id: @post.id)
  end

  def new
    @post = Post.new
  end

  def edit
    unless current_user.id == @post.user_id
      redirect_to posts_path, notice: "権限がありません！"
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:back]
      render :new
    else
      if @post.save
        PostMailer.post_mail(@post).deliver
        redirect_to posts_path, notice: "作成しました！"
      else
        render :new
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "更新しました！" }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @post = current_user.posts.build(post_params)
    render :new if @post.invalid?
  end

  def destroy
    unless current_user.id == @post.user_id
      redirect_to posts_path, notice: "権限がありません！"
    else
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: "削除しました！" }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:picture, :picture_cache, :content)
    end
end
