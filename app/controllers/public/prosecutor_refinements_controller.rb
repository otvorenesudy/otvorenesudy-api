# frozen_string_literal: true

module Public
  class ProsecutorRefinementsController < Public::ApplicationController
    before_action :verify_number_of_allowed_refinements
    before_action :restrict_allowed_origin

    def create
      refinements = build_refinements
      errors = refinement_errors(refinements)

      return render status: :unprocessable_content, json: { success: false, errors: } if errors.any?

      Public::ProsecutorRefinement.transaction { refinements.each(&:save!) }

      render 200
    end

    private

    def build_refinements
      attributes = create_params.except(:prosecutors).merge(ip_address: request.remote_ip)

      Array(create_params[:prosecutors]).map { |prosecutor| Public::ProsecutorRefinement.new(attributes.merge(prosecutor:)) }
    end

    # Each refinement is saved, or none: what is wrong with any of them, or with the request.
    def refinement_errors(refinements)
      return ["Prosecutors can't be blank"] if refinements.empty?

      refinements.reject(&:valid?).flat_map { it.errors.full_messages }.uniq
    end

    def create_params
      params.permit(:name, :email, :office, prosecutors: [])
    end

    def verify_number_of_allowed_refinements
      ip = request.remote_ip
      refinements = Public::ProsecutorRefinement.where('created_at > ? AND ip_address = ?', 30.seconds.ago, ip)

      head :too_many_requests if refinements.size >= 30
    end

    def restrict_allowed_origin
      headers['Access-Control-Allow-Origin'] = Rails.configuration.x.prosecutor_refinements_origin
    end
  end
end
