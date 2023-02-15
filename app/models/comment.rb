class Comment < ApplicationRecord
  #各モデルとの関係性
  belongs_to :user
  belongs_to :course
end
