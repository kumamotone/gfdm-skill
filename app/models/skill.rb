class Skill < ActiveRecord::Base
    belongs_to :user
    belongs_to :music
    validates :user_id, presence: true
    validates :comment, length: { maximum: 100 }
end
