class Position < ApplicationRecord
  #各モデルとの関係性
  belongs_to :course

  #バリデーション
  validates :lat, presence: true
  validates :lng, presence: true
  validates :course_id, presence: true
end
