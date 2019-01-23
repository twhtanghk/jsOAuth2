_ = require 'lodash'
Model = require './model'
{isURL} = require 'validator'
{URL, URLSearchParams} = require 'url'

class App extends Model
  name: 'app'

  attributes: [
    'name'
    'clientId'
    'clientSecret'
    'authType'
    'cbUrl'
    'createdBy'
  ]

  @type:
    code: 'Authorization Code'
    token: 'Implicit Grant'
    password: 'Resource Owner Password'
    client: 'Client Crendentials'

  constructor: ->
    super()
    # ensure client uniqueness 
    @model.createIndex {name: 1, creaetedBy: 1}, {unique: true}
    @model.createIndex {clientId: 1}, {unique: true}

  create: (ctx, next) ->
    _.extend ctx.request.body, createdBy: ctx.session.user._id
    if isURL ctx.request.body.cbUrl
      await super ctx, next
    else
      ctx.response.status = 403
      ctx.response.body = error: 'invalid redirect url'

  validClient: (ctx, next) ->
    {response_type, client_id, redirect_uri} = ctx.request.query
    error = (err) ->
      if redirect_uri?
        url = new URL redirect_uri
        url.search = new URLSearchParams error: err
        ctx.response.redirect url.toString()
      else
        ctx.response.body = error: err
    if not (response_type? and client_id?)
      return error 'invalid_request' 
    query =
      clientId: client_id
      authType: response_type
    ctx.client = await @model.findOne clientId: client_id
    if ctx.client?
      if ctx.client.authType == response_type
        await next()
      else
        url = new URL ctx.client.cbUrl
        url.search = new URLSearchParams error: 'unauthorized_client'
        ctx.response.redirect url.toString()
    else
      error 'invalid_client'

  clientAuth: (ctx, next) ->
    try
      {parse} = require 'basic-auth'
      {name, pass} = parse ctx.request.header.Authorization
      ctx.client = await @model.findOne {clientId: name, clientSecret: pass}
      await next()
    catch err
      ctx.throw 500, err.toString()

module.exports =
  new App()
    .actions [
      'create'
      'findOne'
      'find'
      'update'
      'destroy'
      'isAuthorized'
      'validClient'
      'clientAuth'
    ]
