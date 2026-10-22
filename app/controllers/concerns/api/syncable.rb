# frozen_string_literal: true

# A record by id, and every record in pages of 100 by when it changed, with a Link header to the next page. The JSON
# escapes <, > and & (\u003c), as Rails did before 8.1 and callers have always had it (escape: true).
module Api
  module Syncable
    extend ActiveSupport::Concern

    def show
      @record = syncable_repository.find(params.expect(:id))

      respond_to do |format|
        format.json { render json: @record, escape: true }
      end
    end

    def sync
      @records = syncable_repository.order(:updated_at, :id).limit(100)

      if params[:since]
        @records = @records.where('(updated_at, id) > (?, ?)', Time.zone.parse(params[:since]), params[:last_id] || 0)
      end

      if @records.length == 100
        next_url = next_sync_url(since: @records.last.updated_at.as_json, last_id: @records.last.id,
                                 api_key: params[:api_key])

        headers['Link'] = "<#{next_url}>; rel='next'"
      end

      respond_to do |format|
        format.json { render json: @records, escape: true }
      end
    end
  end
end
