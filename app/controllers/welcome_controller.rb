class WelcomeController < ApplicationController
  layout 'home', only: :home

  def home
  end
end
