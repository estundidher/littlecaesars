class Admin::OrdersController < Admin::BaseController

  before_action :set_order, only: [:show, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    respond_to do |format|
      format.html { @orders = Order.order(created_at: :desc) }
      format.json { @orders = Order.order(created_at: :desc) }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    begin
      @order.destroy
      respond_to do |format|
        format.html { redirect_to admin_orders_url, notice: t('messages.deleted', model:Order.model_name.human) }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error] = t 'errors.messages.delete_fail.being_used', model:@order.code
      flash[:error_details] = e
      redirect_to [:admin, @order]
    rescue ActiveRecord::StatementInvalid => e
      flash[:error] = t 'errors.messages.ops'
      flash[:error_details] = e
      redirect_to [:admin, @order]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
end