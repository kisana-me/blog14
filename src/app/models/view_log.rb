class ViewLog < ApplicationRecord
  belongs_to :viewable, polymorphic: true
  belongs_to :account, optional: true

  scope :today, -> { where(viewed_at: Time.zone.today.all_day) }
  scope :humans, -> { where(is_bot: false) }

  before_create :detect_device_info

  private

  def detect_device_info
    self.is_bot = user_agent&.match?(/bot|crawler|spider|preview/i)
    return if is_bot

    if user_agent
      self.device_type = user_agent.match?(/mobile/i) ? "mobile" : "desktop"
      self.browser = parse_browser
      self.os = parse_os
    end
  end

  def parse_browser
    case user_agent
    when /Chrome/i then "Chrome"
    when /Safari/i then "Safari"
    when /Firefox/i then "Firefox"
    when /Edge/i then "Edge"
    when /Opera|OPR/i then "Opera"
    else "Other"
    end
  end

  def parse_os
    case user_agent
    when /Windows/i then "Windows"
    when /Macintosh/i then "macOS"
    when /Linux/i then "Linux"
    when /Android/i then "Android"
    when /iPhone|iPad/i then "iOS"
    else "Other"
    end
  end
end
