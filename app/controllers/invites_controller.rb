class InvitesController < ApplicationController
  def create
    attributes = create_params.merge(locale: I18n.locale)

    @invite = Invite.new(attributes)

    if @invite.save
      render :create
    else
      render partial: 'error'
    end
  end

  private

  def create_params
    params.permit(:email)
  end
end
