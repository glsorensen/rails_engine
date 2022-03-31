require 'rails_helper'

RSpec.describe 'Find All Items endpoint' do
  context 'happy path' do
    context '?name=' do
      it 'returns items that match a given name' do
        item = create(:item, name: 'This one')
        item_2 = create(:item, name: 'Not Here')

        get '/api/v1/items/find_all?name=This one'

        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(results).to have_key(:data)
        expect(results[:data]).to be_a(Array)
        expect(results[:data].count).to eq(1)

        results[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq('item')

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          attributes = item[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)

          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end
      end
      it 'returns all items that resemble name' do
        item = create(:item, name: 'This one')
        item_2 = create(:item, name: 'this One')
        item_3 = create(:item, name: 'This too')

        get '/api/v1/items/find_all?name=This'

        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(results).to have_key(:data)
        expect(results[:data]).to be_a(Array)
        expect(results[:data].count).to eq(3)

        results[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq('item')

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          attributes = item[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)

          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end
      end
      it 'returns an empty array if no named matches found' do
        get '/api/v1/items/find_all?name=This'

        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(results).to have_key(:status)
        expect(results[:status]).to eq('SUCCESS')

        expect(results).to have_key(:message)
        expect(results[:message]).to eq('No item matches that name!')

        expect(results).to have_key(:data)
        expect(results[:data]).to eq([])
      end
    end
  end
  context 'sad path' do
    it 'does not allow for a search with empty parameters' do
      get '/api/v1/items/find_all'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)

      expect(results).to have_key(:status)
      expect(results[:status]).to eq('BAD REQUEST')

      expect(results).to have_key(:message)
      expect(results[:message]).to eq('search parameters cannot be empty')

      expect(results).to have_key(:data)
      expect(results[:data]).to eq({})
    end

    it 'errors when name search is incomplete' do
      get '/api/v1/items/find_all?name='

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)

      expect(results).to have_key(:status)
      expect(results[:status]).to eq('BAD REQUEST')

      expect(results).to have_key(:message)
      expect(results[:message]).to eq('search parameters cannot be empty')

      expect(results).to have_key(:data)
      expect(results[:data]).to eq({})

      get '/api/v1/items/find_all?name'

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
