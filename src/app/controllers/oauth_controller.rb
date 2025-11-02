class OauthController < ApplicationController
  # OAuth Controller for IVECOLOR ver 1.0.0
  # controllers/concerns/oauth_managementが必須
  # routes.rbに以下を追記
  # # OAuth
  # post "oauth" => "oauth#start"
  # get "callback" => "oauth#callback"

  include OauthManagement

  def start
    state = SecureRandom.base36(24)
    session[:oauth_state] = state
    oauth_authorize_url = generate_authorize_url(state)

    redirect_to oauth_authorize_url, allow_other_host: true
  end

  def callback
    return render plain: "Invalid state parameter", status: :unauthorized unless params[:state] == session[:oauth_state]

    session.delete(:oauth_state)

    token_data = exchange_code_for_token(params[:code])
    return if performed?

    resources = fetch_resources(token_data["access_token"])
    return if performed?

    handle_oauth(token_data, resources)
  end

  private

  # ========== #
  # 以下自由 / handle_oauth(token_data, resources)で受け取る
  # ========== #

  def handle_oauth(token_data, resources)
    anyur_id = resources.dig("data", "id")
    oauth_account = OauthAccount.find_by(provider: "anyur", uid: anyur_id)
    account = oauth_account&.account

    if @current_account
      if @current_account == account # 同
        oauth_account.assign_attributes(
          access_token: token_data["access_token"],
          refresh_token: token_data["refresh_token"],
          expires_at: Time.current + 10.minutes,
          fetched_at: Time.current
        )
        account.meta["subscription"] = resources.dig("data", "subscription")
        account.save!
        oauth_account.save!
        redirect_to settings_account_path, notice: "情報を更新しました"
      elsif account # 別
        redirect_to settings_account_path, alert: "既に他のアカウントと連携済みです"
      else # 未
        OauthAccount.create!(
          account: @current_account,
          provider: :anyur,
          uid: resources.dig("data", "id"),
          access_token: token_data["access_token"],
          refresh_token: token_data["refresh_token"],
          expires_at: Time.current + 10.minutes,
          fetched_at: Time.current
        )
        @current_account.meta["subscription"] = resources.dig("data", "subscription")
        @current_account.save!
        redirect_to settings_account_path, notice: "連携が完了しました"
      end
    elsif account
      sign_in(account)
      account.oauth_accounts.find_by(provider: "anyur", uid: anyur_id).update(
        access_token: token_data["access_token"],
        refresh_token: token_data["refresh_token"],
        expires_at: Time.current + 10.minutes,
        fetched_at: Time.current
      )
      account.meta["subscription"] = resources.dig("data", "subscription")
      account.save!
      redirect_back_or root_path, notice: "サインインしました"
    else
      session[:pending_oauth_info] = {
        anyur_id: resources.dig("data", "id"),
        name: resources.dig("data", "name"),
        name_id: resources.dig("data", "name_id"),
        anyur_access_token: token_data["access_token"],
        anyur_refresh_token: token_data["refresh_token"],
        subscription: resources.dig("data", "subscription")
      }
      redirect_to signup_path
    end
  end
end
