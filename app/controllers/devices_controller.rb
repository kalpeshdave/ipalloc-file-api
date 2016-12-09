class DevicesController < ApplicationController
  before_action :set_address, only: [:show]

  def show
    render json: {device: @address.device, ip_address: @address.ip_address}, meta: default_meta
  end

  private
  def set_address
    begin
      @address = Address.find_by_ip_address(params[:ip_address]).first
      set_404 unless @address
    rescue DocumentNotFound
      set_404
    end
  end

  def set_404
    address = Address.new
    address.errors.add(:ip_address, "Wrong IP Address provided")
    render_error(address, 404) and return
  end
end
