class WelcomeController < ApplicationController
  layout 'welcome'

  def index
    @invite = Invite.new
    @welcome_page = WelcomePagePresenter.new(cache: Rails.cache)
  end
end
