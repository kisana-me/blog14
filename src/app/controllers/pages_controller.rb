class PagesController < ApplicationController
  def index
  end
  def terms
  end
  def privacy
  end
  def disclaimer
  end
  def sitemap
  end
  def contact
    @inquiry = Inquiry.new
    @problem, session[:answer] = generate_random_problem
  end
  def create_contact
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.aid = generate_aid(Inquiry, 'aid')
    if session[:answer].to_i == params[:test1][:test].to_i
      if @inquiry.save
        session.delete(:answer)
        flash.now[:success] = '送信しました'
        render 'submitted'
      else
        @problem, session[:answer] = generate_random_problem
        flash.now[:danger] = '送信できませんでした'
        render 'contact'
      end
    else
      @problem, session[:answer] = generate_random_problem
      flash.now[:danger] = '解答が間違っています'
      render 'contact'
    end
  end
  def secrets_check
    case params[:keyword]
    when 'signup'
      if logged_in?
        flash[:danger] = "ログイン済みです"
        redirect_to root_path
        return
      end
      @account = Account.new
      render 'accounts/signup'
    when 'login'
      if logged_in?
        flash[:danger] = "ログイン済みです"
        redirect_to root_path
        return
      end
      render 'accounts/login'
    else
      render_404
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(
      :subject,
      :content,
      :name,
      :address
    )
  end
end
