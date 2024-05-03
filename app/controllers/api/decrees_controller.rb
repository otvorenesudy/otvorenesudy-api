class Api::DecreesController < Api::ApplicationController
  include Api::Syncable

  def health
    date = (Time.zone.now.monday? ? 3.days : 2.days).ago.beginning_of_day

    if Decree.where('updated_at >= ?', date).count > 0
      render status: 200, json: { status: 'Success' }
    else
      render status: 422, json: { status: 'Failure' }
    end
  end

  protected

  def syncable_repository
    Decree.includes(
      :pages,
      :court,
      :form,
      :legislation_areas,
      :legislation_subareas,
      :natures,
      :legislations,
      :inexact_judgements,
      exact_judgements: [:judge],
      court: [:municipality],
      proceeding: [hearings: %i[proposers defendants opponents]]
    )
  end

  def next_sync_url(*args)
    sync_api_decrees_url(*args)
  end
end
