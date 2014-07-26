class OrdersController < ApplicationController
  include PickUpConfiguratedConcern
  include CartConcern

  skip_before_filter :verify_authenticity_token, only: [:confirm]

  skip_before_action :check_pending_order

  before_action :authenticate_customer!, except: [:confirm]

  before_action :pick_up_configurated?, only: [:create]

  before_action :set_cart, only: [:create, :confirm]

  before_action :set_order, only: [:reload, :checkout, :destroy, :confirm, :success, :fail]

  # POST /orders
  def create
    @order = @cart.create_order request.remote_ip
    if @order
      redirect_to checkout_path(@order.code)
    else
      redirect_to cart_path, notice:'Ops..'
    end
  end

  # GET /checkout/code
  def checkout
    redirect_to cart_path unless @order.pending?
    @secure_pay = SecurePay.new @order
    @years = (Time.current.year.to_i..(Time.current + 10.years).year.to_i).to_a
    @months = Date::MONTHNAMES.compact
  end

  # GET /checkout/code/reload
  def reload
    if @order.pending?
      @secure_pay = SecurePay.new @order
      @years = (Time.current.year.to_i..(Time.current + 10.years).year.to_i).to_a
      @months = Date::MONTHNAMES.compact
      render partial:'form'
    else
      render partial:'payment'
    end
  end

  # DELETE /orders/1
  def destroy

    redirect_to cart_path unless @order.pending?

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

    if @order.pending? && params[:summarycode].present?

      if params[:summarycode] == SecurePay::APPROVED
        @order.approved!
      else
        @order.declined!
      end

      @order.create_payment status: params[:summarycode],
                              code: params[:rescode],
                       description: params[:restext],
               bank_transaction_id: params[:txnid],
                     bank_settdate: params[:settdate].present? ? params[:settdate].to_datetime : null,
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
        @order = Order.find_by code:params[:code]
      else
        @order = current_customer.orders.last
        redirect_to cart_path if @order.nil?
      end
    end
end