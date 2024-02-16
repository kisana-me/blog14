module AccountsHelper
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def log_in(account)
    uuid = SecureRandom.uuid
    token = SecureRandom.urlsafe_base64
    Session.create(
      account_id: account.id,
      session_name_id: uuid,
      session_digest: digest(token)
    )
    secure_cookies = ENV["RAILS_SECURE_COOKIES"].present?
    cookies.permanent.signed[:blog14_aid] = {
      value: account.id,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    }
    cookies.permanent.signed[:blog14_uid] = {
      value: uuid,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    }
    cookies.permanent.signed[:blog14_rtk] = {
      value: token,
      domain: :all,
      expires: 1.year.from_now,
      secure: secure_cookies,
      httponly: true
    }
  end
  def log_out
    Session.find_by(
      account_id: cookies.signed[:blog14_aid],
      session_name_id: cookies.signed[:blog14_uid]
    ).destroy
    cookies.delete(:blog14_aid)
    cookies.delete(:blog14_uid)
    cookies.delete(:blog14_rtk)
    @current_account = nil
  end
  def logged_in?
    !@current_account.nil?
  end
  def current_account
    if @current_account
      return
    else
      begin
        account = Account.find(cookies.signed[:blog14_aid])
        session = Session.find_by(
          account_id: cookies.signed[:blog14_aid],
          session_name_id: cookies.signed[:blog14_uid]
        )
        if BCrypt::Password.new(session.session_digest).is_password?(cookies.signed[:blog14_rtk])
          @current_account = account
        end
      rescue
        @current_account = nil
      end
    end
  end
  def find_account(name_id)
    Account.find_by(
      name_id: name_id,
      deleted: false
    )
  end
  def all_accounts
    Account.where(
      deleted: false
    ).order(
      id: :desc
    )
  end
end
