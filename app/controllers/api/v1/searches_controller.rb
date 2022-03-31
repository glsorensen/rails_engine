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
    end
    render json: MerchantSerializer.new(@merchant)
  end
end
