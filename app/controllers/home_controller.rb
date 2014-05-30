class HomeController < ApplicationController

  before_action :set_product, only: [:product]
  before_action :set_category, only: [:category]

  def index
    render layout:'generic'
  end

  def order
    unless customer_signed_in?
      redirect_to pick_up_path
    end
  end

  def category
  end

  def product
  end

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

  def about
    @chefs = Chef.order(:name)
  end

  def menu
  end

private
    # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end
  def set_category
    @category = Category.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit :name,
                                    :email,
                                    :message
  end
end