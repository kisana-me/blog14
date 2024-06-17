module ApplicationHelper
  def full_title(page_title = '')
    base_title = ENV['APP_NAME']
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  def full_url(path)
    File.join(ENV['APP_URL'], path)
  end
end
