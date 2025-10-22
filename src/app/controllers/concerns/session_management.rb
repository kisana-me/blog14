module SessionManagement
  # 単一サインイン版 ver 1.0.2
  # models/token_toolsが必須
  # Sessionに必要なカラム差分(名前 型)
  # - account references
  # Accountに必要なカラム(名前 型)
  # - status enum { normal: 0, locked: 1, deleted: 2 }

  COOKIE_NAME = "ivecolor".freeze
  COOKIE_EXPIRES = 1.month # 2592000

  def current_account
    @current_account = nil
    return unless (token = cookies.encrypted[COOKIE_NAME.to_sym])

    db_session = Session.find_by_token("token", token)
    if db_session&.account&.normal?
      @current_account = db_session.account
    else
      cookies.delete(COOKIE_NAME.to_sym)
    end
  end

  def sign_in(account)
    db_session = Session.new(account: account)
    token = db_session.generate_token("token", COOKIE_EXPIRES)
    cookies.encrypted[COOKIE_NAME.to_sym] = {
      value: token,
      domain: :all,
      tld_length: 2,
      same_site: :lax,
      expires: Time.current + COOKIE_EXPIRES,
      secure: Rails.env.production?,
      httponly: true
    }
    db_session.save
  end

  def sign_out
    return unless (token = cookies.encrypted[COOKIE_NAME.to_sym])

    db_session = Session.find_by_token("token", token)
    return unless db_session

    cookies.delete(COOKIE_NAME.to_sym)
    @current_account = nil
    db_session.update(status: :deleted)
  end
end
