$(document).ready ->
  $('.btn-see-more').click ->
    $('html, body').animate({
      scrollTop: $('.content').offset().top
    }, 'slow')

    false
