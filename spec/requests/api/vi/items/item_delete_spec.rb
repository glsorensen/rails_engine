require 'rails_helper'

RSpec.describe 'the item delete endpoint' do
  it 'allows for an item to be deleted' do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete api_v1_item_path(item.id)

    expect(response).to have_http_status(204)
    expect(Item.count).to eq(0)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
  it 'deletes the invoice if only one item was present' do
    @nike = Merchant.create!(name: "Nike")
    @item = create(:item)
    @customer_1 = Customer.create!(first_name: 'One',last_name:'Customer' )
    @invoice_1 = Invoice.create(customer_id: @customer_1.id, merchant_id: @nike.id, status: "1")
    @invoice_item_1 = InvoiceItem.create(quantity: 1, unit_price: 100.0, invoice_id: @invoice_1.id, item_id: @item.id)

    expect(Item.count).to eq(1)
    expect(Merchant.count).to eq(2)
    expect(Customer.count).to eq(1)
    expect(Invoice.count).to eq(1)
    expect(InvoiceItem.count).to eq(1)


    delete api_v1_item_path(@item.id)
    
    expect(response).to have_http_status(204)
    expect(Item.count).to eq(0)
    expect { Item.find(@item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
