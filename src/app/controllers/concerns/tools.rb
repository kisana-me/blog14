module Tools
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  def generate_aid(model, column)
    loop do
      aid = ('a'..'z').to_a.concat(('0'..'9').to_a).shuffle[1..17].join
      if !model.exists?(column.to_sym => aid)
        return aid
        break
      end
    end
  end
end