class User < ApplicationRecord
  before_create :default_image_attach
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #各モデルとの関係性
  has_many :courses, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :finishes, dependent: :destroy
  has_one_attached :user_image

  #フォロワー機能のリレーション
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #バリデーション
  validates :name, presence: true
  validates :introduction, length: { minimum: 2, maximum: 200 }
  validates :user_image, blob: { content_type: :image }

  def default_image_attach
    if !self.user_image.attached?
      self.user_image.attach(io: File.open(Rails.root.join('app/assets/images/no_image.png')), filename: 'no_image.png', content_type: 'image/png')
    end
  end

  def img_resize(width, height)
    self.user_image.variant(resize_to_limit: [width, height]).processed
  end

  #Relationshipモデル関係
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following.include?(user)
  end
end
