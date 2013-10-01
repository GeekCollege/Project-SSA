class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      
      t.references :user_base , :null => false

      t.string :realname , :default => "路人甲"
      
      t.datetime :birthday , :default => DateTime.parse('1999-9-9 9:9:9').strftime('%Y-%m-%d %H:%M:%S').to_s  
    
      t.string :country , :default => "中国"
      t.string :province , :default => "北京"
      t.string :city , :default => "北京"
      t.text :address , :default => "不告诉你"
      t.text :school , :default => "某个学校"
      t.string :qq , :default => "10000"
      t.string :phone , :default => "88888888"
      t.string :mobile , :default => "18966666666"

      t.text :interest , :default => "我最强"
      t.string :gender , :default => "男"

      t.text :signature , :default => ""

      t.timestamps
    end
  end
end
