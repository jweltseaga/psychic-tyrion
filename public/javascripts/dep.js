(function() {

  $(window).load(function() {
    $('a#form-submit').live('click', function() {
      var auth_token, csrf_param, csrf_token, data;
      csrf_token = $('meta[name=csrf-token]').attr('content');
      csrf_param = $('meta[name=csrf-param]').attr('content');
      if (!$('#name').val() || !$('#phone').val() || !$('#email').val()) {
        $('#errorMessage, #overlay').fadeIn(300).delay(3000).fadeOut(300);
      } else {
        if ((csrf_param != null) && (csrf_token != null)) {
          auth_token = "<input name=\"" + csrf_param + "\" value=\"" + csrf_token + "\" type=\"hidden\" />";
        }
        data = $('form#contact').append(auth_token).serialize();
        $.post('/submit', data, function(res) {
          if (res.success === true) {
            piwikTracker.trackGoal('1');
            $('form#contact input').val('');
            $('#ajax-info').html('<h1>Thank you for choosing Seaga!</h1><p>A vending consultant will be in touch with you shortly!</p>');
            return $('#ajax-info, #overlay').fadeIn(300).delay(2000).fadeOut(300);
          } else {
            $('#ajax-info').html('<h1>We are sorry, but there was an error with your request!</h1><p>Call us at 1-815-297-9500 and we can assist you with your selection!</p>');
            return $('#ajax-info, #overlay').fadeIn(300).delay(2000).fadeOut(300);
          }
        });
      }
      return false;
    });
    return $('#overlay').live('click', function() {
      return $('.flash:visible, #overlay').fadeOut(100);
    });
  });

}).call(this);
