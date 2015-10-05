class Api::DecreesController < Api::ApplicationController
  include Api::Syncable

  protected

  def syncable_repository
    Decree.includes(
      :pages,
      :court,
      :form,
      :legislation_area,
      :legislation_subarea,
      :natures,
      :judges,
      :legislations,
      :proceeding,

      court: [:municipality],
      proceeding: [:hearings]
    )
  end

  def next_sync_url(*args)
    sync_api_decrees_url(*args)
  end
end
