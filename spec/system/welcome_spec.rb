# frozen_string_literal: true

require 'rails_helper'

# api.otvorenesudy.sk: what the API offers, how much data Open Courts holds, and a form to ask for access.
RSpec.describe 'Welcome page' do
  it 'shows how many decrees, judges and hearings Open Courts holds' do
    create_list(:decree, 2)
    create_list(:judge, 3)
    create(:hearing)

    visit root_path

    expect(page).to have_css('.statistic', text: '2 judicial decrees')
    expect(page).to have_css('.statistic', text: '3 judges')
    expect(page).to have_css('.statistic', text: '1 judicial hearings')
  end

  it 'switches between English and Slovak' do
    visit root_path
    click_on 'SK'

    expect(page).to have_css('h1', text: 'Dáta o slovenskom súdnictve')
    expect(page).to have_css('html[lang="sk"]', visible: :all)

    click_on 'EN'

    expect(page).to have_css('h1', text: 'Data on Slovak Judiciary')
  end

  it 'opens the documentation, the source code and the partners in a new tab' do
    visit root_path

    %w[
      http://docs.otvorenesudy.apiary.io https://github.com/otvorenesudy/otvorenesudy-api http://transparency.sk
      https://indexpodnikatela.sk
    ].each { |href| expect(page).to have_css("a[href='#{href}'][target='_blank']") }
    expect(page).to have_link('api@otvorenesudy.sk', href: 'mailto:api@otvorenesudy.sk')
  end

  it 'scrolls from the headline down to what the API offers', :js do
    visit root_path
    click_on 'Find out more'

    expect(scrolled_to?(find('.content')) { |top| (top - 32).abs <= 1 }).to be(true)
  end

  it 'scrolls from the headline down to the invite form', :js do
    visit root_path

    expect(bounds(find('.invite-form'))['top']).to be > viewport_height

    click_link 'Request an Invite'

    expect(scrolled_to?(find('.invite-form')) { |top| top.between?(0, viewport_height - 100) }).to be(true)
  end

  describe 'the invite form', :js do
    it 'takes an e-mail address and thanks for it' do
      visit root_path

      within('#invite') do
        fill_in 'invite_email', with: 'johny@example.com'
        click_button 'Request an Invite'
      end

      expect(page).to have_content("Thank you for your interest. We'll be in touch with you very soon.")
      expect(Invite.pluck(:email, :locale)).to eq([%w[johny@example.com en]])
    end

    it 'takes an e-mail address in Slovak after switching the language' do
      visit root_path
      click_on 'SK'

      expect(page).to have_css('h1', text: 'Dáta o slovenskom súdnictve')

      within('#invite') do
        fill_in 'invite_email', with: 'johny@example.com'
        click_button 'Požiadať o prístup'
      end

      expect(page).to have_content('Ďakujeme Vám za spoluprácu. Onedlho Vás budeme kontaktovať.')
      expect(Invite.pluck(:email, :locale)).to eq([%w[johny@example.com sk]])
    end

    it 'marks the field without an address' do
      visit root_path

      within('#invite') { click_button 'Request an Invite' }

      expect(page).to have_css('input#invite_email.error')
      expect(page).to have_no_content("Thank you for your interest. We'll be in touch with you very soon.")
      expect(Invite.count).to eq(0)
    end

    it 'marks an address already invited in that language, and takes it in the other' do
      create(:invite, email: 'johny@example.com', locale: 'en')
      visit root_path

      within('#invite') do
        fill_in 'invite_email', with: 'johny@example.com'
        click_button 'Request an Invite'
      end

      expect(page).to have_css('input#invite_email.error')

      click_on 'SK'

      expect(page).to have_css('h1', text: 'Dáta o slovenskom súdnictve')

      within('#invite') do
        fill_in 'invite_email', with: 'johny@example.com'
        click_button 'Požiadať o prístup'
      end

      expect(page).to have_content('Ďakujeme Vám za spoluprácu. Onedlho Vás budeme kontaktovať.')
      expect(Invite.order(:locale).pluck(:email, :locale)).to eq([%w[johny@example.com en], %w[johny@example.com sk]])
    end
  end
end
