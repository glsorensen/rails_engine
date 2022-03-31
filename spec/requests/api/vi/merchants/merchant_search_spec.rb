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
    it 'returns successful but w/o results if nothing matches' do
      get '/api/v1/merchants/find?name=nothing'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(results).to have_key(:status)
      expect(results[:status]).to eq('SUCCESS')

      expect(results).to have_key(:message)
      expect(results[:message]).to eq('No merchant matches that name!')

      expect(results).to have_key(:data)
      expect(results[:data]).to eq({})
    end
    it 'errors if a parameter is empty' do
      get '/api/v1/merchants/find'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)

      expect(results).to have_key(:status)
      expect(results[:status]).to eq('BAD REQUEST')

      expect(results).to have_key(:message)
      expect(results[:message]).to eq('search parameters cannot be empty')

      expect(results).to have_key(:data)
      expect(results[:data]).to eq({})
    end

    it 'errors if a parameter is incomplete' do
      get '/api/v1/merchants/find?name='

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)

      expect(results).to have_key(:status)
      expect(results[:status]).to eq('BAD REQUEST')

      expect(results).to have_key(:message)
      expect(results[:message]).to eq('search parameters cannot be empty')

      expect(results).to have_key(:data)
      expect(results[:data]).to eq({})
    end
  end
end
