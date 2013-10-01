class CreateUserMessages < ActiveRecord::Migration
	def change
    	create_table :user_messages do |t|
    		t.integer    :user_base_sender_id , :null => false
    		t.references :user_asset , :null => false
    		t.string     :title
    		t.text       :message
    		t.boolean    :read , :default => false
        	t.timestamps
    	end
  	end
end
