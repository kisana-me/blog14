class PostsController < ApplicationController
  include PostsHelper
  before_action :require_signin, except: %i[ index show ]
  before_action :set_post, only: %i[ show ]
  before_action :set_correct_post, only: %i[ edit update destroy ]

  def index
    all_posts = Post.all
    @posts = paged_objects(params[:page], all_posts, published_at: :desc)
    @posts_page = total_page(all_posts)
  end

  def show
    # unless logged_in?
    #   @post.update(views_count: @post.views_count + 1)
    # end
    @problem, session[:answer] = generate_random_problem
  end

  def new
    @post = Post.new
    @images = @current_account.images
  end

  def create
    @post = Post.new(post_params)
    @post.account = @current_account
    @post.tagging
    if @post.save
      redirect_to post_path(@post.name_id), notice: "作成しました"
    else
      flash.now[:alert] = "作成できませんでした"
      render :new
    end
  end

  def edit
    @images = @current_account.images
  end

  def update
    @post.assign_attributes(post_params)
    @post.tagging#(arr: params[:post][:selected_tags])
    if @post.save
      redirect_to post_path(@post.name_id), notice: "更新しました"
    else
      flash.now[:alert] = "更新できませんでした"
      render :edit
    end
  end

  def destroy
    if @post.update(status: :deleted)
      redirect_to images_path, notice: "削除しました"
    else
      flash.now[:alert] = "削除できませんでした"
      render :show
    end
  end

  private

  def post_params
    params.expect(post: [
      :name_id,
      :title,
      :summary,
      :content,
      :published_at,
      :edited_at,
      :status,
      :thumbnail_aid,
      selected_tags: [],
    ])
  end

  def set_post
    return if @post = Post.find_by(name_id: params[:name_id])
    if @current_account
      return if @post = Post.general.find_by(name_id: params[:name_id])
      return @post = Post.unscoped.find_by(name_id: params[:name_id]) if admin?
    end
    render_404
  end

  def set_correct_post
    return if @post = Post.general.find_by(name_id: params[:name_id])
    return @post = Post.unscoped.find_by(name_id: params[:name_id]) if admin?
    render_404
  end
end
