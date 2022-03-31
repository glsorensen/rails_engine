class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true, format: { with: /[a-zA-Z]/ }
  validates :unit_price, numericality: true

  def self.search(params)
    where('name ILIKE ?', "%#{params}%").order(:name)
  end
end
