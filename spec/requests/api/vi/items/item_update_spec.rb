require 'rails_helper'

RSpec.describe 'the item endpoint' do
  it 'allows for an item to be updated' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    previous_name = Item.last.name

    item_params = { name: "Charlotte's Web" }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch api_v1_item_path(item.id), headers: headers, params: JSON.generate({ item: item_params })

    item = Item.find_by(id: item.id)

    expect(response).to have_http_status(200)
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Charlotte's Web")
  end

  context 'sad path' do
    it 'throws a 400 error if update is invalid' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      previous_data = Item.last.name

      item_params = { name: 123 }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)

      result = Item.find_by(id: item.id)

      expect(response).to have_http_status(400)
      expect(result.name).to eq(previous_data)
    end
  end
end
