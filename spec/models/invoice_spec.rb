require 'rails_helper'

RSpec.describe Invoice do
  it { should belong_to(:customer) }
  it { should belong_to(:merchant) }
end 
