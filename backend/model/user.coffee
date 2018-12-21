cfg = require '../config'
db = require './db'
_ = require 'lodash'
{hashSync, genSaltSync} = require 'bcrypt'

# ensure email uniqueness 
db.get('user').createIndex {email: 1}, {unique: true}

# set default value for inserting user data
db.addMiddleware (context) -> (next) -> (args, method) ->
  if context.collection.name == 'user' and method == 'insert'
    _.defaults args.data, 
      isActive: false
      createdAt: new Date()
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
