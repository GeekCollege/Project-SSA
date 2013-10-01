class CreateUserRegistrationVerifications < ActiveRecord::Migration
  def change
    create_table :user_registration_verifications do |t|
      t.references :user_base , :null => false
      t.string :token , :null => false
      t.string :type
      t.boolean :sended
      t.timestamps
    end
  end
end
