class V1::ApplicationController < ApplicationController
  protect_from_forgery except: :new_token
  def new_token
    set_csrf_token_cookie
    render body: nil
  end
  private
  def api_logged_in_account
    unless logged_in?
      render status: 401
    end
  end
  def set_csrf_token_cookie
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      domain: :all,
      expires: 1.month.from_now}
  end
  def set_csrf_token_header
    response.set_header('X-CSRF-Token', form_authenticity_token)
  end
end