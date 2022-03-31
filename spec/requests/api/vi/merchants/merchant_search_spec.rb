require 'rails_helper'

RSpec.describe 'Merchant Search endpoint' do
  context 'happy path' do
    it 'returns one merchant' do
      merchant_1 = create(:merchant, name: 'Zena')
      merchant_2 = create(:merchant, name: 'Abba')

      get '/api/v1/merchants/find?name=Zena'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(results).to have_key(:data)
      expect(results[:data].count).to eq(3)

      results_data = results[:data]

      expect(results_data).to have_key(:id)
      expect(results_data[:id]).to be_a(String)

      expect(results_data).to have_key(:type)
      expect(results_data[:type]).to eq('merchant')

      expect(results_data).to have_key(:attributes)
      expect(results_data[:attributes]).to be_a(Hash)

      merchant = results_data[:attributes]

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to eq('Zena')
    end
  end
  context 'sad path/ edge case' do
  end
end
