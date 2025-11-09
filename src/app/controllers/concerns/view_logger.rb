module ViewLogger
  extend ActiveSupport::Concern

  def log_view(viewable)
    ViewLog.create!(
      viewable: viewable,
      account: @current_account,
      ip: request.remote_ip,
      user_agent: request.user_agent,
      referer: request.referer,
      session_id: request.session.id.to_s,
      viewed_at: Time.current
    )
  rescue => e
    Rails.logger.warn("[ViewLogger] failed to record: #{e.message}")
  end
end
