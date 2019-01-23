_ = require 'lodash'
Model = require './model'
cfg = require '../config'
jwt = require 'jsonwebtoken'
{URL, URLSearchParams} = require 'url'

class OAuth2 extends Model
  name: 'oauth2'

  attributes: [
    'token'
    'clientId'
    'scope'
    'createdBy'
  ]

  @expiresIn: cfg.expiredTime * 60

  constructor: ->
    super()

    # remove any expired token
    @addMiddleware (context) => (next) => (args, method) =>
      @model
        .remove
          createdAt:
            $lt: new Date(Date.now() - cfg.expiredTime * 60000)

  authorize: (ctx, next) ->
    {response_type, client_id, redirect_uri, scope} = ctx.request.query
    data =
      clientId: client_id
      scope: scope
      createdBy: ctx.session.user._id
    data.token = jwt.sign data, cfg.session.keys[0], _.pick(OAuth2, 'expiresIn')
    data = await @model.insert data
    url = new URL ctx.client.cbUrl
    switch response_type
      when 'code'
        url.search = new URLSearchParams 
          code: data.token
        ctx.response.redirect url.toString()
      when 'token'
        search = new URLSearchParams 
          access_token: data.token
          token_type: 'bearer'
          expiresIn
        url.hash = search.toString()
        ctx.response.redirect url.toString()
      else
        url.search = new URLSearchParams error: 'unsupported_response_type'
        ctx.response.redirect url.toString()

  token: (ctx, next) ->
    {grant_type, username, password, scope} = ctx.request.body
    switch grant_type
      when 'password'
        data =
          clientId: client_id
          scope: scope
          createdBy: ctx.session.user._id
        data.token = jwt.sign data, cfg.session.keys[0], _.pick(OAuth2, expiresIn)
        data = await @model.insert data
        ctx.response.body =
          access_token: data.token
          token_type: 'Bearer'
          expiresIn: OAuth2.expiresIn
      when 'client_credentials'
        data =
          clientId: client_id
          scope: scope
        data.token = jwt.sign data, cfg.session.keys[0], _.pick(OAuth2, expiresIn)
        data = await @model.insert data
        ctx.response.body =
          access_token: data.token
          token_type: 'Bearer'
          expiresIn: OAuth2.expiresIn
      else
        ctx.throw 400, 'invalid_grant'
    
module.exports =
  new OAuth2()
    .actions [
      'authorize'
      'token'
    ]
