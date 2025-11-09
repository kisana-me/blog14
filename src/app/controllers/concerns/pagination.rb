module Pagination
  extend ActiveSupport::Concern

  private

  def set_pagination_for(model)
    pagination = pagination_params
    @page = pagination[:page]
    @per_page = pagination[:per_page]
    @total_pages = (model.count / @per_page.to_f).ceil
    model.paginate(**pagination)
  end

  def pagination_params
    {
      page: params.fetch(:page, 1).to_i,
      per_page: params.fetch(:per_page, 10).to_i
    }
  end
end
