class ChatController < ApplicationController
	before_action :require_login, except: [:login, :auth]

	def require_login
		if !session[:user_id]
			flash[:error] = "You must login first"
			redirect_to '/login'
		end
	end

	def login
		#TODO: login
	end

	def auth
		#TODO: login
		username = params[:username]
		password = params[:password]


		# salt = BCrypt::Engine.generate_salt
		# encrypted_password = BCrypt::Engine.hash_secret(password, salt)

		user = User.where(username: username).first
		# render json: user
		# return
		if !user || !user.authenticate(password)
			flash[:error] = "Invalid credentials"
			render 'login'
			return
		end
		session[:user_id] = user.id
		redirect_to '/home'
	end

	def logout
		reset_session
		redirect_to '/login'
	end

	def home
		#TODO: 
		# render json: "as"
	end



	# def trainers
	# 	render json: User.where(role: 1)
	# end

	# def users
	# 	render json: User.where(role: 0)
	# end

	def chat
		#TODO: this user
		@thisuser = session[:user_id]

		#TODO: get other users this user chats with
		@chat = Chat.where('user1 = ? OR user2 = ?', @thisuser, @thisuser)

		# @chat.each do |eachChat|
		@chatData = []
		for eachChat in @chat
			user1 = User.find(eachChat.user1)
			user2 = User.find(eachChat.user2)

			chat_with = user1.username
			chat_user_id = user1.id
			role = user1.role == 1 ? "trainer" : "user"
			if eachChat.user1 == @thisuser
				chat_with = user2.username
				chat_user_id = user2.id
				role = user1.role == 1 ? "trainer" : "user"
			end
			thisChat = { "chat_with": chat_with, "chat_user_id": chat_user_id, "role": role }
			
			@chatData << thisChat
			
		end
	end

	def conversation
		#TODO: this user and get param user
		thisuser = session[:user_id]
		message_to = params[:user_id]

		#TODO: get chat conversations all

		chat = Chat.where('(user1=? && user2=?) or (user1=? && user2=?)', thisuser, message_to, message_to, thisuser).take

		@error_message = ""
		@all_messages = []
		@chat_with = User.find(message_to).username
		if !chat
			@error_message = "Invalid Chat"
		else

			chat_message = ChatMessage.where('chat_id=?', chat.id)

			for eachMessage in chat_message
				user = User.find(eachMessage.message_by)
				message_by = user.username
				role = user.role == true ? "trainer" : "user"
				message = eachMessage.message
				message_date = eachMessage.created_at.strftime("%F %H:%M")

				@all_messages << {"message_by": message_by, "message": message, "message_date": message_date, "role": role}
			end
		end
	end

	def message
		#TODO: get all other users list and show form
		thisuser = session[:user_id]
		@users = User.where('id != ?', thisuser)

	end

	def newMessage
		#TODO: add new chat if needed, add new messages for the chat
		thisuser = session[:user_id]
		message_to = params[:message_to]
		message = params[:message]

		chat = Chat.where('(user1=? && user2=?) or (user1=? && user2=?)', thisuser, message_to, message_to, thisuser).take

		if !chat
			chat = Chat.create(user1: thisuser, user2: message_to)
		end

		chat_message = ChatMessage.create(chat_id: chat.id, message: message, message_by: thisuser)

		redirect_to '/chat'
	end
end
