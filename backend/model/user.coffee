db = require './db'
_ = require 'lodash'
{hashSync, genSaltSync} = require 'bcrypt'

# ensure email uniqueness 
db.get('user').ensureIndex {email: 1}, {unique: true}

# set default value for inserting user data
db.addMiddleware (context) -> (next) -> (args, method) ->
  if context.collection.name == 'user' and method == 'insert'
    _.defaults args.data, 
      isActive: false
      createdAt: new Date()
  next args, method

module.exports =
  register: (ctx) ->
    try
      {email, password} = ctx.request.body
      password = hashSync password, genSaltSync()
      ctx.body = await db.get('user').insert {email, password}
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
