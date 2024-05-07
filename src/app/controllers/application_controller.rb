class ApplicationController < ActionController::Base
  include Tools
  include SessionsHelper
  before_action :set_current_account
  private
  def not_found_page
    render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
  end
  def set_current_account
    @current_account = current_account
  end
  def admin_account
    unless logged_in? && @current_account.role == 'admin'
      rennot_found_page
    end
  end
  def logged_in_account
    unless logged_in?
      not_found_page
    end
  end
  def logged_out_account
    unless !logged_in?
      flash[:danger] = "ログイン済みです"
      redirect_to root_path
    end
  end
end
