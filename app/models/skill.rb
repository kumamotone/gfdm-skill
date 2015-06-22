class Skill < ActiveRecord::Base
    belongs_to :user
    belongs_to :music
    validates :user_id, presence: true
    validates :comment, length: { maximum: 100 }
    validates :music_id, presence: true, uniqueness: { scope: [:user_id, :kind] }
    validates :kind, presence: true
    validates :rate, presence: true, numericality: {less_than_or_equal_to: 100.0} # 数値か小数点のみ有効
end
