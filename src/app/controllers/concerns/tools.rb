module Tools
  def generate_random_problem
    num1 = rand(100)
    num2 = rand(1..10)
    operator = %w[+ - * /].sample
    if operator == '/'
      num1 = num1 - (num1 % num2)
    end
    problem = "#{num1} #{operator} #{num2}"
    [problem, eval(problem)]
  end

  # Pagination
  def total_page(objects)
    total = objects.count
    per_page = 10 # 表示件数
    return total.to_i > 0 ? (total.to_f / per_page.to_f).ceil : 0
  end

  def paged_objects(param, objects, order)
    limit_item = 10 # 表示件数
    param = param.to_i
    page = param < 1 ? 1 : param
    offset_item = (page - 1) * limit_item
    return objects.offset(
      offset_item.to_i
    ).limit(
      limit_item.to_i
    ).order(
      order
    )
  end
end
