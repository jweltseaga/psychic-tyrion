before 'protect from forgery', ->
    protectFromForgery '8f4ae982f956d510a39869a2c7c50afb40991f5a'

salt = require('../../config/salts/salt-1').toString()
crypto = require "crypto"

calcHash = (pass, salt) ->
    hash = crypto.createHash("sha256")
    hash.update pass
    hash.update salt
    hash.digest "base64"

action 'login', () -> 
    render
        title: "Login"

action 'verify', () -> 
    User.all where: email: req.body.email, (err, user) ->
      if user.length is 1
        user.forEach (user) ->
          hash = calcHash(req.body.password, salt)
          if hash is user.password and user.id
            req.session.user = user.id
            if user.superUser is true
              req.session.superUser = true
            redirect path_to.campaigns
          else
            flash 'error', 'Invalid password or username.'
            redirect path_to.login
      else
        if user.length is 0
          flash 'info', 'User not found or activated.'
          redirect path_to.login
        else
          flash 'error', 'Bug #4376 reported.'
          redirect path_to.login
          console.log 'Serious failure, two users of the same'

action 'logout', () -> 
  req.session.regenerate (err) ->
    if err 
      console.log err
      flash 'error', 'Database Issue!'
      redirect path_to.login
    else
      flash 'info', 'Logged Out!'
      redirect path_to.login

action 'register', () -> 
    redirect path_to.login