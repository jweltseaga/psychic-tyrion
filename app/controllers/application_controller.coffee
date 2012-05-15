before 'protect from forgery', ->
    protectFromForgery '8f4ae982f956d510a39869a2c7c50afb40991f5a'
    
requireLogin = ->
    if req.session.user
      User.find req.session.user, (err, user) ->
        if err or user is null
          req.session.regenerate (err) ->
            flash 'danger', 'Your session has expired, please log in again.'
            redirect path_to.login
        else
          if user.id and user.id == req.session.user
            next()
          else
            redirect path_to.login
    else
      redirect path_to.login


before(requireLogin)

publish('requireLogin', requireLogin)

before use('requireLogin')



