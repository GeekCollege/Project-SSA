class CreateUserBinds < ActiveRecord::Migration
  def change
    create_table :user_binds do |t|
	  t.references :user_base , :null => false
	  t.string :target # user id
	  t.string :token # maybe not useful access_token:token
	  t.string :provider , :null => false
      # add_column :user_binds , :provider , :string # qq / sina / google etc.
      t.timestamps
    end
  end
end
