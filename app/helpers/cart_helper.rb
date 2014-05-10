module CartHelper

  def cache_key_for_spliter category, size = nil, side
    count          = Product.count
    max_updated_at = Product.maximum(:updated_at).try(:utc).try(:to_s, :number)
    key = "splitter/#{category.to_param}/"
    if size
      key += "#{size.to_param}/"
    end
    key += "#{side}/#{count}-#{max_updated_at}"
  end

  def cache_key_for_slider category, size = nil
    count          = Product.count
    max_updated_at = Product.maximum(:updated_at).try(:utc).try(:to_s, :number)
    key = "slider/#{category.to_param}/"
    if size
      key += "#{size.to_param}/"
    end
    key += "#{count}-#{max_updated_at}"
  end

end