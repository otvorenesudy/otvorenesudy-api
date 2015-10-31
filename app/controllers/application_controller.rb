class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'home', only: :home

  def home
  end
end
