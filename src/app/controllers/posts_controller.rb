class PostsController < ApplicationController
  include PostsHelper

  before_action :require_signin, except: %i[index show]
  before_action :set_post, only: %i[show]
  before_action :set_correct_post, only: %i[edit update destroy]

  def index
    all_posts = Post.from_normal_accounts.is_published.includes(:thumbnail)
    @posts = paged_objects(params[:page], all_posts, published_at: :desc)
    @posts_page = total_page(all_posts)
  end

  def show
    # アクセスカウントしたい
    @problem, session[:answer] = generate_random_problem
  end

  def new
    @post = Post.new
  end

  def edit; end

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

  def update
    @post.assign_attributes(post_params)
    @post.tagging
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
      render :edit
    end
  end

  private

  def post_params
    params.expect(
      post: [
        :name_id,
        :title,
        :summary,
        :content,
        :published_at,
        :edited_at,
        :status,
        :thumbnail_new_image,
        :thumbnail_image_aid,
        { selected_tags: [] }
      ]
    )
  end

  def set_post
    preload_assocs = [:account, :tags, :images, :thumbnail]

    return if (
      @post = Post
                .from_normal_accounts
                .is_published
                .includes(preload_assocs)
                .find_by(name_id: params[:name_id])
    )

    return if (
      @post = @current_account&.posts&.isnt_deleted
                &.includes(preload_assocs)
                &.find_by(name_id: params[:name_id])
    )

    return if admin? && (
      @post = Post
                .includes(preload_assocs)
                .find_by(name_id: params[:name_id])
    )

    render_404
  end

  def set_correct_post
    preload_assocs = [:account, :tags, :images, :thumbnail]

    return if (
      @post = @current_account&.posts&.isnt_deleted
                &.includes(preload_assocs)
                &.find_by(name_id: params[:name_id])
    )
    return if admin? && (
      @post = Post
                .includes(preload_assocs)
                .find_by(name_id: params[:name_id])
    )

    render_404
  end
end
