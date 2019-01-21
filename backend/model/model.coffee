db = require './db'
_ = require 'lodash'

class Model
  name: ''

  attributes: []

  constructor: ->
    @model = db.get @name

  addMiddleware: (mw) ->
    db.addMiddleware mw

  create: (ctx, next) ->
    try
      ctx.response.body = await @model.insert _.pick ctx.request.body, @attributes
      await next()
    catch err
      ctx.throw 500, err.toString()

  update: (ctx, next) ->
    try
      query = _.pick ctx.params, '_id'
      update = $set: _.pick ctx.body, @attributes
      ctx.response.body = await @model.findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  findOne: (ctx, next) ->
    try
      ctx.response.body = await @model.findOne _.pick(ctx.params, '_id')
      await next()
    catch err
      ctx.throw 500, err.toString()
    
  find: (ctx, next) ->
    try
      optsField = ['limit', 'skip', 'sort']
      opts = _.pick ctx.request.body, optsField
      opts = _.defaults opts, {limit: 30, skip: 0}
      query = _.omit ctx.request.body, optsField
      ctx.response.body = await @model.find query, opts
      await next()
    catch err
      ctx.throw 500, err.toString()

  destroy: (ctx, next) ->
    try
      ctx.response.body = await @model.findOneAndDelete _.pick(ctx.params, '_id')
      await next()
    catch err
      ctx.throw 500, err.toString()

  # return controller actions for the input method names
  actions: (names = ['create', 'findOne', 'find', 'update', 'destroy']) ->
    reducer = (actions, action) =>
      actions[action] = (ctx, next) =>
        @[action] ctx, next
      actions
    names.reduce reducer, {}

module.exports = Model
