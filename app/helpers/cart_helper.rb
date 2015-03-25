module CartHelper

  def cache_key_cart_carousel mode, category, size = nil, side = nil
    count          = Product.shoppable(nil, nil, size, nil).count
    max_updated_at = Product.shoppable(nil, nil, size, nil).maximum(:updated_at).try(:utc).try(:to_s, :number)
    key = "cart/carousel/#{mode}/#{category.to_param}/"
    if size
      key += "#{size.to_param}/"
    end
    if side
      key += "#{side}/"
    end
    key += "#{count}-#{max_updated_at}"
  end

  def cache_key_cart_carousel_item mode, size = nil, side = nil
    key = "cart/#{mode}/"
    if size
      key += "#{size.to_param}/"
    end
    if side
      key += "#{side}"
    end
    return key
  end

  #"toppings/12+23+33/available/#{count}-#{max_updated_at}"
  def cache_key_for_toppings_available categories, products
    key = "toppings/"
    key = categories.map {|c| c.id }.join('+')

    count          = products.size
    max_updated_at = products.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{key}/available/#{count}-#{max_updated_at}"
  end

  def cache_key_for_product_ingredients cart_item, product, side
    count          = Product.not_additionable_nor_shoppable.count
    max_updated_at = Product.not_additionable_nor_shoppable.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model_name_from_record_or_class(cart_item).param_key}/#{product.to_param}/#{side}/ingredients/#{count}-#{max_updated_at}"
  end

  def photo_of item, mode, side
    if mode == Cart::MODE[:one_flavour]
      item.photo_showcase
    elsif side == 'left'
      item.photo_left
    elsif side == 'right'
      item.photo_right
    end
  end

  def place_holder mode
    if mode == Cart::MODE[:one_flavour]
      '350x250'
    elsif mode == Cart::MODE[:two_flavours]
      '175x250'
    end
  end

  def add_to_cart_button product
    if customer_signed_in?
      if product.type.additionable?
        link_to t('links.add_to', model_name:Cart.model_name.human),
            cart_path(product), class: "btn btn-danger btn-sm"
      else
        link_to t('links.add_to', model_name:Cart.model_name.human),
            cart_new_item_path(product), remote: true, class: "btn btn-danger btn-sm"
      end
    else
      link_to t('links.add_to', model_name:Cart.model_name.human),
          new_customer_registration_path, class: "btn btn-danger btn-sm"
    end
  end
end