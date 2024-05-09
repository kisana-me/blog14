class ApplicationController < ActionController::Base
  include Tools
  include SessionsHelper
  before_action :set_current_account

  unless Rails.env.development?
    rescue_from Exception,                      with: :render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render_404
    render 'errors/404', status: :not_found
  end
  def render_500
    render 'errors/500', status: :internal_server_error
  end
  def set_current_account
    @current_account = current_account
  end
  def admin_account
    unless logged_in? && @current_account.roles.include?('admin')
      render_404
    end
  end
  def logged_in_account
    unless logged_in?
      render_404
    end
  end
  def logged_out_account
    unless !logged_in?
      flash[:danger] = "ログイン済みです"
      redirect_to root_path
    end
  end
end
