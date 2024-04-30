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
  def to_page(current_page, where_to_go)
    current_page = current_page.to_i
    page = where_to_go == 'next' ? [current_page + 1, 2].max : where_to_go == 'prev' ? [current_page - 1, 1].max : 2
    return page
  end

  private
end
