class Address < ApplicationRecord
  #各モデルとの関係性
  belongs_to :course
  
  #絞り込み検索ようのスコープ
  scope :region_about, ->(region) {where("name like?", "#{region}%")}
end
