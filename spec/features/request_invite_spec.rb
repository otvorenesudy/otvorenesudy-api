require 'rails_helper'

RSpec.describe 'Request Invite' do
  it 'requests invite for email from main headline', js: true do
    visit root_path

    within '.jumbotron' do
      fill_in 'email', with: 'johny@example.com'

      click_button 'Request an invite'
    end

    expect(page).to have_content('Thank you for your interest. We\'ll be in touch with you very soon.')

    invite = Invite.last

    expect(invite.email).to eql('johny@example.com')
    expect(invite.locale).to eql(:en)
  end

  it 'requests invite for email from bottom', js: true do
    visit root_path

    within '#invite' do
      fill_in 'email', with: 'johny@example.com'

      click_button 'Request an invite'
    end

    expect(page).to have_content('Thank you for your interest. We\'ll be in touch with you very soon.')

    invite = Invite.last

    expect(invite.email).to eql('johny@example.com')
    expect(invite.locale).to eql(:en)
  end

  it 'correctly saves locale after changing it', js: true do
    visit root_path

    click_link 'SK'

    within '.jumbotron' do
      fill_in 'email', with: 'johny@example.com'

      click_button 'Požiadať o prístup'
    end

    expect(page).to have_content('Ďakujeme Vám za spoluprácu. Onedlho Vás budeme kontaktovať.')

    invite = Invite.last

    expect(invite.email).to eql('johny@example.com')
    expect(invite.locale).to eql(:sk)
  end

  context 'with error on invite' do
    it 'shows error in form', js: true do
      visit root_path

      within '.jumbotron' do
        click_button 'Request an invite'
      end

      expect(page).not_to have_content('Thank you for your interest! We\'ll be in touch with you very soon.')
      expect(page).to have_css('input.error[name="email"]')

      expect(Invite.count).to be_zero
    end
  end

  it 'allows only unique emails per locale', js: true do
    create :invite, email: 'johny@example.com', locale: :en

    visit root_path

    within '.jumbotron' do
      fill_in 'email', with: 'johny@example.com'

      click_button 'Request an invite'
    end

    expect(page).not_to have_content('Thank you for your interest! We\'ll be in touch with you very soon.')
    expect(page).to have_css('input.error[name="email"]')

    expect(Invite.count).to eq(1)

    click_link 'SK'

    within '.jumbotron' do
      fill_in 'email', with: 'johny@example.com'

      click_button 'Požiadať o prístup'
    end

    expect(page).to have_content('Ďakujeme Vám za spoluprácu. Onedlho Vás budeme kontaktovať.')

    invite = Invite.last

    expect(invite.email).to eql('johny@example.com')
    expect(invite.locale).to eql(:sk)
  end
end