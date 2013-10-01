class HomeController < ApplicationController

	def dash

	end

	def login
		@page_title = "登录"
		@user_base = UserBase.new
	end

	def logout
		@page_title = "注销"
		session[:email] = session[:password] = nil
		# TODO: Cookies
		if (params[:return_url].blank?)
			redirect_to :action => "dash"
		else
			redirect_to  params[:return_url]
		end
		
	end

	def register
		@page_title = "注册"
		@user_base = UserBase.new
		@user_security = UserSecurity.new
	end

	def verify
		@page_title = "登录"
		params.permit!
		@errors = []
		@user_base = try_login(params[:user_base][:email],params[:user_base][:password])
		if @user_base.is_a?(String)
			@errors = [@user_base]
			@user_base = UserBase.new		
		end
		respond_to do |format|
			format.html { 
				render :action => :login if @errors.any?
			}
			format.json { 
				if (@errors.any?)
					render :json => {"failed"=>true,"errors"=>@errors,"callback" => "home.process_login"}.to_json
				else
					render :json => {"failed"=>false,"user"=> @user_base.username,"callback" => "home.process_login"}.to_json
				end
			}
		end
	end

	def newuser
		@page_title = "注册"
		params.permit!
		@errors = []
		#:remote => true,
		#formcheck_agrees
		@errors << "请同意用户协议后再进行注册" if params[:formcheck][:agrees] != "1"
		@errors << "密码位数不足（至少需要8位）" if (params[:user_base][:password].length < 8)
		@errors << "两次密码不同" if (params[:user_base][:password] != params[:confirm_password])
		@errors = UserBase.create_user(params[:user_base][:email],params[:user_base][:username],params[:user_base][:password],params[:user_security][:security_quiz],params[:user_security][:security_ans]) unless (@errors.any?)
		@user_security = UserSecurity.new
		unless (@errors.any?)
			@user_base = try_login(params[:user_base][:email],params[:user_base][:password])
			if (@user_base.is_a?(String))
				@errors = ["未知错误：" + @user_base]
				@user_base = nil
			end
		end
		respond_to do |format|
			format.html { 
				render :action => :register if @errors.any?
			}
			format.json { 
				if (@errors.any?)
					render :json => {"failed"=>true,"errors"=>@errors,"callback" => "home.process_newuser"}.to_json
				else
					render :json => {"failed"=>false,"user"=>"@" + @user_base.username,"callback" => "home.process_newuser"}.to_json
				end
			}
		end
	end

	# need login
	def index
		
	end

	def center
		if (@user_base.nil?)
			redirect_to login_path
			return 
		end
		@unread_message = @user_base.user_asset.user_messages_unread.count
		@page_title = "用户中心"
	end

	def messages_list
		if (@user_base.nil?)
			render :json => {"failed"=>true,"errors"=>"access forbidden"}.to_json
			return 
		end
		msg = @user_base.user_asset.user_messages_received.select("id , user_base_sender_id , title , read , created_at").order("created_at DESC").all
		body = []
		msg.each { |x| 
			begin
				sender = UserBase.find(x.user_base_sender_id)
			rescue ActiveRecord::RecordNotFound
				sender = nil
			end
			if (sender.blank?) 
				sender = "用户已经被间隙"
			else
				sender = sender.username
			end
			body << {
				"mid" => x.id ,
				"title" => x.title ,
				"sender" => sender ,
				"senderid" => x.user_base_sender_id ,
				"read" => x.read ,
				"created_at" => x.created_at
			}
		}
		render :json => {"failed" => false,"body" => body,"callback"=>"home.process_messagelist"}.to_json
	end

	def messages_count
		if (@user_base.nil?)
			render :json => {"failed"=>true,"errors"=>"access forbidden"}
			return 
		end
		render :json => {"failed" => false,"count" => @user_base.user_asset.user_messages_unread.count,"callback"=>"home.process_messagecount"}.to_json
	end

	def message_send
		if (@user_base.nil?)
			render :json => {"failed"=>true,"errors"=>"access forbidden"}.to_json
			return 
		end
		params.permit!
		# TODO: check if target allows message send
		msg = nil
		begin
			ActiveRecord::Base.transaction do
				sender = @user_base
				sendto = UserBase.first(:conditions=>["username=?",params[:user_message][:username]])
				if (sendto.blank?)
					render :json => {
						"failed" => true,
						"status"=>false,
						"msg"=>"找不到" +  params[:user_message][:username],
						"callback"=>"home.process_messagesend"
					}.to_json 
					return 
				end
				msg = sendto.user_asset.user_messages.build
				msg.user_base_sender_id = sender.id
				msg.message = params[:user_message][:text]
				msg.read = false
				msg.title = params[:user_message][:title]
				msg.save!
			end
		rescue ActiveRecord::RecordInvalid
		end
		@errors = [] + ((msg.nil?) ? ([]) : (msg.errors.full_messages))
		if (@errors.any?) 
			render :json => {
				"failed" => true,
				"status"=>false,
				"msg"=> @errors,
				"callback"=>"home.process_messagesend"
			}.to_json
			return 
		end
		render :json => {"failed" => false,"status"=>true,"callback"=>"home.process_messagesend"}.to_json 
	end

	def message
		if (@user_base.nil?)
			render :json => {"failed"=>true,"errors"=>"access forbidden"}.to_json
			return 
		end
		params.permit!
		begin
			msg = @user_base.user_asset.user_messages_received.find(params['mid'].to_i)
		rescue ActiveRecord::RecordNotFound
			msg = nil
		end
		if (msg.blank?)
			render :json => {"failed"=>true,"errors"=>"站内信被吃掉了！","callback"=>"home.process_message"}.to_json
			return
		end
		begin
			sender = UserBase.find(msg.user_base_sender_id)
		rescue ActiveRecord::RecordNotFound
			sender = nil
		end
		if (sender.blank?) 
			sender = "用户已经被间隙"
		else
			sender = sender.username
		end
		body = {
			"mid" => msg.id ,
			"title" => msg.title,
			"sender" => sender ,
			"senderid" => msg.user_base_sender_id ,
			"read" => msg.read ,
			"message" => markdown(msg.message)
		}
		msg.read = true;
		msg.save
		render :json => {"failed" => false,"body"=>body,"callback"=>"home.process_message"}.to_json 
	end
end