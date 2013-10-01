class UserSecurity < ActiveRecord::Base
	belongs_to :user_base
    validates_presence_of :security_quiz , :security_ans
    validates_length_of :security_quiz , :minimum => 5
end
