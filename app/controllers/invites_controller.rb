# frozen_string_literal: true

# The welcome page's invite form, which Turbo submits: the answer replaces the form with a thank-you, or with the form
# marking the address it can't take.
class InvitesController < ApplicationController
  def create
    invite = Invite.new(invite_params)

    if invite.save
      render turbo_stream: turbo_stream.replace('invite-form', partial: 'invites/created')
    else
      render turbo_stream: turbo_stream.replace('invite-form', partial: 'welcome/invite_form', locals: { invite: }),
             status: :unprocessable_content
    end
  end

  private

  def invite_params
    params.expect(invite: %i[email locale])
  end
end
