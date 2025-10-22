module Tools
  def generate_random_problem
    num1 = rand(100)
    num2 = rand(1..10)
    operator = %w[+ - * /].sample
    num1 -= (num1 % num2) if operator == "/"
    problem = "#{num1} #{operator} #{num2}"
    [problem, eval(problem)]
  end

  # Pagination
  def total_page(objects)
    total = objects.count
    per_page = 10 # 表示件数
    total.to_i.positive? ? (total.to_f / per_page).ceil : 0
  end

  def paged_objects(param, objects, order)
    limit_item = 10 # 表示件数
    param = param.to_i
    page = [param, 1].max
    offset_item = (page - 1) * limit_item
    objects.offset(
      offset_item.to_i
    ).limit(
      limit_item.to_i
    ).order(
      order
    )
  end
end
