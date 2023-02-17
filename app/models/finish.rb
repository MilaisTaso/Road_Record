class Finish < ApplicationRecord
  #各モデルとの関係性
  belongs_to :user
  belongs_to :course

  #バリデーション
  validates :course_id, presence: true, uniqueness: { scope: :user_id }
  validates :course_id, presence: true
  validates :user_id, presence: true
end
