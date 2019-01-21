_ = require 'lodash'
Model = require './model'
{isURL} = require 'validator'

class App extends Model
  name: 'app'

  attributes: [
    'name'
    'clientId'
    'clientSecret'
    'authType'
    'cbUrl'
  ]

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

module.exports =
  new App()
    .actions()
