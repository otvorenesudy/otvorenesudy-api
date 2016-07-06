class Public::ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  rescue_from ActiveRecord::RecordNotFound do
    render status: 404, json: { success: false, errors: ['Resource does not exist.'] }
  end

  protected

  def serialization_scope
    self
  end
end
