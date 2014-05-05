module CartHelper

  def cache_key_for_spliter category, side
    count          = Product.count
    max_updated_at = Product.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "splitter/#{category.to_param}/#{side}/#{count}-#{max_updated_at}"
  end
end