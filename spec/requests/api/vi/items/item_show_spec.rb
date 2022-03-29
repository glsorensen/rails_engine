require 'rails_helper'

RSpec.describe 'items show endpoint' do

  it 'returns one item'do

      item = create(:item)

    get api_v1_item_path(item.id)

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(item[:data].count).to eq(3)

    item_data = item[:data]
    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(String)

    expect(item_data).to have_key(:type)
    expect(item_data[:type]).to be_a(String)

    expect(item_data).to have_key(:attributes)
    expect(item_data[:attributes]).to be_a(Hash)

    expect(item_data[:attributes]).to have_key(:name)
    expect(item_data[:attributes][:name]).to be_a(String)

    expect(item_data[:attributes]).to have_key(:description)
    expect(item_data[:attributes][:description]).to be_a(String)

    expect(item_data[:attributes]).to have_key(:unit_price)
    expect(item_data[:attributes][:unit_price]).to be_a(Float)

    expect(item_data[:attributes]).to have_key(:merchant_id)
    expect(item_data[:attributes][:merchant_id]).to be_a(Integer)
  end

  context 'sad path' do
    it 'returns a 404 if item is not found by integer' do

      item = create(:item)

      expect{get api_v1_item_path(99999)}.to raise_error(ActiveRecord::RecordNotFound)

    end

    it 'returns a 404 if item is not found by string' do

      item = create(:item)

      expect{get api_v1_item_path("test")}.to raise_error(ActiveRecord::RecordNotFound)

    end
  end
end
