exports.routes = (map) ->
  map.get '/e/:slug', 'client#display'
  map.get '/brand/:slug', 'client#display'

  map.get '/rss', 'client#rssFeed'

  map.resources "users"
  map.resources "campaigns"
  map.resources "brands"

  # Auth
  map.get "/login", 'auth#login'
  map.post "/_verify", 'auth#verify'
  map.get "/_logout", 'auth#logout'

  # Mailer
  map.post '/submit', 'mailer#generateLead'

  # Deprecated Campaign Started Before Campaign Server Was Running

  map.get '/anniversary', 'deprecated#anniversary'
