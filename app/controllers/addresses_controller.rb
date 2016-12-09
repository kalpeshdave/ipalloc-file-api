class AddressesController < ApplicationController
  def assign
    address = Address.new(address_params)
    if address.valid?
      address.create
      render json: {device: address.device, ip: address.ip_address}, status: :created, meta: default_meta
    else
      render_post_error(address, :unprocessable_entity)
    end
  end

  private

  def address_params
    params.permit(:ip_address, :device)
  end

  def render_post_error(address, status)
    render json: address, status: status, adapter: :json_api,  meta: default_meta
  end
end
