class CreateUserBases < ActiveRecord::Migration
  def change
    create_table :user_bases do |t|
      t.string :username , :null => false
      t.string :password , :null => false
      t.string :seed , :null => false
      t.string :email , :null => false
      t.integer :accesslevel , :default => 0
      t.timestamps
    end
    add_index :user_bases, :username, :unique => true
    add_index :user_bases, :email, :unique => true
  end
end
