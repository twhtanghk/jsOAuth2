_ = require 'lodash'
Model = require './model'
cfg = require '../config'
jwt = require 'jsonwebtoken'
{URL, URLSearchParams} = require 'url'
{ObjectId} = require 'mongodb'

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
    {parse} = require 'query-string'
    {response_type, client_id, redirect_uri, scope} = parse ctx.request.search, arrayFormat: 'bracket'
    if Array.isArray scope
      scope = scope?.join ' '
    data =
      clientId: client_id
      scope: scope
      createdBy: new ObjectId ctx.session.user._id
    data.token = jwt.sign data, cfg.session.keys[0], expiresIn: OAuth2.expiresIn
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
          expiresIn: OAuth2.expiresIn
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
          clientId: ctx.client.clientId
          scope: scope
          createdBy: new ObjectId ctx.session.user._id
        data.token = jwt.sign data, cfg.session.keys[0], expiresIn: OAuth2.expiresIn
        data = await @model.insert data
        ctx.response.body =
          access_token: data.token
          token_type: 'Bearer'
          expiresIn: OAuth2.expiresIn
      when 'client_credentials'
        data =
          clientId: client_id
          scope: scope
        data.token = jwt.sign data, cfg.session.keys[0], expiresIn: OAuth2.expiresIn
        data = await @model.insert data
        ctx.response.body =
          access_token: data.token
          token_type: 'Bearer'
          expiresIn: OAuth2.expiresIn
      else
        ctx.throw 400, 'invalid_grant'
    
  verify: (ctx, next) ->
    token = ctx.request.header.authorization?.match(/^Bearer (.*)$/)?[1]
    if token?
      stage = [
        {
          $match:
            token: 
              $eq: token
        }
        {
          $lookup:
            from: 'user'
            localField: 'createdBy'
            foreignField: '_id'
            as: 'createdBy'
        }
        {
          $unwind: '$createdBy'
        }
        {
          $limit: 1
        }
      ]
      res = await @model.aggregate stage
      if res[0]?
        ctx.response.body =
          user:
            email: res[0]?.createdBy.email
          scope: res[0]?.scope
      else
        ctx.throw 401, 'invalid_grant'
    else
      ctx.throw 400, 'invalid_request'
      
module.exports =
  new OAuth2()
    .actions [
      'authorize'
      'token'
      'verify'
    ]
