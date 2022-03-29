require 'rails_helper'

RSpec.describe 'merchant item endpoint' do
  it 'shows the items for a single merchant' do

    gunnar = create(:merchant)
    items = create_list(:item, 5, merchant: gunnar)

    get api_v1_merchant_items_path(gunnar.id)

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(merchant_items[:data].count).to eq(5)

    merchant_items[:data].each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  context 'sad path' do
    it 'returns a 404 if merchant isnt found' do
      bob = create(:merchant)
      items = create_list(:item, 5, merchant: bob)

      get api_v1_merchant_items_path(8923987297)

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(404)
    end
  end
end
