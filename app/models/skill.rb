require 'csv'
require 'nkf'

class Skill < ActiveRecord::Base
  belongs_to :user
  belongs_to :music
  validates :user_id, presence: true
  validates :comment, length: {maximum: 100}
  validates :music_id, presence: true, uniqueness: {scope: [:user_id, :kind]}
  validates :kind, presence: true
  validates :sp, presence: true, numericality: {greater_than_or_equal_to: 0, less_than: 200.0}
  validates :rate, presence: true, numericality: {less_than_or_equal_to: 100.0} # 数値か小数点のみ有効
  validates_format_of :rate, :with => /\A\d+(\.\d{1,2})?\z/

  def self.to_csv
    csv_str = CSV.generate do |csv|
      # column_namesはカラム名を配列で返す
      # 例: ["id", "name", "price", "released_on", ...]
      new_column_names = column_names.delete_if { |item| item == "id" ||
          item == "user_id" || item == "sp" || item == "created_at" || item == "updated_at" }
      csv << new_column_names
      all.each do |s|
        # attributes はカラム名と値のハッシュを返す
        # 例: {"id"=>1, "name"=>"レコーダー", "price"=>3000, ... }
        # valudes_at はハッシュから引数で指定したキーに対応する値を取り出し、配列にして返す
        # 下の行は最終的に column_namesで指定したvalue値の配列を返す
        csv << s.attributes.values_at(*new_column_names)
      end
    end
    NKF::nkf('--sjis -Lw', csv_str)
  end

  def self.import_preview(file, id)
    results = []
    row_number = 1

    # 文字コード変換のためにKernel#openとCSV#newを併用。
    # 参考: http://qiita.com/labocho/items/8559576b71642b79df67
    open(file.path, 'r:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      csv.each do |row|
        next if row.header_row?

        # CSVの行情報をHASHに変換
        table = Hash[[row.headers, row.fields].transpose]

        # 登録済みユーザー情報取得。
        # 登録されてなければ作成

        music_id = table["music_id"]
        if music_id.nil? || music_id.empty?
          # first を付けないと謎の型が返ってくる
          # http://stackoverflow.com/questions/27021036/undefined-method-id-for-activerecordrelation
          music = Music.where(name: table["name"]).first
          unless music.nil?
            music_id = music.id
          end
        end

        # binding.pry

        skill = find_by(:music_id => music_id, :kind => table["kind"], :user_id => id)
        if skill.nil?
          # binding.pry
          skill = new
          skill.music_id = music_id
          skill.kind = table["kind"]
          skill.rate = table["rate"]

          if music_id.nil?
            kind = skill.kind.nil? ? "nil" : skill.kind
            rate = skill.rate.nil? ? "nil" : skill.rate
            result = {row: row_number, name: table["name"], kind: kind, rate: rate,  error: "name_error"}
            results.push(result)
            row_number += 1
            next
          end

          skill.sp = ApplicationController.helpers.calc_sp(skill)
          skill.user_id = id
        end

        # raise "hoge"
        # バリデーションOKの場合は保存
        if skill.valid?
          kind = skill.kind.nil? ? "nil" : skill.kind
          rate = skill.rate.nil? ? "nil" : skill.rate
          result = {row: row_number, name: table["name"], kind: kind, rate: rate,  error: nil}
          results.push(result)
        else
          kind = skill.kind.nil? ? "nil" : skill.kind
          rate = skill.rate.nil? ? "nil" : skill.rate
          result = {row: row_number, name: table["name"], kind: kind, rate: rate,  error: "error"}
          results.push(result)
        end
        row_number += 1
      end
    end
    return results
  end

  def self.import(file, id)
    imported_num = 0

    # 文字コード変換のためにKernel#openとCSV#newを併用。
    # 参考: http://qiita.com/labocho/items/8559576b71642b79df67
    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      csv.each do |row|
        next if row.header_row?

        # CSVの行情報をHASHに変換
        table = Hash[[row.headers, row.fields].transpose]

        # 登録済みユーザー情報取得。
        # 登録されてなければ作成

        skill = find_by(:music_id => table["music_id"], :name => table["name"], :kind => table["kind"], :user_id => id)
        if skill.nil?
          skill = new
          skill.user_id = id
        end

        # 情報更新
        skill.attributes = table.to_hash.slice(
            *table.to_hash.except(:id, :created_at, :updated_at).keys)
        skill.sp = ApplicationController.helpers.calc_sp(skill)

        # バリデーションOKの場合は保存
        if skill.valid?
          skill.save!
          imported_num += 1
        end
      end
    end
    ApplicationController.helpers.updatedrum(id)
    ApplicationController.helpers.updateguitar(id)

    # 更新件数を返却
    imported_num

  end
end
