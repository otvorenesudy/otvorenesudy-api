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
      since = parse_since
      return render_invalid_since if params[:since] && !since

      @records = syncable_repository.order(:updated_at, :id).limit(100)
      @records = @records.where('(updated_at, id) > (?, ?)', since, params[:last_id] || 0) if since

      if @records.length == 100
        next_url = next_sync_url(since: @records.last.updated_at.as_json, last_id: @records.last.id,
                                 api_key: params[:api_key])

        headers['Link'] = "<#{next_url}>; rel='next'"
      end

      respond_to do |format|
        format.json { render json: @records, escape: true }
      end
    end

    private

    # Time.zone.parse returns nil for text without a date, and raises for a date that can't exist.
    def parse_since
      Time.zone.parse(params[:since]) if params[:since]
    rescue ArgumentError
      nil
    end

    # A caller that sent a time we can't read gets an error, not an empty page it would take for the end of the sync.
    def render_invalid_since
      render status: :bad_request, json: { success: false, errors: ["Invalid since: #{params[:since]}"] }, escape: true
    end
  end
end
