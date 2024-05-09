class CommentsController < ApplicationController
  before_action :logged_in_account, only: %i[ update ]
  before_action :set_comment, only: %i[ update ]

  def create
    @comment = Comment.new(comment_params)
    post = Post.find_by(aid: params[:comment][:post_aid])
    unless session[:answer].to_i == params[:test1][:test].to_i
      @problem, session[:answer] = generate_random_problem
      flash[:danger] = '解答が間違っています'
      redirect_to post_path(post.aid)
      return
    end
    if params[:comment][:replied].present?
      comment = Comment.find_by(aid: params[:comment][:replied])
      if comment.comment.nil?
        @comment.comment = comment
      end
    end
    if logged_in?
      @comment.account = @current_account
    end
    @comment.aid = generate_aid(Comment, 'aid')
    @comment.post = post
    if @comment.save
      flash[:success] = 'コメントを書き込みました'
      redirect_to post_path(post.aid)
    else
      flash[:danger] = "エラー:#{@comment.errors.full_messages.join(", ")}"
      redirect_to post_path(post.aid)
    end
  end
  def update
    if @comment.update(update_comment_params)
      flash[:success] = 'コメントを更新しました'
      redirect_to post_path(@comment.post.aid)
    else
      flash[:danger] = "エラー:#{@comment.errors.full_messages.join(", ")}"
      redirect_to post_path(@comment.post.aid)
    end
  end
  private
  def comment_params
    params.require(:comment).permit(
      :name,
      :content,
      :address
    )
  end
  def update_comment_params
    params.require(:comment).permit(
      :public
    )
  end
  def set_comment
    @comment = Comment.find_by(aid: params[:aid])
  end
end
