class OrdersController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  skip_before_filter :verify_authenticity_token, only: [:confirm]

  before_action :authenticate_customer!, except: [:confirm]

  before_action :pick_up_configurated?, only: [:create]

  before_action :set_cart, only: [:create, :confirm]

  before_action :set_order, only: [:destroy, :confirm, :success, :fail]

  # POST /orders
  def create
    @order = @cart.create_order request.remote_ip
    if @order
      redirect_to checkout_path
    else
      redirect_to cart_path, notice:'Ops..'
    end
  end

  # GET /checkout
  def checkout
    @order = current_customer.orders.last
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

      if params[:summarycode] == SecurePay::APPROVED
        @order.approved!
      else
        @order.declined!
      end

      @order.create_payment status: params[:summarycode],
                              code: params[:rescode], #|| '0001',
                       description: params[:restext], # || '000002',
               bank_transaction_id: params[:txnid], # || '0000003',
                     bank_settdate: (params[:settdate]).to_datetime, #|| '20110614'
                       card_number: params[:pan], # || '**** **** **** 8838',
                   card_expirydate: params[:expirydate], # || '0619',
                         timestamp: (params[:timestamp]).to_datetime, #|| '201106141010'
                       fingerprint: params[:fingerprint], # || '01a1edbb159aa01b99740508d79620251c2f871d',
                        ip_address: request.remote_ip,
                      full_request: params.to_s

      if @order.save
        @cart.destroy
        redirect_to success_path
      else
        redirect_to fail_path
      end

    else
      flash.clear
      flash[:error] = 'Payment Failed'
      flash[:error_details] = "Summarycode not received. Params: #{params.to_s}"
      render 'result'
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
      if params[:refid].present?
        @order = Order.find_by code: params[:refid]
      else
        @order = Order.current current_customer
        if @order.nil?
          redirect_to cart_path
        end
      end
    end
end