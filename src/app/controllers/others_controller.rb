class OthersController < ApplicationController
  include PostsHelper
  def index
    @posts = all_posts
  end
  def terms
  end
  def policy
  end
  def disclaimer
  end
  def contact
    @other = Other.new
    @problem, session[:answer] = generate_random_problem
  end
  def create_contact
    Rails.logger.info("#{session[:answer]}==#{params[:test1][:test]}")
    Rails.logger.info(session[:answer].to_i == params[:test1][:test].to_i)
    @other = Other.new(content: params[:other][:content])
    if session[:answer].to_i == params[:test1][:test].to_i
      if @other.save
        session.delete(:answer)
        flash[:success] = '送信しました'
        redirect_to root_path
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
  def generate_random_problem
    num1 = rand(100)
    num2 = rand(1..10)
    operator = %w[+ - * /].sample
    if operator == '/'
      num1 = num1 - (num1 % num2)
    end
    problem = "#{num1} #{operator} #{num2}"
    [problem, eval(problem)]
  end
end
