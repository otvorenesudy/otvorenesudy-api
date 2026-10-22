# frozen_string_literal: true

module Public
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    include ActionController::ImplicitRender
  end
end
