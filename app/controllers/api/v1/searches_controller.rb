class Api::V1::SearchesController < ApplicationController

  def find_merchant
    if params[:name] == nil
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name] == ""
      render json: { status: 'BAD REQUEST', message: 'search parameters cannot be empty', data: {} }, status: :bad_request
    elsif params[:name].class == String && params[:name].length > 0
      @merchant = Merchant.search(params[:name]).first
      if @merchant == nil
        render json: { status: 'SUCCESS', message: 'No merchant matches that name!', data: {} }, status: :ok
      else
        render json: MerchantSerializer.new(@merchant)
      end
    end
  end
end
