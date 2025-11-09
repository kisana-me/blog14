module Admin
  class CommentsController < Admin::ApplicationController
    def index
      @comments = Comment.is_normal.includes(:post).order(created_at: :desc)
    end
  end
end
