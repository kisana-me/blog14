class PostsController < ApplicationController
  before_action :logged_in_account, only: %i[ new create edit update thumbnail_variants_delete ]
  before_action :set_post, only: %i[ show ]
  before_action :set_correct_post, only: %i[ edit update thumbnail_variants_delete ]
  include PostsHelper

  def index
    all_posts = Post.where(status: :published)
    @posts = paged_objects(params[:page], all_posts, published_at: :desc)
    @posts_page = total_page(all_posts)
  end
  def show
    unless logged_in?
      @post.update(views_count: @post.views_count + 1)
    end
    @problem, session[:answer] = generate_random_problem
  end
  def new
    @post = Post.new
  end
  def create
    @post = Post.new(post_params)
    @post.aid = generate_aid(Post, 'aid')
    @post.account = @current_account
    @post.tagging
    if @post.save
      flash[:notice] = '作成しました'
      redirect_to post_path(@post.aid)
    else
      flash.now[:alert] = '作成できませんでした'
      render 'new'
    end
  end
  def edit
  end
  def update
    @post.tagging(arr: params[:post][:selected_tags])
    if @post.update(post_params)
      flash[:notice] = '編集しました'
      redirect_to post_path(@post.aid)
    else
      flash.now[:alert] = '編集できませんでした'
      render 'new'
    end
  end
  def thumbnail_variants_delete
    if @post.thumbnail_variants_delete
      flash[:notice] = 'variantsを削除しました'
      redirect_to privacy_path
    else
      flash[:alert] = 'variantsの削除ができませんでした'
      redirect_to privacy_path
    end
  end

  private
  def post_params
    params.require(:post).permit(
      :thumbnail,
      :title,
      :summary,
      :content,
      :status,
      :published_at,
      :edited_at,
      selected_tags: []
    )
  end
  def set_post
    @post = Post.where(status: :published).find_by(aid: params[:aid])
    unless @post
      if logged_in?
        return if @post = @current_account.posts.find_by(aid: params[:aid])# deleted以外にする
        if admin?
          return if @post = Post.find_by(aid: params[:aid])
        end
      end
      render_404
    end
  end
  def set_correct_post
    @post = @current_account.posts.find_by(aid: params[:aid])
    unless @post
      if admin?
        return if @post = Post.find_by(aid: params[:aid])
      end
      render_404
    end
  end
end
