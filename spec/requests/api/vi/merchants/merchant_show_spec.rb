require 'rails_helper'

RSpec.describe 'merchant endpoint' do
  context 'happy path' do
    it 'returns one merchant' do
      gunnar = create(:merchant)

      get api_v1_merchant_path(gunnar.id)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)
      expect(merchant[:data].count).to eq(3)

      merchant_data = merchant[:data]
      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_a(String)

      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to be_a(String)

      expect(merchant_data).to have_key(:attributes)
      expect(merchant_data[:attributes]).to be_a(Hash)

      expect(merchant_data[:attributes]).to have_key(:name)
      expect(merchant_data[:attributes][:name]).to be_a(String)
    end
  end

  context 'sad path' do
    it 'bad integer id returns 404' do
      merchant = create(:merchant)
      item = create(:item)

      expect { get api_v1_merchant_path(1) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'string as integer returns 404' do
      merchant = create(:merchant)
      item = create(:item)

      expect { get api_v1_merchant_path('test') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
