$(document).ready ->
  $('#see-more').click ->
    $('html, body').animate({
      scrollTop: $('.content').offset().top - $('.navbar-fixed-top').outerHeight()
    }, 'slow')

    false
