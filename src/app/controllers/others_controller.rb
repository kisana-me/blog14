class OthersController < ApplicationController
  def index
  end
  def terms
  end
  def policy
  end
  def disclaimer
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
