module MenuHelper

  def is_tab_active category, param_active, index
    if param_active.nil?
      index == 0
    else
      category.to_param == param_active
    end
  end

end