class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.integer :isbn
      t.string :picture
      t.string :publisher
      t.string :author

      t.timestamps
    end
  end
end
