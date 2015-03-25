require 'rails_helper'

RSpec.describe OrderController, type: :controller do

  describe 'GET new' do

    it 'assigns a new Order with @order' do
      order = create(:order)
      get :new
      expect(assigns(:order)).to eq([order])
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template('new')
    end
  end
end