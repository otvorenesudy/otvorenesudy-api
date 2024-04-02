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
window.addEventListener('load', () => {
  if (!window.cookieconsent) return;

  window.cookieconsent.initialise({
    palette: {
      popup: {
        background: '#8392ac',
        text: '#fff',
      },
    },
    content: {
      message:
        'Táto stránka využíva cookies. V prípade, že nesúhlasíte s ukladaním súborov cookies na Vašom zariadení, prosím, opustite túto stránku.',
      dismiss: 'Súhlasím',
    },
    showLink: false,
  });
});
