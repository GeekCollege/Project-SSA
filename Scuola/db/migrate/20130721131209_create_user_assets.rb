class CreateUserAssets < ActiveRecord::Migration
    def change
        create_table :user_assets do |t|
            t.references :user_base , :null => false

            t.integer :experience , :null => false , :default => 10

            t.integer :course_enrolls_count , :default => 0
            t.integer :course_classes_count , :default => 0
            t.integer :forum_topics_count , :default => 0
            t.integer :user_messages_count , :default => 0
            t.integer :user_mentions_count , :default => 0

            t.timestamps
        end
    end
end
