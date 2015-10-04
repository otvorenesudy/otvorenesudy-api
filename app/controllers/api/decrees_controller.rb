class Api::DecreesController < Api::ApplicationController
  include Api::Syncable

  protected

  def syncable_repository
    Decree
  end

  def next_sync_url(*args)
    sync_api_decrees_url(*args)
  end
end
