module MenuHelper

  def is_tab_active category, param_active, index
    if param_active.nil?
      index == 0
    else
      category.to_param == param_active
    end
  end

  def menu_popup_cache_key
    count          = Product.shoppable(nil, nil, nil, nil).count
    max_updated_at = Product.shoppable(nil, nil, nil, nil).maximum(:updated_at).try(:utc).try(:to_s, :number)
    "menu_popup/ramdon/#{rand(1..10)}/#{count}-#{max_updated_at}"
  end

end