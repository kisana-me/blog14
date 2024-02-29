class PostsController < ApplicationController
  before_action :set_post, only: %i[ show ]
  before_action :set_correct_post, only: %i[ edit update ]
  before_action :logged_in_account, only: %i[ new create edit update ]
  include PostsHelper
  def index
    @posts = paged_posts(params[:page])
    @total = posts_page
  end
  def show
  end
  def new
    @post = Post.new
  end
  def create
    @post = Post.new(post_params)
    @post.accounts << @current_account
    if @post.save
      flash[:success] = '作成しました'
      redirect_to post_path(@post.post_name_id)
    else
      flash.now[:danger] = '作成できませんでした'
      render 'new'
    end
  end
  def edit
  end
  def update
    if @post.update(post_params)
      flash[:success] = '編集しました'
      redirect_to post_path(@post.post_name_id)
    else
      flash.now[:danger] = '編集できませんでした'
      render 'new'
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :post_name_id,
      :image_name_id,
      :title,
      :content,
      :draft,
      :thumbnail,
      :summary,
      tag_ids: []
    )
  end
  def set_post
    @post = find_post(params[:post_name_id])
  end
  def set_correct_post
    @post = find_correct_post(params[:post_name_id])
    unless @post.accounts.include?(@current_account)
      flash[:danger] = '正しいアカウントではありません'
      redirect_to root_path
    end
  end
end
