class CreateUserSecurities < ActiveRecord::Migration
  def change
    create_table :user_securities do |t|
      t.references :user_base , :null => false

      t.timestamp :lastlogin 

      t.timestamp :lastvisit_time
      t.string :lastvisit_place , :default => ""
      t.string :lastvisit_ip

      t.timestamp :release # when forbidden
      t.references :user_base # who ban you
      t.text :reason #ban reason

      t.string :reset_pass_token

      t.string :security_quiz , :null => false
      t.string :security_ans , :null => false # hash

      t.timestamps
    end
  end
end
