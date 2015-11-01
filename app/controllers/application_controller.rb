class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'home', only: :home

  before_action :set_locale

  def home
  end

  def request_invite
  end

  private

  def set_locale
    I18n.locale = params[:l] || I18n.default_locale
  end
end
