class ApplicationController < ActionController::API
  def render_error(resource, status)
    render json: {error: "NotFound", ip_address: params[:ip_address]}, status: status, adapter: :json_api, meta: default_meta
  end

  def default_meta
    {
      licence: 'CC-0',
      authors: ['Saša']
    }
  end
end
