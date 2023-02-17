class Course < ApplicationRecord
  before_create :default_image_attach #createアクション前に画像をアタッチ

  #enumの設定
  enum suggest_time: {
    morning:  0,    #早朝
    noon:     1,    #昼間
    evening:  2,    #夕方
    night:    3     #夜
  }
  enum signal_condition: {
    a_lot_of: 0,    #多い
    a_few:    1,    #少ない
    not_exist:     2,    #無し
  }
  enum traffic_volume: {
    heavy:    0,    #多い
    ordinary: 1,    #それなり
    light:    2,    #少ない
  }
  enum is_slope: {
    steep:    0,    #急
    gentle:   1,    #緩い
    flat:     2,    #平坦
  }
  #各モデルとの関係性
  belongs_to :user
  has_many :positions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :finishes, dependent: :destroy
  has_many_attached :course_images

  #バリデーション
  validates :title, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { minimum: 2, maximum: 400 }
  validates :suggest_time, presence: true
  validates :signal_condition, presence: true
  validates :traffic_volume, presence: true
  validates :is_slope, presence: true
  validates :address, presence: true
  validates :distance, presence: true
  validates :course_images, blob: { content_type: :image }

  def default_image_attach
    if !self.course_images.attached?
      self.course_images.attach(io: File.open(Rails.root.join('app/assets/images/no_image.png')), filename: 'no_image.png', content_type: 'image/png')
    end
  end

  #お気に入り登録しているか確認する
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  #お気に入り登録しているか確認する
  def finished_by?(user)
    finishes.where(user_id: user.id).exists?
  end

  # 都道府県絞り込み検索用スコープ
  scope :region_about, ->(region) {where("address like?", "#{region}%")}
end
