<% if @invite.save %>
  $('.invite-form').replaceWith("<%= escape_javascript(render('created')) %>")
<% else %>
  $('.invite-form input[name="email"]').addClass('error')
<% end %>
