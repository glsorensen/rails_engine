require 'rails_helper'

RSpec.describe 'items show endpoint' do
  it 'can create a new item' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_params = {
      name: 'Candy',
      description: 'Tastes Good',
      unit_price: 12.32,
      merchant_id: merchant_1.id
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

    new_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(201)

    expect(new_item).to have_key(:data)
    expect(new_item[:data]).to be_a(Hash)

    new_item_data = new_item[:data]

    expect(new_item_data).to have_key(:id)
    expect(new_item_data[:id]).to be_a(String)

    expect(new_item_data).to have_key(:type)
    expect(new_item_data[:type]).to eq('item')

    expect(new_item_data).to have_key(:attributes)
    expect(new_item_data[:attributes]).to be_a(Hash)

    new_item_attributes = new_item_data[:attributes]

    expect(new_item_attributes).to have_key(:name)
    expect(new_item_attributes[:name]).to be_a(String)

    expect(new_item_attributes).to have_key(:description)
    expect(new_item_attributes[:description]).to be_a(String)

    expect(new_item_attributes).to have_key(:unit_price)
    expect(new_item_attributes[:unit_price]).to be_a(Float)

    expect(new_item_attributes).to have_key(:merchant_id)
    expect(new_item_attributes[:merchant_id]).to eq(merchant_1.id)
  end
end
