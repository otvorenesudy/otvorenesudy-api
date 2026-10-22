# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::ImplicitRender
    include Api::Authorizable

    rescue_from ActiveRecord::RecordNotFound do
      render status: :not_found, json: { success: false, errors: ['Resource does not exist.'] }
    end

    protected

    def serialization_scope
      self
    end
  end
end
