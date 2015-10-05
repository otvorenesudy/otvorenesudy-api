class Api::ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include Api::Authorizable

  protected

  def serialization_scope
    self
  end
end
