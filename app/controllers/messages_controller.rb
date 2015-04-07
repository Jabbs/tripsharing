class MessagesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  before_filter :verified_user
  before_filter :sender_or_receiver, only: [:show]
  
  def contacts
    @contacts = current_user.friends.order("last_name DESC").paginate(page: params[:page], per_page: 20)
  end
  
  def sent_messages
    @sent_messages = current_user.sent_messages.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
  
  def join_requests
    @join_requests_received = current_user.join_requests_received.order("created_at DESC").paginate(page: params[:page], per_page: 10)
    @join_requests_sent = current_user.join_requests_sent.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
  
  def index
    @received_messages = current_user.received_messages.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
  
  def show
    @message = Message.find(params[:id])
    @message.view_message if current_user?(@message.receiver)
  end
  
  def create
    @message = current_user.sent_messages.build(message_params)
    if @message.save
      @message.receiver.add_friend(current_user)
      Notification.add_to(@message.receiver, "P")
      UserMailer.delay.message_new_email(@message.receiver, @message)
      redirect_to user_messages_path(current_user), notice: "Your message has been sent."
    else
      redirect_to user_messages_path(current_user), alert: "There was an issue submitting your message."
    end
  end
  
  private
    
    def message_params
      params.require(:message).permit(:subject, :content, :receiver_id, :sender_id)
    end
  
    def admin_user
      redirect_to(root_path) unless current_user && current_user.admin?
    end
    
    def correct_user
      @user = User.friendly.find(params[:user_id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
    
    def sender_or_receiver
      @message = Message.find(params[:id])
      redirect_to(root_path) unless current_user?(@message.sender) || current_user?(@message.receiver) || current_user.admin?
    end
    
    def signed_in_user_go_to_dash
      if current_user
        redirect_to root_path
      end
    end
    
    def verified_user
      redirect_to current_user, alert: 'You must have a verified account to access messages' unless current_user.verified
    end
end
