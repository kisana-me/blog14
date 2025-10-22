class CommentsController < ApplicationController
  before_action :require_signin, only: %i[update]
  before_action :set_comment, only: %i[update]

  def create
    @comment = Comment.new(comment_params)
    post = Post.find_by(aid: params[:comment][:post_aid])
    unless session[:answer].to_i == params[:test1][:test].to_i
      @problem, session[:answer] = generate_random_problem
      flash[:alert] = "解答が間違っています"
      redirect_to post_path(post.aid)
      return
    end
    if params[:comment][:replied].present?
      comment = Comment.find_by(aid: params[:comment][:replied])
      @comment.comment = comment if comment.comment.nil?
    end
    @comment.account = @current_account if logged_in?
    @comment.aid = generate_aid(Comment, "aid")
    @comment.post = post
    if @comment.save
      flash[:notice] = "コメントを書き込みました"
    else
      flash[:alert] = "エラー:#{@comment.errors.full_messages.join(', ')}"
    end
    redirect_to post_path(post.aid)
  end

  def update
    if @comment.update(update_comment_params)
      flash[:notice] = "コメントを更新しました"
    else
      flash[:alert] = "エラー:#{@comment.errors.full_messages.join(', ')}"
    end
    redirect_to post_path(@comment.post.aid)
  end

  private

  def comment_params
    params.expect(
      comment: %i[name
                  content
                  address]
    )
  end

  def update_comment_params
    params.expect(
      comment: [:public]
    )
  end

  def set_comment
    @comment = Comment.find_by(aid: params[:aid])
  end
end
