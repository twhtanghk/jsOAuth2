cfg = require '../config'
db = require './db'
_ = require 'lodash'
{compareSync, hashSync, genSaltSync} = require 'bcrypt'

# set default values isActive and createdAt for created user
db.addMiddleware (context) -> (next) -> (args, method) ->
  if context.collection.name == 'user' and method == 'insert'
    _.defaults args.data, 
      isActive: false
      createdAt: new Date()
  next args, method

# set default value hash for created user
db.addMiddleware (context) -> (next) -> (args, method) ->
  if context.collection.name == 'user' and method == 'insert'
    _.defaults args.data, hash: require('object-hash') args.data
  next args, method

# check if registration is expired
db.addMiddleware (context) -> (next) -> (args, method) ->
  if context.collection.name == 'user' and method == 'findOneAndUpdate'
    db.get('user').findOne args.query
      .then (res) ->
        if res?.createdAt.getTime() + cfg.expiredTime * 60000 > Date.now()
          next args, method
        else
          throw 'Registration expired'
  else
    next args, method

# send email notifcation after inserting user data
db.addMiddleware (context) -> (next) -> (args, method) ->
  next args, method
    .then (res) ->
      if context.collection.name == 'user' and method == 'insert'
        {transporter} = require '../service/email'
        transporter()
          .sendMailAsync
            from: cfg.email.from
            to: res.email
            subject: cfg.email.user.register.subject
            html: _.template(cfg.email.user.register.html)(url: 'url')
          .then ->
            res
      else
        res

# ensure email uniqueness 
db.get('user').createIndex {email: 1}, {unique: true}

module.exports =
  register: (ctx) ->
    try
      {email, password} = ctx.request.body
      password = hashSync password, genSaltSync()
      ctx.body = await db.get('user').insert {email, password}
    catch err
      ctx.throw 500, err.toString()

  activate: (ctx) ->
    try
      debugger
      query = _.pick ctx.params, 'hash'
      update =
        $set:
          isActive: true
        $unset:
          hash: ''
      ctx.body = await db.get('user').findOneAndUpdate query, update
    catch err
      ctx.throw 500, err.toString()

  login: (ctx) ->
    try
      {email, password} = ctx.request.body
      user = await db.get('user').findOne {email}
      if user? and user.isActive and compareSync password, user.password
        user = _.omit user, 'password'
        ctx.session = user: user
        ctx.response.body = user
      else
        ctx.response.status = 401
    catch err
      ctx.throw 500, err.toString()
    
  find: (ctx) ->

  findOne: (ctx) ->
    debugger
    if ctx.params.id == 'me'
      if ctx.session.user?
        ctx.response.body = ctx.session.user
      else
        ctx.throw 403
    else
      try
        user = await db.get('user').findOne _id: ctx.params.id
        ctx.response.body = _.omit user, 'password'
      catch err
        ctx.throw 500, err.toString()

  update: (ctx) ->

  destroy: (ctx) ->
