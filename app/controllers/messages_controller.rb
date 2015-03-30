class MessagesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user
  before_filter :verified_user
  before_filter :get_counts
  
  def contacts
    @contacts = current_user.friends.order("last_name DESC")
  end
  
  def sent_messages
    @sent_messages = current_user.sent_messages.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
  
  def join_requests
    @join_requests_received = current_user.join_requests_received.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
  
  def index
    @received_messages = current_user.received_messages.order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
  
  def show
    @message = Message.find(params[:id])
    @message.view_message if current_user?(@message.receiver)
  end
  
  def create
    @project = Project.find_by_id(params[:message][:project_id])
    @message = Message.new(params[:message])
    @comments = @project.comments.roots.order("created_at DESC") if @project
    @comment = Comment.new
    if @message.save
      @message.send_new_message_email
      redirect_to user_messages_path(current_user, sent: true), notice: "Your message has been sent to #{@message.receiver.full_name}"
    else
      if @project
        @comments = @project.comments.roots.order("created_at ASC")
        @comment = @project.comments.new
        @commentable = @project
        render 'projects/show'
      else
        redirect_to user_messages_path(current_user), alert: "Message not sent. Please include a subject and body."
      end
    end
  end
  
  private
  
    def get_counts
      @join_requests_received_count = current_user.join_requests_received.where(state: "0").size
      @received_messages_count = current_user.received_messages.where(viewed: false).size
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
      redirect_to current_user, alert: 'You must have a verified account to view messages' unless current_user.verified
    end
end
