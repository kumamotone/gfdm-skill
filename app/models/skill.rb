class Skill < ActiveRecord::Base
    belongs_to :user
    belongs_to :music
    validates :user_id, presence: true
    validates :comment, length: { maximum: 100 }
    validates :music_id, uniqueness: { scope: [:user_id, :g_kind] }
    validates :music_id, uniqueness: { scope: [:user_id, :d_kind] }
    #validates :g_kind
    validates :rate, presence: true, numericality: {less_than_or_equal_to: 100.0} # 数値か小数点のみ有効
end
