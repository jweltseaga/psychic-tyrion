express      = require 'express'
stylus       = require 'stylus'
RedisStore   = require("connect-redis")(express)
session_salt = require('./salts/session-salt').toString()
cookie_salt  = require('./salts/cookie-salt').toString()
form         = require 'connect-form-sync'



app.configure ->
    cwd = process.cwd()

    app.set 'views', cwd + '/app/views'
    app.set 'view engine', 'jade'
    app.set 'view options', complexNames: true
    app.enable 'coffee'

    app.use require('stylus').middleware
        force: true
        src: app.root + '/app/assets'
        dest: app.root + '/public'
        compress: true
    
    app.use express.compiler
        src: app.root + '/app/assets'
        dest: app.root + '/public'
        enable: ['coffeescript']
        
    app.use express.static(cwd + '/public', maxAge: 86400000)
    app.use express.bodyParser(keepExtensions: true, uploadDir: "#{__dirname}/../public/uploads")
    app.use express.cookieParser cookie_salt
    app.use express.session secret: session_salt, store: new RedisStore
    app.use express.methodOverride()
    app.use app.router

