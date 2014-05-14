module CartHelper

  def cache_key_cart_carousel mode, category, size = nil, side = nil
    count          = Product.shoppable_additionable(size).count
    max_updated_at = Product.shoppable_additionable(size).maximum(:updated_at).try(:utc).try(:to_s, :number)
    key = "cart/#{mode}/#{category.to_param}/"
    if size
      key += "#{size.to_param}/"
    end
    if side
      key += "#{side}/"
    end
    key += "#{count}-#{max_updated_at}"
  end

  def cache_key_for_toppings_available
    count          = Product.not_additionable_nor_shoppable.count
    max_updated_at = Product.not_additionable_nor_shoppable.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "toppings/available/#{count}-#{max_updated_at}"
  end

  def cache_key_for_product_ingredients cart_item, product
    count          = Product.not_additionable_nor_shoppable.count
    max_updated_at = Product.not_additionable_nor_shoppable.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model_name_from_record_or_class(cart_item).param_key}/#{product.to_param}/ingredients/#{count}-#{max_updated_at}"
  end

  def photo_of item, mode, side
    if mode == CartController::MODE_ONE_FLAVOUR
      item.photo_showcase
    elsif side == 'left'
      item.photo_left
    elsif side == 'right'
      item.photo_right
    end
  end

  def place_holder mode
    if mode == CartController::MODE_ONE_FLAVOUR
      '350x250'
    elsif mode == CartController::MODE_TWO_FLAVOURS
      '175x250'
    end
  end
end