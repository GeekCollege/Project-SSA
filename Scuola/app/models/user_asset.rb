class UserAsset < ActiveRecord::Base
	belongs_to :user_base
	has_many :user_messages

	def user_messages_sended
		UserMessage.where(user_base_sender_id: user_base.id)
	end
	def user_messages_received
		user_messages
	end
	def user_messages_unread
		user_messages.where(read: false)
	end
end
