class WelcomeController < ApplicationController
  layout 'welcome', only: :home

  def home
  end
end
