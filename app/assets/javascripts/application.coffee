$(window).load ->
  $('a#form-submit').live 'click', ->
    csrf_token = $('meta[name=csrf-token]').attr('content')
    csrf_param = $('meta[name=csrf-param]').attr('content')
    if  !$('#name').val() || !$('#phone').val() || !$('#email').val()
      $('#errorMessage, #overlay').fadeIn(300).delay(3000).fadeOut(300)
    else
      
      auth_token = "<input name=\"" + csrf_param + "\" value=\"" + csrf_token + "\" type=\"hidden\" />"  if csrf_param? and csrf_token?
      data = $('form#contact').append(auth_token).serialize()

      $.post '/submit', data, (res) ->
        console.log res
        if res.success is true
          piwikTracker.trackGoal '1'
          $('form#contact input').val('')
          $('#ajax-info').html('<h1>Thank you for choosing Seaga!</h1><p>A vending consultant will be in touch with you shortly!</p>')
          $('#ajax-info, #overlay').fadeIn(300).delay(2000).fadeOut(300)
        else
          $('#ajax-info').html('<h1>We are sorry, but there was an error with your request!</h1><p>Call us at 1-815-297-9500 and we can assist you with your selection!</p>')
          $('#ajax-info, #overlay').fadeIn(300).delay(2000).fadeOut(300)
    return false;
  
  $('#overlay').live 'click', ->
    $('.flash:visible, #overlay').fadeOut(100)