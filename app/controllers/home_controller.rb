class HomeController < ApplicationController
  include PickUpConfiguratedConcern

  before_action :set_product, only: [:product]
  before_action :set_category, only: [:category]

  # GET /
  def index
    render layout:'generic'
  end

  # GET /contact
  def contact
    @contact = Contact.new
  end

  def send_message
    @contact = Contact.new contact_params
    if verify_recaptcha(model: @contact, message:"Oh! It's error with reCAPTCHA!") and @contact.valid?
      ContactMailer.request_info(@contact.name, @contact.email, @contact.message).deliver
      flash[:success] = 'Message sent!'
      @contact = Contact.new
    end
    render 'contact'
  end

  # GET /about
  def about
    @chefs = Chef.order(:name)
  end

  # GET /privacy
  def privacy
    render partial:'home/term', locals:{term:'privacy'}, layout: nil
  end

  # GET /terms
  def terms
    render partial:'home/term', locals:{term:'terms'}, layout: nil
  end

  # GET /returns
  def returns
    render partial:'home/term', locals:{term:'returns'}, layout: nil
  end

  private

      # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def set_cart
      @cart = Cart.current current_customer
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit :name,
                                      :email,
                                      :message
    end
end