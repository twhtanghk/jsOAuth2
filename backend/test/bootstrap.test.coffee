server = null

before ->
  server = require '../index'

after ->
  server.close()
