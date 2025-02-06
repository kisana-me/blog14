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
  # def link_to(name = nil, options = nil, html_options = nil, &block)
  #   html_options ||= {}
  #   html_options[:data] ||= {}
  #   html_options[:data][:turbo_prefetch] = false unless html_options[:data].key?(:turbo_prefetch)
  #   super(name, options, html_options, &block)
  # end
end
