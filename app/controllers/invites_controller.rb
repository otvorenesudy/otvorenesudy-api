class InvitesController < ApplicationController
  def create
    attributes = create_params.merge(locale: I18n.locale)

    @invite = Invite.new(attributes)
  end

  private

  def create_params
    params.permit(:email)
  end
end
