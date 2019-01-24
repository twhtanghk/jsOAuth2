oauth2 = require 'oauth2_client'
assert = require 'assert'

[
  'USERID'
  'USERSECRET'
  'CLIENTID'
  'CLIENTSECRET'
  'TOKENURL'
  'VERIFYURL'
].map (name) ->
  assert name of process.env, "process.env.#{name} not yet defined"

before ->
  global.server = await require '../index'

after ->
  global.server.close()
  process.exit()
