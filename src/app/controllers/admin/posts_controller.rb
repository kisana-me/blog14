module Admin
  class PostsController < Admin::ApplicationController
    before_action :set_post, only: %i[edit update]

    def index
      @posts = Post
        .unscoped
        .all
        .order(created_at: :desc)
        .includes(:thumbnail)
    end

    def edit; end

    def update
      if @post.update(post_params)
        flash[:notice] = "変更しました"
        redirect_to admin_post_path(@post.aid)
      else
        flash.now[:alert] = "変更できませんでした"
        render "edit"
      end
    end

    def update_multiple
      if params[:post_aids].present? && params[:visibility].present?
        Post.where(aid: params[:post_aids]).update_all(visibility: params[:visibility])
        flash[:notice] = "選択した投稿のステータスを更新しました"
      else
        flash[:alert] = "投稿とステータスを選択してください"
      end
      redirect_to posts_path
    end

    private

    def set_post
      @post = Post.find_by(aid: params[:aid])
    end

    def post_params
      params.expect(
        post: %i[aid
                 thumbnail
                 thumbnail_original_key
                 thumbnail_variants
                 status
                 title
                 summary
                 likes_count
                 views_count
                 metadata
                 published_at
                 edited_at]
      )
    end
  end
end
