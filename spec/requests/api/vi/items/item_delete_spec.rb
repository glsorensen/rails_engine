require 'rails_helper'

RSpec.describe 'the item delete endpoint' do
  # it 'allows for an item to be deleted' do
  #   item = create(:item)
  #
  #   expect(Item.count).to eq(1)
  #
  #   delete api_v1_item_path(item.id)
  #
  #   expect(response).to have_http_status(204)
  #   expect(Item.count).to eq(0)
  #   expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  # end
  it 'deletes the invoice if only one item was present' do
    @nike = Merchant.create!(name: 'Nike')
      @item1 = create(:item)
      @item2 = create(:item)
      @item3 = create(:item)
      @customer_1 = Customer.create(first_name: 'One', last_name: 'Customer')
      @customer_2 = Customer.create(first_name: 'Two', last_name: 'Customer')
      @customer_3 = Customer.create(first_name: 'Three', last_name: 'Customer')
      @invoice_1 = Invoice.create(customer_id: @customer_1.id, merchant_id: @nike.id, status: '1')
      @invoice_2 = Invoice.create(customer_id: @customer_1.id, merchant_id: @nike.id, status: '1')
      @invoice_item_1 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item1.id)
      @invoice_item_2 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item2.id)
      @invoice_item_3 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item3.id)
      @invoice_item_4 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_2.id, item_id: @item3.id)

      expect(Item.count).to eq(3)
      expect(Customer.count).to eq(3)
      expect(Invoice.count).to eq(2)
      expect(InvoiceItem.count).to eq(4)
      expect(@invoice_1.invoice_items.count).to eq(3)
      expect(@invoice_2.invoice_items.count).to eq(1)

      delete api_v1_item_path(@item3.id)

      expect(response).to have_http_status(204)
      expect(Item.count).to eq(2)
      expect { Item.find(@item3.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(@invoice_1.invoice_items.count).to eq(2)
      expect(@invoice_2.invoice_items.count).to eq(0)
      expect(Invoice.count).to eq(1)
    end
  end
