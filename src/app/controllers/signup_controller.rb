class SignupController < ApplicationController
  before_action :require_signout
  before_action :ensure_oauth_context

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.assign_attributes(
      anyur_id: session[:pending_oauth_info]["anyur_id"],
      anyur_access_token: session[:pending_oauth_info]["anyur_access_token"],
      anyur_refresh_token: session[:pending_oauth_info]["anyur_refresh_token"],
      anyur_token_fetched_at: Time.current
    )
    @account.meta["subscription"] = session[:pending_oauth_info]["subscription"]

    if @account.save
      sign_in(@account)
      session.delete(:pending_oauth_info)
      redirect_back_or root_path, notice: "登録完了"
    else
      render :new
    end
  end

  private

  def ensure_oauth_context
    unless session[:pending_oauth_info].present?
      render plain: "不正なアクセス", status: :forbidden
    end
  end

  def account_params
    params.require(:account).permit(
      :name,
      :name_id,
      :description
    )
  end
end
