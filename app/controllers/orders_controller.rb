class OrdersController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  before_action :authenticate_customer!, except: [:confirm]

  before_action :pick_up_configurated?, only: [:create]

  before_action :set_cart, only: [:create]

  before_action :set_order, only: [:checkout, :destroy, :confirm, :success, :fail]

  # POST /orders
  def create
    @order = @cart.create_order request.remote_ip
    if @order
      redirect_to checkout_path
    else
      redirect_to cart_path, notice: 'Ops..'
    end
  end

  # GET /checkout
  def checkout
    @secure_pay = SecurePay.new @order
    @years = (Time.current.year.to_i..(Time.current + 10.years).year.to_i).to_a
    @months = Date::MONTHNAMES.compact
  end

  # DELETE /orders/1
  def destroy
    begin
      @order.destroy
      redirect_to cart_path, notice: t('messages.deleted', model:Order.model_name.human)
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@order.code
      flash[:error_details] = e
      redirect_to checkout_path
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to checkout_path
    end
  end

  # GET|POST /checkout/confirm
  def confirm

    if params[:summarycode].present?

      if params[:summarycode] == SecurePay.APPROVED
        @order.approved!
      else
        @order.declined!
      end

      @order.create_payment status: params[:summarycode],
                              code: params[:rescode],
                       description: params[:restext],
               bank_transaction_id: params[:txnid],
                     bank_settdate: params[:settdate].to_datetime,
                       card_number: params[:pan],
                   card_expirydate: params[:expirydate],
                         timestamp: params[:timestamp].to_datetime,
                       fingerprint: params[:fingerprint],
                        ip_address: request.remote_ip,
                      full_request: params.to_s

      if @order.save
        redirect_to success_path
      else
        redirect_to fail_path
      end

    else
      flash.clear
      flash[:error] = 'Payment Failed'
      flash[:error_details] = "Summarycode not received. Params: #{params.to_s}"
      redirect_to fail_path
    end
  end

  def success

    if @order.approved?
      flash.clear
      flash[:success] = 'Payment Aproved!'
      flash[:success_details] = 'The payment was received!'
      render 'result'
    else
      redirect_to fail_path
    end
  end

  def fail
    flash.clear
    if @order.declined?
      flash[:error] = 'Payment Declined!'
      flash[:error_details] = 'The payment was declined!'
    else
      flash[:error] = 'Payment not received'
      flash[:error_details] = 'Something went wrong..'
    end
    render 'result'
  end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.current current_customer
      if @order.nil?
        redirect_to cart_path
      end
    end
end