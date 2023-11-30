class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Basic parameter verification
    binding.pry
    unless params[:name].present? && params[:data].present?
      render json: { error: 'Name and data are required' }, status: :unprocessable_entity
      return
    end

    # Save the data to the model
    my_model = MyModel.new(name: params[:name], data: params[:data])
    if my_model.save
      notify_third_parties(my_model)
      render json: my_model, status: :created
    else
      render json: { error: my_model.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    my_model = MyModel.find(params[:id])    
    if my_model.update_attributes(params[:name]) 
      notify_third_parties(my_model)
      render json: my_model, status: :updated
    else  
      render json: { error: my_model.errors.full_messages }, status: :unprocessable_entity
    end 
  end

  private

  def notify_third_parties(my_model)
    # Implement logic to notify third-party APIs
    third_party_endpoints.each do |endpoint|
      notify_endpoint(endpoint, my_model)
    end
  end

  def notify_endpoint(endpoint, my_model)
    # Implement logic to send a POST request to the third-party endpoint
    response = HTTParty.post(
      endpoint,
      body: { name: my_model.name, data: my_model.data }.to_json,
      headers: { 'Content-Type' => 'application/json', 'Authorization' => 'Bearer YOUR_API_KEY' }
    )

    if response.success?
      Rails.logger.info("Successfully notified #{endpoint}")
    else
      Rails.logger.error("Failed to notify #{endpoint}: #{response.code} - #{response.body}")
    end
  end

  def third_party_endpoints
    # For simplicity, let's assume you have an array of endpoints in your configuration
    ['https://example.com/webhook', 'https://another-api.com/webhook']
  end
end
