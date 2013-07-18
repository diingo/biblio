class AddUseridToBooks < ActiveRecord::Migration
  # def change
  #   add_column :books, :user_id, :integer, references: :users
  # end

  def change
    change_table :books do |t|
      t.references :user, index: true 
    end
  end
  def down
    change_table :books do |t|
      t.remove :user_id
    end
  end

end
