class Public::ProsecutorRefinementsController < Public::ApplicationController
  before_action :verify_number_of_allowed_refinements
  before_action :restrict_allowed_origin

  def create
    attributes = create_params.except(:prosecutors)

    refinements = create_params[:prosecutors].map do |prosecutor|
      Public::ProsecutorRefinement.create(attributes.merge(prosecutor: prosecutor, ip_address: request.remote_ip))
    end

    invalid_refinement = refinements.find(&:invalid?)
    render 422, errors: invalid_refinement.errors.full_messages if invalid_refinement

    render 200
  end

  private

  def create_params
    params.permit(:name, :email, :office, prosecutors: [])
  end

  def verify_number_of_allowed_refinements
    ip = request.remote_ip
    refinements = Public::ProsecutorRefinement.where('created_at > ? AND ip_address = ?', 30.seconds.ago, ip)

    head 429 if refinements.size >= 30
  end

  def restrict_allowed_origin
    headers['Access-Control-Allow-Origin'] = Rails.env.production? ? 'https://prokuratori.otvorenesudy.sk' : '*'
  end
end
