class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  def show_conversation
    @user = current_user
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages
    @message = Message.new
    render 'conversation'
  end

  def start_conversation
    @message = Message.new
    @conversation = Conversation.find_or_create_by(requester_id:current_user.id, instructor_id: params[:instructor_id])
    @messages = @conversation.messages
    @message.send_sms_to_instructor(@conversation)
    redirect_to show_conversation_path(@conversation)
  end

  def my_conversations
    if current_user.instructor.nil?
      @conversations = Conversation.where(requester_id:current_user.id)
    elsif current_user.email == "brian@snowschoolers.com"
      @conversations = Conversation.all
    elsif current_user.instructor
      @conversations = Conversation.where(instructor_id: current_user.instructor.id)
    else
    end
    render 'my_conversations'
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to show_conversation_path(@message.conversation_id), notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def set_instructor
      @instructor = Instructor.find(params[:instructor_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:author_id, :conversation_id, :content, :unread, :recipient_id)
    end
end
