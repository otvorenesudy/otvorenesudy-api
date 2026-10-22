# frozen_string_literal: true

module Api
  module Authorizable
    extend ActiveSupport::Concern

    included do
      before_action :check_api_key
    end

    private

    def check_api_key
      return if Api::Key.exists? value: params[:api_key]

      render status: :unauthorized, json: { success: false, errors: ['Invalid API Key'] }
    end
  end
end
