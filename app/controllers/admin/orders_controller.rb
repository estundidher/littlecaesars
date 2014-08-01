class Admin::OrdersController < Admin::BaseController

  before_action :set_order, only: [:show, :destroy]

  # GET /orders
  # GET /orders.json
  def index

    query = Order.all

    if params['code'].present?
      query = query.where code: params['code'].to_s
    end

    if params['place_id'].present?
      query = query.joins(pick_up: :place)
                   .where(places: {id:params[:place_id].to_i})
    end

    if params['customer_id'].present?
      query = query.joins(:customer)
                   .where(customers: {id:params[:customer_id].to_i})
    end

    if params['state'].present?
      query = query.where(state: params[:state])
    end

    if params['attempts'].present?
      query = query.where(attempts: params[:attempts])
    end

    if params['date_from'].present? && params['date_to'].present?

      from = params[:date_from].to_datetime.change({hour:00 , min:00 , sec:00 })
      to = params[:date_to].to_datetime.change({hour:23 , min:59 , sec:59 })

      query = query.where("created_at >= :start_date AND created_at <= :end_date",
              {start_date: from, end_date: to})
    end

    if params['pick_date_from'].present? && params['pick_date_to'].present?

      pick_from = params[:pick_date_from].to_datetime.change({hour:00 , min:00 , sec:00 })
      pick_to = params[:pick_date_to].to_datetime.change({hour:23 , min:59 , sec:59 })

      query = query.joins(:pick_up)
                   .where('pick_ups.date >= :start_date and pick_ups.date <= :end_date',
                    {start_date: pick_from, end_date: pick_to})
    end

    respond_to do |format|
      format.html { @orders = query.order(created_at: :desc) }
      format.json { @orders = query.order(created_at: :desc) }
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