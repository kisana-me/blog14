class Admin::PostsController < Admin::ApplicationController
  before_action :set_post, only: %i[ edit update ]

  def index
    @unlisted_posts = Post.where(
      unlisted: true,
      public: false,
      deleted: false
    )
    @private_posts = Post.where(
      unlisted: false,
      public: false,
      deleted: false
    )
    @deleted_posts = Post.where(
      deleted: true
    )
  end
  def edit
  end
  def update
    if @post.update(post_params)
      flash[:success] = '変更しました'
      redirect_to admin_post_path(@post.aid)
    else
      flash.now[:danger] = '変更できませんでした'
      render 'edit'
    end
  end
  private
  def set_post
    @post = Post.find_by(aid: params[:aid])
  end
  def post_params
    params.require(:post).permit(
      :aid,
      :thumbnail,
      :thumbnail_original_key,
      :thumbnail_variants,
      :public,
      :unlisted,
      :title,
      :summary,
      :likes_count,
      :views_count,
      :metadata,
      :deleted,
      :created_at,
      :updated_at
    )
  end
end