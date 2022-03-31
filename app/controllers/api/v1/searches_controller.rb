class Api::V1::SearchesController < ApplicationController
  def find_merchant
    if params[:name].nil?
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} },
             status: :bad_request
    elsif params[:name] == ''
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} },
             status: :bad_request
    elsif params[:name].instance_of?(String) && params[:name].length > 0
      @merchant = Merchant.search(params[:name]).first
      if @merchant.nil?
        render json: { status: 'SUCCESS', message: 'No merchant matches that name!', data: {} }, status: :ok
      else
        render json: MerchantSerializer.new(@merchant)
      end
    end
  end

  def find_items_by_name
    if params[:name].nil?
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} },
             status: :bad_request
    elsif params[:name] == ''
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} },
             status: :bad_request
    elsif params[:name].instance_of?(String) && params[:name].length > 0
      @items = Item.search(params[:name])
      if @items == []
        render json: { status: 'SUCCESS', message: 'No item matches that name!', data: [] }, status: :ok
      else
        render json: ItemSerializer.new(@items)
      end
    end
  end
end
