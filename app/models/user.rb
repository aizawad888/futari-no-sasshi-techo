class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿
  has_many :posts, dependent: :destroy

  # ペア
  has_many :pairs_as_user1, class_name: "Pair", foreign_key: :user_id1, dependent: :nullify
  has_many :pairs_as_user2, class_name: "Pair", foreign_key: :user_id2, dependent: :nullify

  # 自分の有効なペアを返す
  def active_pair
    (pairs_as_user1 + pairs_as_user2).find(&:active)
  end

  before_create :generate_my_code

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  private

  def generate_my_code
    # SecureRandom.hex(4) → 8文字のランダム文字列
    self.my_code = loop do
      code = SecureRandom.hex(4)
      break code unless User.exists?(my_code: code)
    end
  end
end
