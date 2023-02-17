class Comment < ApplicationRecord
  #各モデルとの関係性
  belongs_to :user
  belongs_to :course

  #バリデーション
  validates :comment, length: { minimum: 2, maximum: 200 }, presence:true
  validates :course_id, presence: true
  validates :user_id, presence: true
end
