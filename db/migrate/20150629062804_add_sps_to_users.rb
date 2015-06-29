class AddSpsToUsers < ActiveRecord::Migration
  def change
      add_column :users, :d, :float, {:default => 0.0}
      add_column :users, :dhot, :float, {:default => 0.0}
      add_column :users, :dother, :float, {:default => 0.0}
      add_column :users, :dall, :float, {:default => 0.0}
      add_column :users, :g, :float, {:default => 0.0}
      add_column :users, :ghot, :float, {:default => 0.0}
      add_column :users, :gother, :float, {:default => 0.0}
      add_column :users, :gall, :float, {:default => 0.0}
  end
end
