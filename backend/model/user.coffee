_ = require 'lodash'
{hashSync, genSaltSync} = require 'bcrypt'
defaultValue = ->
  isActive: false
  createdAt: new Date()

collection = (name) ->
  db = await require('./model')()
  db.collection name

module.exports =
  register: (ctx) ->
    try
      {email, password} = ctx.request.body
      debugger
      password = hashSync password, genSaltSync()
      data = _.defaults {email, password}, defaultValue()
      r = (await collection('user')).insertOneAsync data
      ctx.body = _.extend data, id: r.insertedId
    catch err
      ctx.throw 500, err.toString()

  login: (ctx) ->
    try
      {email, password} = ctx.request.body
      await collection('user').findOneAsync {email}
    
  find: (ctx) ->

  findOne: (ctx) ->

  update: (ctx) ->

  destroy: (ctx) ->
