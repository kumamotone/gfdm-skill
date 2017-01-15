class CreateReUsers < ActiveRecord::Migration
  def change
    create_table :re_users do |t|
      t.string :name
      t.string :email
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :re_users, :email, unique: true
    add_column :re_users, :password_digest, :string
    add_column :re_users, :remember_token, :string
    add_index  :re_users, :remember_token
    add_column :re_users, :profile, :string
    add_column :re_users, :d_comment, :text
    add_column :re_users, :g_comment, :text
    add_column :re_users, :place, :string
    add_column :re_users, :d, :float, {:default => 0.0}
    add_column :re_users, :dhot, :float, {:default => 0.0}
    add_column :re_users, :dother, :float, {:default => 0.0}
    add_column :re_users, :dall, :float, {:default => 0.0}
    add_column :re_users, :g, :float, {:default => 0.0}
    add_column :re_users, :ghot, :float, {:default => 0.0}
    add_column :re_users, :gother, :float, {:default => 0.0}
    add_column :re_users, :gall, :float, {:default => 0.0}
    add_column :re_users, :skill_updated_at_d, :datetime
    add_column :re_users, :skill_updated_at_g, :datetime
    add_column :re_users, :subadmin, :boolean, default: false, null: false
    add_column :re_users, :twitterid, :string

  end
end
