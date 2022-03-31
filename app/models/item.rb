class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy

  validates :name, presence: true, format: { with: /[a-zA-Z]/ }
  validates :unit_price, numericality: true

  def self.search(params)
    where('name ILIKE ?', "%#{params}%").order(:name)
  end
end
