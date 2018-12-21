_ = require 'lodash'
{collection} = require './model'
{hashSync, genSaltSync} = require 'bcrypt'

defaultValue = ->
  isActive: false
  createdAt: new Date()


module.exports =
  register: (ctx) ->
    try
      {email, password} = ctx.request.body
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
