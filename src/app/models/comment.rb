class Comment < ApplicationRecord
  belongs_to :account, optional: true
end
