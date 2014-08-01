class OrdersController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  skip_before_filter :verify_authenticity_token, only: [:confirm]

  skip_before_action :check_pending_order

  before_action :authenticate_customer!, except: [:confirm]

  before_action :pick_up_configurated?, only: [:create]

  before_action :set_cart, only: [:create, :confirm]

  before_action :set_order, only: [:reload, :update, :index, :destroy, :confirm, :success, :fail]

  # POST /orders
  def create
    @order = @cart.create_order request.remote_ip
    if @order
      redirect_to protocol:'http://', checkout_path(@order.code)
    else
      redirect_to cart_path, notice:'Ops..'
    end
  end

  # GET /checkout/code
  def index
    @secure_pay = SecurePay.new @order
    @years = (Time.current.year.to_i..(Time.current + 10.years).year.to_i).to_a
    @months = Date::MONTHNAMES.compact
  end

  # GET /orders/code/update
  def update
    if @order.allow_send?
      @order.post
      render nothing:true, status: :ok
    else
      render nothing:true, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    if @order.pending? || @order.sent?
      code = @order.code
      @order.cancelled!
      redirect_to cart_path, notice: t('messages.cancelled', model:"#{Order.model_name.human} #{code}")
    else
      redirect_to cart_path
    end
  end

  # GET|POST /checkout/confirm
  def confirm

    if @order.sent? && params[:summarycode].present?

      if params[:summarycode] == SecurePay::APPROVED
        @order.approve!
      else
        @order.decline!
      end

      settdate = nil
      if params[:settdate].present?
        settdate = params[:settdate].to_datetime
      end

      @order.payment.destroy if @order.payment.present?

      @order.create_payment status: params[:summarycode],
                              code: params[:rescode],
                       description: params[:restext],
               bank_transaction_id: params[:txnid],
                     bank_settdate: settdate,
                       card_number: params[:pan],
                   card_expirydate: params[:expirydate],
                         timestamp: params[:timestamp].to_datetime,
                       fingerprint: params[:fingerprint],
                        ip_address: request.remote_ip,
                      full_request: params.to_s

      render nothing:true, status: :ok
    else
      render nothing:true, status: :forbidden
    end
  end

private

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      if params[:refid].present?
        @order = Order.find_by code:params[:refid]
      elsif params[:code].present?
        @order = Order.find_by code:params[:code], customer:current_customer
      else
        @order = current_customer.orders.last
      end
      @order.check_expiration if @order.present?
      redirect_to cart_path if @order.nil?
    end
end