class CreateUserPassResets < ActiveRecord::Migration
  def change
    create_table :user_pass_resets do |t|
      t.references :user_base , :null => false

      t.string :token , :null => false

      t.timestamps
    end
  end
end
