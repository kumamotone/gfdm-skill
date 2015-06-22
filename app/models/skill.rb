require 'csv'

class Skill < ActiveRecord::Base
  belongs_to :user
  belongs_to :music
  validates :user_id, presence: true
  validates :comment, length: { maximum: 100 }
  validates :music_id, presence: true, uniqueness: { scope: [:user_id, :kind] }
  validates :kind, presence: true
  validates :rate, presence: true, numericality: {less_than_or_equal_to: 100.0} # 数値か小数点のみ有効

  def self.to_csv
    CSV.generate do |csv|
      # column_namesはカラム名を配列で返す
      # 例: ["id", "name", "price", "released_on", ...]
      new_column_names = column_names.delete_if {|item| item == "id" || 
      item == "user_id" || item == "created_at" || item == "updated_at" }
      csv << new_column_names
      all.each do |s|
        # attributes はカラム名と値のハッシュを返す
        # 例: {"id"=>1, "name"=>"レコーダー", "price"=>3000, ... }
        # valudes_at はハッシュから引数で指定したキーに対応する値を取り出し、配列にして返す
        # 下の行は最終的に column_namesで指定したvalue値の配列を返す
        csv << s.attributes.values_at(*new_column_names)
      end
    end
  end
end
