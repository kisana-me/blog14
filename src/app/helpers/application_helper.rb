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
  # paging
  def total_page(objects)
    total = objects.count
    per_page = 10 # 表示件数
    return total.to_i > 0 ? (total.to_f / per_page.to_f).ceil : 0
  end
  def paged_objects(param, objects)
    limit_item = 10 # 表示件数
    param = param.to_i
    page = param < 1 ? 1 : param
    offset_item = (page - 1) * limit_item
    return objects.offset(
      offset_item.to_i
    ).limit(
      limit_item.to_i
    ).order(
      published_at: :desc
    )
  end
end
