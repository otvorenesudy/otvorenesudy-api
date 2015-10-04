class Api::ApplicationController < ApplicationController
  include Api::Authorizable

  protected

  def serialization_scope
    self
  end
end
