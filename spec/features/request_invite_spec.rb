require 'rails_helper'

RSpec.feature 'Request Invite', type: :feature do
  scenario 'with for email from bottom', js: true do
    visit root_path

    within '#invite' do
      fill_in 'invite_email', with: 'johny@example.com'

      click_button 'Request an Invite'
    end

    expect(page).to have_content('Thank you for your interest. We\'ll be in touch with you very soon.')

    invite = Invite.last

    expect(invite.email).to eql('johny@example.com')
    expect(invite.locale).to eql('en')
  end

  context 'after changing locale' do
    scenario 'it correcly saves locale', js: true do
      visit root_path

      click_link 'SK'

      within '#invite' do
        fill_in 'invite_email', with: 'johny@example.com'

        click_button 'Požiadať o prístup'
      end

      expect(page).to have_content('Ďakujeme Vám za spoluprácu. Onedlho Vás budeme kontaktovať.')

      invite = Invite.last

      expect(invite.email).to eql('johny@example.com')
      expect(invite.locale).to eql('sk')
    end
  end

  scenario 'shows error in form', js: true do
    visit root_path

    within '#invite' do
      click_button 'Request an Invite'
    end

    expect(page).not_to have_content('Thank you for your interest! We\'ll be in touch with you very soon.')
    expect(page).to have_css('input#invite_email.error')

    expect(Invite.count).to be_zero
  end

  scenario 'allows only unique emails per locale', js: true do
    create :invite, email: 'johny@example.com', locale: 'en'

    visit root_path

    within '#invite' do
      fill_in 'invite_email', with: 'johny@example.com'

      click_button 'Request an Invite'
    end

    expect(page).not_to have_content('Thank you for your interest! We\'ll be in touch with you very soon.')
    expect(page).to have_css('input#invite_email.error')

    expect(Invite.count).to eq(1)

    click_link 'SK'

    within '#invite' do
      fill_in 'invite_email', with: 'johny@example.com'

      click_button 'Požiadať o prístup'
    end

    expect(page).to have_content('Ďakujeme Vám za spoluprácu. Onedlho Vás budeme kontaktovať.')

    invite = Invite.last

    expect(invite.email).to eql('johny@example.com')
    expect(invite.locale).to eql('sk')
  end
end
