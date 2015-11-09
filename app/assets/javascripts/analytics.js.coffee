$(document).ready ->
  $('[data-track-category]').click ->
    category = $(this).attr('data-track-category')
    action   = $(this).attr('data-track-action')

    if $(this).attr('data-track-label')
      label = $(this).attr('data-track-label')
    else
      label = if (id = $(this).attr('id')) then id else nil

    ga?('send', 'event', category, action, label)
