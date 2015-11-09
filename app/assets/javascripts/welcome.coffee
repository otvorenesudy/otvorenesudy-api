$(document).ready ->
  $(document).on 'click', '#see-more', ->
    $('html, body').animate(scrollTop: $('.content').offset().top - 32, 'slow')

    false

  $(document).on 'click', '#see-invite', ->
    $('html, body').animate(scrollTop: $('.invite-form').offset().top, 'slow')

    false
