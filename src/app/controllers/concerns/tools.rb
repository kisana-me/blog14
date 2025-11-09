module Tools
  def generate_random_problem
    num1 = rand(100)
    num2 = rand(1..10)
    operator = %w[+ - * /].sample
    num1 -= (num1 % num2) if operator == "/"
    problem = "#{num1} #{operator} #{num2}"
    [problem, eval(problem)]
  end
end
