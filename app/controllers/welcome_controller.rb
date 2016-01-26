class WelcomeController < ApplicationController
  layout 'welcome'

  def index
    @invite = Invite.new
  end
end
