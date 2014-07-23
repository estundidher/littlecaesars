module  ProductTypeHelper

  def visit_product_type(user)
    login user
    click_link 'Product Types'
  end

end