require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:unit_price) }
  end
  describe '.instance methods' do
    context '.find_empty_invoices' do
      it 'gets invoices where this item is the only item on it' do
        merchant = Merchant.create!(name: 'Jim')
        customer1 = Customer.create(first_name: 'Gunnar', last_name: 'Sorensen')
        customer2 = Customer.create(first_name: 'Priska', last_name: 'Sorensen')
        customer3 = Customer.create(first_name: 'Lynn', last_name: 'Sorensen')
        invoice1 = Invoice.create!(customer_id: customer1.id, merchant_id: merchant.id)
        invoice2 = Invoice.create!(customer_id: customer2.id, merchant_id: merchant.id)
        invoice3 = Invoice.create!(customer_id: customer3.id, merchant_id: merchant.id)
        item1 = Item.create!(name: 'Default Item 1',
                             description: 'describes things about the item',
                             unit_price: 10.5,
                             merchant_id: merchant.id)
        item2 = Item.create!(name: 'Default Item 2',
                             description: 'describes things about the item',
                             unit_price: 10.5,
                             merchant_id: merchant.id)
        invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id)
        invoice_item2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice2.id)
        invoice_item3 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice3.id)
        invoice_item4 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice3.id)

        expect(item1.find_empty_invoices).to include(item1.id)
        expect(item1.find_empty_invoices).to include(item2.id)
      end
    end
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns an exact match' do
        item = create(:item, name: 'This one')
        item_2 = create(:item, name: 'Not Here')

        expect(Item.search('This one')).to eq([item])
      end

      it 'returns a collect of near matches' do
        item = create(:item, name: 'This one')
        item_2 = create(:item, name: 'Not here')
        item_3 = create(:item, name: 'And this one')

        expect(Item.search('This')).to eq([item_3, item])
      end

      it 'returns near matches in alphabetical and unicode case order' do
        item = create(:item, name: 'This one')
        item_2 = create(:item, name: 'this one')
        item_3 = create(:item, name: 'This apple')
        item_4 = create(:item, name: 'And this one')

        expect(Item.search('This')).to eq([item_4, item_3, item, item_2])
      end

      it 'is case insensitive' do
        item = create(:item, name: 'This one')
        item_2 = create(:item, name: 'this too')

        expect(Item.search('This')).to eq([item, item_2])
        expect(Item.search('this')).to eq([item, item_2])
      end
    end
  end
end
