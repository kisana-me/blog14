class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update ]
  before_action :logged_in_account, only: %i[ new create edit update ]
  def index
    @posts = Post.all
  end
  def show
  end
  def new
    @post = Post.new
  end
  def create
    post = Post.new(post_params)
    post.account_id = @current_account.id
    if post.save
      flash[:success] = '投稿しました'
      redirect_to post_path(post.post_id)
    else
      @reform = {
        invitation_code: params[:account][:invitation_code],
        name: params[:account][:name],
        name_id: params[:account][:name_id],
        password: params[:account][:password],
        password_confirmation: params[:account][:password_confirmation]
      }
      flash.now[:danger] = '作成できませんでした'
      render 'new'
    end
  end
  def edit
  end
  def update
  end

  private

  def post_params
    params.require(:post).permit(
      :post_id,
      :title,
      :content,
      :draft
    )
  end
  def set_post
    @post = Post.find_by(
      post_id: params[:post_id],
      draft: false
    )
  end
end
