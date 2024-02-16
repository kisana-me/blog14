class ApplicationController < ActionController::Base
  include AccountsHelper
  before_action :set_current_account
  private
  def set_current_account
    @current_account = current_account
  end
  def random_id
    ('a'..'z').to_a.concat(('1'..'9').to_a).shuffle[1..14].join
  end
  def unique_random_id(model, column)
    loop do
      urid = random_id
      if !model.exists?(column.to_sym => urid)
        return urid
        break
      end
    end
  end
  def admin_account
    unless logged_in? && @current_account.role == 'admin'
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end
  def logged_in_account
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
  def logged_out_account
    unless !logged_in?
      flash[:danger] = "ログイン済みです"
      redirect_to root_url
    end
  end
end
