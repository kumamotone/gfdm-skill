class Music < ActiveRecord::Base
    has_many :skill, dependent: :destroy
end
