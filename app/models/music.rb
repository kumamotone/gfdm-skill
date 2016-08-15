class Music < ActiveRecord::Base
  has_many :skill, dependent: :destroy
  validates :name, :ishot, presence: true
  validates :d_bsc, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :d_adv, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :d_ext, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :d_mas, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}

  validates :g_bsc, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :g_adv, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :g_ext, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :g_mas, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}

  validates :b_bsc, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :b_adv, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :b_ext, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
  validates :b_mas, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 9.99}
end
