class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy, :charge_lesson]
  skip_before_action :authenticate_user!, except: [:destroy]


  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
      @lesson = Lesson.find(@transaction.lesson_id)
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
    @lesson = Lesson.find(@transaction.lesson_id)
  end

  def charge_lesson
    @lesson = Lesson.find(@transaction.lesson_id)
    # Amount in cents
    amount_to_charge = (@lesson.transactions.last.final_amount - @lesson.price.to_i)
    amount_for_stripe = (('%.2f' % amount_to_charge).to_f*100).to_i
    puts "The final amount to be charged is #{@amount}"
    if amount_to_charge > 0
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => amount_for_stripe,
        :description => 'Lesson completion payment',
        :currency    => 'usd'
      )
    end
    @transaction.lesson.state = "Payment complete, waiting for review."
    @transaction.lesson.save
    if current_user && current_user.email == "brian@snowschoolers.com"
      flash[:notice] = 'Thanks! Admin has updated lesson as complete and instructor has not been messaged. You may now email student to remind them to submit a review.'
      redirect_to @transaction.lesson
      else
      @transaction.lesson.send_sms_to_instructor
      flash[:notice] = 'Thank you! Your card has been charged successfully, please now review your instructor.'
      redirect_to @transaction.lesson
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message

  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    if @transaction.tip_amount.nil?
        tip_amount = 0
      elsif @transaction.tip_amount == 0.0009
        tip_amount = 0
      else 
        tip_amount = @transaction.tip_amount*@transaction.base_amount
    end
    # tip_amount = @transaction.tip_amount.nil? ? 0 : @transaction.tip_amount*@transaction.base_amount
    @transaction.final_amount = @transaction.base_amount + tip_amount
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction.lesson, notice: 'Your tip amount was confirmed, please now complete payment.' }
        format.json { render action: 'show', status: :created, location: @transaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        if @transaction.tip_amount.nil?
            tip_amount = 0
          elsif @transaction.tip_amount == 0.0009
            tip_amount = 0
          else 
            tip_amount = @transaction.tip_amount*@transaction.base_amount
        end
        @transaction.final_amount = @transaction.base_amount + tip_amount
        @transaction.save
        format.html { redirect_to @transaction.lesson, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:lesson_id, :requester_id, :base_amount, :tip_amount, :final_amount)
    end
end
