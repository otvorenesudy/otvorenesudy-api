class Api::DecreesController < Api::ApplicationController
  include Api::Syncable

  def health
    if Decree.where('updated_at >= ?', 1.day.ago).count > 0
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
      :legislation_area,
      :legislation_subarea,
      :natures,
      :legislations,
      :inexact_judgements,

      exact_judgements: [:judge],
      court: [:municipality],
      proceeding: [
        hearings: [:proposers, :defendants, :opponents]
      ]
    )
  end

  def next_sync_url(*args)
    sync_api_decrees_url(*args)
  end
end
