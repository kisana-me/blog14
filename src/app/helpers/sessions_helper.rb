module SessionsHelper
  include Tools
  def log_in(account)
    #uuid = SecureRandom.uuid
    aid = generate_aid(Session, 'aid')
    token = SecureRandom.urlsafe_base64
    Session.create(
      account_id: account.id,
      aid: aid,
      session_digest: digest(token)
    )
    secure_cookies = ENV["RAILS_SECURE_COOKIES"].present?
    cookies.permanent.signed[:b_aid] = {
      value: aid,
      domain: :all,
      expires: 1.month.from_now,
      secure: secure_cookies,
      httponly: true
    }
    cookies.permanent.signed[:b_rtk] = {
      value: token,
      domain: :all,
      expires: 1.month.from_now,
      secure: secure_cookies,
      httponly: true
    }
  end
  def logged_in?
    !@current_account.nil?
  end
  def current_account
    begin
      session = Session.find_by(
        aid: cookies.signed[:b_aid],
        deleted: false
      )
      if BCrypt::Password.new(session.session_digest).is_password?(cookies.signed[:b_rtk])
        @current_account = session.account
      end
    rescue
      @current_account = nil
    end
  end
  def current_account?(account)
    account == current_account
  end
  def log_out
    Session.find_by(
      aid: cookies.signed[:b_aid],
      deleted: false
    ).destroy
    session.delete
    cookies.delete
    @current_account = nil
  end
end
