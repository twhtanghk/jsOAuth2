url = require 'url'

describe 'user', ->
  app = 
    protocol: 'http'
    host: 'localhost'

  before ->
    app.port = global.server.address().port   

  it 'create', ->
    req url.format app
    :q
