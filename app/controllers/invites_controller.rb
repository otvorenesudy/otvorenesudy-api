class InvitesController < ApplicationController
  def create
    @invite = Invite.new(create_params)

    if @invite.save
      render :create
    else
      render status: 422, partial: 'error'
    end
  end

  private

  def create_params
    params.require(:invite).permit(:email, :locale)
  end
end
