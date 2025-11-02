class SignupController < ApplicationController
  before_action :require_signout
  before_action :ensure_oauth_context

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    @account.meta["subscription"] = session[:pending_oauth_info]["subscription"]

    if @account.save
      sign_in(@account)
      OauthAccount.create!(
        account: @account,
        provider: "anyur",
        uid: session[:pending_oauth_info]["anyur_id"],
        access_token: session[:pending_oauth_info]["anyur_access_token"],
        refresh_token: session[:pending_oauth_info]["anyur_refresh_token"],
        expires_at: Time.current + 10.minutes,
        fetched_at: Time.current
      )
      session.delete(:pending_oauth_info)
      redirect_back_or root_path, notice: "登録完了"
    else
      render :new
    end
  end

  private

  def ensure_oauth_context
    return if session[:pending_oauth_info].present?

    render plain: "不正なアクセス", status: :forbidden
  end

  def account_params
    params.expect(
      account: %i[
        name
        name_id
        description
      ]
    )
  end
end
