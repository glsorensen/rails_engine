class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def destroy
    render json: Item.delete(params[:id]), status: :no_content
  end

  def update
    item = Item.update(@item.id, item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: { status: 'ERROR', message: 'Unable to save item. Please try again', data: item.errors },
             status: :bad_request
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
