$(document).ready ->
  $('#see-more').click ->
    $('html, body').animate({
      scrollTop: $('.content').offset().top - 2 * $('.navbar-fixed-top').height()
    }, 'slow')

    false
