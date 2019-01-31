req = require 'supertest'
{parse} = require 'url'

describe 'oauth2', ->
  it 'token', ->
    url = parse process.env.TOKENURL
    req global.server
      .post url.path
      .auth process.env.CLIENTID, process.env.CLIENTSECRET
      .set 'Content-Type', 'application/x-www-form-urlencoded'
      .send 
        grant_type: 'password'
        username: process.env.USERID
        password: process.env.USERSECRET
        scope: ''
      .expect 200
      .then (res) ->
        global.token = res.body.access_token

  it 'verify', ->
    url = parse process.env.VERIFYURL
    req global.server
      .get url.path
      .set 'Authorization', "Bearer #{global.token}"
      .expect 200
      .then (res) ->
        console.log res.body

  it 'cors token', ->
    url = parse process.env.TOKENURL
    req global.server
      .options url.path
      .set 'Origin', 'abc.com'
      .set 'Access-Control-Request-Method', 'POST'
      .then (res) ->
        console.log res.headers
