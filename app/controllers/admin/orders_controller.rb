class Admin::OrdersController < Admin::BaseController

  before_action :set_order, only: [:show, :destroy, :print, :done]

  # GET /admin/orders
  # GET /admin/orders.json
  def index

    query = Order.all

    filter = false

    if params['code'].present?
      query = query.where code: params['code'].to_s
      filter = true
    end

    if params['place_id'].present?
      query = query.joins(pick_up: :place)
                   .where(places: {id:params[:place_id].to_i})
      filter = true
    end

    if params['customer_id'].present?
      query = query.joins(:customer)
                   .where(customers: {id:params[:customer_id].to_i})
      filter = true
    end

    if params['state'].present?
      query = query.where(state: params[:state])
      filter = true
    end

    if params['attempts'].present?
      query = query.where(attempts: params[:attempts])
      filter = true
    end

    if params['date_from'].present? && params['date_to'].present?

      from = params[:date_from].to_datetime.change({hour:00 , min:00 , sec:00 })
      to = params[:date_to].to_datetime.change({hour:23 , min:59 , sec:59 })

      query = query.where("created_at >= :start_date AND created_at <= :end_date",
              {start_date: from, end_date: to})
      filter = true
    end

    if params['pick_date_from'].present? && params['pick_date_to'].present?

      pick_from = params[:pick_date_from].to_datetime.change({hour:00 , min:00 , sec:00 })
      pick_to = params[:pick_date_to].to_datetime.change({hour:23 , min:59 , sec:59 })

      query = query.joins(:pick_up)
                   .where('pick_ups.date >= :start_date and pick_ups.date <= :end_date',
                    {start_date: pick_from, end_date: pick_to})
      filter = true
    end

    unless filter
      query = query.limit(50)
    end

    respond_to do |format|
      format.html { @orders = query.order(created_at: :desc) }
      format.json { @orders = query.order(created_at: :desc) }
    end
  end

  # GET /admin/orders.json
  def show
    respond_to do |format|
      format.html { @order }
      format.json { render json: @order, methods: :tax, except:[:state, :notes, :ip_address, :customer_id, :pick_up_id, :created_at, :created_by, :updated_at, :updated_by, :attempts],
                                    include: [{customer: {except:[:created_at, :created_by, :updated_at, :updated_by]}},
                                       {pick_up: {methods: :date_s, except:[:date, :created_at, :created_by, :updated_at, :updated_by],
                                          include:{place: {methods: :printer_ip_s, except: [:map, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :code, :enabled, :printer_ip, :created_at, :created_by, :updated_at, :updated_by, :description]}}}},
                                          items: {except: [:size_id, :notes, :order_id, :product_id, :quantity, :created_at, :created_by, :updated_at, :updated_by, :first_half_id, :second_half_id],
                                            include: [{first_half:{except: [:size_id, :notes, :order_id, :product_id, :quantity, :created_at, :created_by, :updated_at, :updated_by, :first_half_id, :second_half_id]}},
                                                      {second_half:{except: [:size_id, :notes, :order_id, :product_id, :quantity, :created_at, :created_by, :updated_at, :updated_by, :first_half_id, :second_half_id]}}]}]}
    end
  end

  # GET /admin/live
  def live

    query = Order.approved.processing

    if params[:place_id].present?
      query = query.joins(pick_up: :place)
                   .where(places: {id:params[:place_id].to_i})
    end

    @orders = query.order("pick_ups.date ASC")
  end

  # GET /admin/order/id/done
  def done
    unless @order.done?
      @order.done!
      @order.save!
    end
    render nothing:true, status: :ok
  end

  # DELETE /admin/orders/id
  # DELETE /admin/orders/id.json
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