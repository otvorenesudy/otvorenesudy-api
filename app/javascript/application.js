/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from '@rails/activestorage';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import $ from 'jquery';
import 'popper.js';
import 'bootstrap';

// Fix jQuery
global.$ = jQuery;

// Google Analytics
$(() => {
  $('[data-track-category]').on('click', () => {
    const category = $(this).attr('data-track-category');
    const action = $(this).attr('data-track-action');
    let label;

    if ($(this).attr('data-track-label')) {
      label = $(this).attr('data-track-label');
    } else {
      const id = $(this).attr('id');
      label = id ?? null;
    }

    if (window.ga) ga('send', 'event', category, action, label);
  });
});

// Welcome Page
$(() => {
  $('#see-more').on('click', () => {
    $('html, body').animate({ scrollTop: $('.content').offset().top - 32 }, 'slow');
    return false;
  });

  $('#see-invite').on('click', () => {
    $('html, body').animate({ scrollTop: $('.invite-form').offset().top }, 'slow', () => {
      $('.invite-form input#email').focus();
    });
    return false;
  });
});

// Cookie consent
window.addEventListener('load', function () {
  const language = document.documentElement.lang || 'en';

  CookieConsent.run({
    categories: {
      necessary: {
        enabled: true,
        readOnly: true,
      },
      analytics: {
        enabled: true,
      },
    },

    language: {
      default: language,
      translations: {
        en: {
          consentModal: {
            title: 'Cookies',
            description:
              'We use cookies to ensure you get the best experience on our website. Please choose your preferences.',
            acceptAllBtn: 'Accept All',
            acceptNecessaryBtn: 'Reject All',
            showPreferencesBtn: 'Manage Individual Preferences',
          },
          preferencesModal: {
            title: 'Manage Your Cookie Preferences',
            acceptAllBtn: 'Accept All',
            acceptNecessaryBtn: 'Reject All',
            savePreferencesBtn: 'Accept Current Selection',
            closeIconLabel: 'Close Modal',
            sections: [
              {
                title: 'Strictly Necessary Cookies',
                description:
                  'These cookies are essential for the proper functioning of the website and cannot be disabled.',

                linkedCategory: 'necessary',
              },
              {
                title: 'Performance and Analytics',
                description:
                  'These cookies collect information about how you use our website. All of the data is anonymized and cannot be used to identify you.',
                linkedCategory: 'analytics',
              },
              {
                title: 'More information',
                description:
                  'For any queries in relation to our policy on cookies and your choices, please <a href="mailto:kontakt@otvorenesudy.sk">contact us</a>',
              },
            ],
          },
        },

        sk: {
          consentModal: {
            title: 'Cookies',
            description:
              'Používame cookies, aby sme zaistili, že na našej webovej stránke získate čo najlepší zážitok. Prosím, vyberte si svoje preferencie.',
            acceptAllBtn: 'Prijať všetky',
            acceptNecessaryBtn: 'Odmietnuť všetky',
            showPreferencesBtn: 'Spravovať individuálne preferencie',
          },
          preferencesModal: {
            title: 'Spravujte svoje preferencie cookies',
            acceptAllBtn: 'Prijať všetky',
            acceptNecessaryBtn: 'Odmietnuť všetky',
            savePreferencesBtn: 'Prijať aktuálny výber',
            closeIconLabel: 'Zatvoriť okno',
            sections: [
              {
                title: 'Nevyhnutné cookies',
                description:
                  'Tieto cookies sú nevyhnutné pre správne fungovanie webovej stránky a nemožno ich deaktivovať.',
                linkedCategory: 'necessary',
              },
              {
                title: 'Výkon a analytika',
                description:
                  'Tieto cookies zhromažďujú informácie o tom, ako používate našu webovú stránku. Všetky údaje sú anonymizované a nemožno ich použiť na vašu identifikáciu.',
                linkedCategory: 'analytics',
              },
              {
                title: 'Viac informácií',
                description:
                  'Pre akékoľvek otázky týkajúce sa našej politiky cookies a vašich možností, prosím <a href="mailto:kontakt@otvorenesudy.sk">kontaktujte nás</a>',
              },
            ],
          },
        },
      },
    },
  });
});
