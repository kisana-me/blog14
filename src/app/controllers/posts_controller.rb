class PostsController < ApplicationController
  before_action :logged_in_account, only: %i[ new create edit update ]
  before_action :set_post, only: %i[ show ]
  before_action :set_correct_post, only: %i[ edit update ]
  include PostsHelper

  def index
    @posts = paged_posts(params[:page])
    @posts_page = posts_page
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
      flash[:success] = '作成しました'
      redirect_to post_path(@post.aid)
    else
      flash.now[:danger] = '作成できませんでした'
      render 'new'
    end
  end
  def edit
  end
  def update
    @post.tagging(arr: params[:post][:selected_tags])
    if @post.update(post_params)
      flash[:success] = '編集しました'
      redirect_to post_path(@post.aid)
    else
      flash.now[:danger] = '編集できませんでした'
      render 'new'
    end
  end

  private
  def post_params
    params.require(:post).permit(
      :thumbnail,
      :title,
      :summary,
      :content,
      :public,
      :unlisted,
      :published_at,
      :edited_at,
      selected_tags: []
    )
  end
  def set_post
    @post = Post.where(public: true).or(Post.where(unlisted: true)).find_by(
      aid: params[:aid],
      deleted: false
    )
    unless @post
      if logged_in?
        return if @post = @current_account.posts.find_by(aid: params[:aid])
      end
      render_404
    end
  end
  def set_correct_post
    @post = @current_account.posts.find_by(
      aid: params[:aid]
    )
    unless @post
      render_404
    end
  end
end
