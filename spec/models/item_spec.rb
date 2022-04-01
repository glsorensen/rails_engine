require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items)}
    it { should have_many(:invoices).through (:invoice_items)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns an exact match' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "Not Here")

        expect(Item.search("This one")).to eq([item])
      end

      it 'returns a collect of near matches' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "Not here")
        item_3 = create(:item, name: "And this one")

        expect(Item.search("This")).to eq([item_3, item])
      end

      it 'returns near matches in alphabetical and unicode case order' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "this one")
        item_3 = create(:item, name: "This apple")
        item_4 = create(:item, name: "And this one")

        expect(Item.search("This")).to eq([item_4, item_3, item, item_2])
      end

      it 'is case insensitive' do
        item = create(:item, name: "This one")
        item_2 = create(:item, name: "this too")

        expect(Item.search("This")).to eq([item, item_2])
        expect(Item.search("this")).to eq([item, item_2])
      end
    end
  end
end
