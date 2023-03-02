class Entity < ApplicationRecord
  # 各モデルとの関係
  belongs_to :course
  
  # 検索スコープ
  scope :key_word_search, ->(key_word) {where("key_word like?", "%#{key_word}%")}
end
