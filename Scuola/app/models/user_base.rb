class UserBase < ActiveRecord::Base
	has_one :user_asset
	has_one :user_info
	has_one :user_security
	has_many :user_binds # 3party
	has_many :user_pass_resets
	has_many :user_email_registration_verifications

	
	
	validates_presence_of :email
	validates_presence_of :username
	validates_presence_of :password
	validates_format_of :email, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
	validates_uniqueness_of :email
	validates_uniqueness_of :username
	validates_length_of :username , :in => 4..20

	def self.get_pwdsalt(id)
		transaction do
			UserBase.first(:conditions=>["id=?",id]).seed
		end
	end
	def self.random_string(len)
		randstring = ""
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a 
		1.upto(len) { |i| randstring << chars[rand(chars.size-1)] }
		return randstring
	end
	def self.md5(pass)
		Digest::MD5.hexdigest(pass)
	end
	def self.password_hash(pass)
		Digest::SHA256.hexdigest(pass)
	end
	def self.mix_password(pass1,pass2)
		password_hash(md5(pass1.to_s).to_s+pass2.to_s)
	end
	def self.create_user(email,username,password,quiz,ans,seed = random_string(256))
		f = f1 = nil
		begin
			ActiveRecord::Base.transaction do
				f = UserBase.new
				f.email = email
				f.username = username
				f.password = mix_password(password,seed)
				f.seed = seed    
				f.save!
				f.build_user_asset.save!
				f.build_user_info.save!
				f1 = f.build_user_security
				f1.security_quiz = quiz
				f1.security_ans = password_hash(ans)
				f1.save!
				urv = f.user_email_registration_verifications.build
				urv.token = random_string(256)
				urv.sended = false # TODO: sendmail
				urv.save!
				f.save!
			end
			rescue ActiveRecord::RecordInvalid
		end
		return ((f.nil?)?([]):(f.errors.full_messages)) + ((f1.nil?)?([]):(f1.errors.full_messages))
	end
	def self.try_login(email,password,mixed = false)
		transaction do
			user = UserBase.first(:conditions=>["email=?",email])
			return "Bad Email" if (user.blank?)
			if (user.password == (mixed)?(password):(mix_password(password,user.seed)))
				return user
			else
				return "Password Error"
			end
		end
	end

end
