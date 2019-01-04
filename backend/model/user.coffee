cfg = require '../config'
db = require './db'
_ = require 'lodash'
{compareSync, hashSync, genSaltSync} = require 'bcrypt'
{createTransport} = require 'nodemailer'

# ensure email uniqueness 
db.get('user').createIndex {email: 1}, {unique: true}

module.exports =
  omitAttr: (ctx) ->
    attrs = [ 'password', 'registerHash', 'resetHash' ]
    if Array.isArray ctx.response.body
      ctx.response.body = _.map ctx.response.body, (user) ->
        _.omit user, attrs
    else
      ctx.response.body = _.omit ctx.response.body, attrs

  register: (ctx, next) ->
    try
      {email, password} = ctx.request.body
      data =
        email: email
        password: hashSync password, genSaltSync() 
        isActive: false
        registerHash: require('object-hash') {email, createdAt: new Date()}
      ctx.body = await db.get('user').insert data
      await next()
    catch err
      ctx.throw 500, err.toString()

  registerMail: (ctx, next) ->
    try
      transporter = createTransport cfg.email.opts
      data =
        from: cfg.email.from
        to: ctx.body.email
        subject: cfg.email.user.register.subject
        html: _.template(cfg.email.user.register.html)(url: 'url')
      await transporter.sendMail data
      await next()
    catch err
      ctx.throw 500, err.toString()

  # check if registration is expired
  registerExpire: (ctx, next) ->
    try
      debugger
      user = await db.get('user').findOne registerHash: ctx.query.hash
      if user?.createdAt.getTime() + cfg.expiredTime * 60000 > Date.now()
        await next()
      else
        ctx.response.body = error: 'Registration expired'
    catch err
      ctx.throw 500, err.toString()

  # check if reset is expired
  resetExpire: (ctx, next) ->
    try
      await user = db.get('user').findOne resetHash: ctx.params.hash
      if user?.resetAt.getTime() + cfg.expiredTime * 60000 > Date.now()
        await next()
      else
        ctx.response.body = error: 'Registration expired'
    catch err
      ctx.throw 500, err.toString()
      
  activate: (ctx, next) ->
    try
      query = registerHash: ctx.request.query.hash
      update =
        $set:
          isActive: true
        $unset:
          hash: ''
      ctx.body = await db.get('user').findOneAndUpdate query, update
      debugger
      await next()
    catch err
      ctx.throw 500, err.toString()

  login: (ctx, next) ->
    try
      debugger
      {email, password} = ctx.request.body
      user = await db.get('user').findOne {email}
      if user? and user.isActive and compareSync password, user.password
        ctx.session = user: user
        ctx.response.body = user
        await next()
      else
        ctx.response.status = 403
    catch err
      ctx.throw 500, err.toString()
    
  logout: (ctx) ->
    ctx.session = null
    ctx.response.body = {}

  find: (ctx, next) ->
    try
      optsField = ['limit', 'skip', 'sort']
      opts = _.pick ctx.request.body, optsField
      opts = _.defaults opts, {limit: 30, skip: 0}
      query = _.omit ctx.request.body, optsField
      ctx.response.body = await db.get('user').find query, opts
      await next()
    catch err
      ctx.throw 500, err.toString()

  findOne: (ctx, next) ->
    if ctx.params.id == 'me'
      if ctx.session.user?
        ctx.response.body = ctx.session.user
        await next()
      else
        ctx.throw 403
    else
      try
        user = await db.get('user').findOne _id: ctx.params.id
        ctx.response.body = _.omit user, 'password'
        await next()
      catch err
        ctx.throw 500, err.toString()

  validEmail: (ctx, next) ->
    if isEmail ctx.params.email
      await next()
    else
      ctx.throw 500, error: 'invalid email'

  reset: (ctx, next) ->
    try
      query = _.pick ctx.params, 'email'
      now = new Date()
      update = 
        resetAt: now
        resetHash: require('object-hash') {email, resetAt: now}
      ctx.response.body = await db.get('user').findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  resetMail: (ctx, next) ->
    try
      transporter = createTransport cfg.email.opts
      data =
        from: cfg.email.from
        to: ctx.body.email
        subject: cfg.email.user.reset.subject
        html: _.template(cfg.email.user.reset.html)(url: 'url')
      await transporter.sendMail data
      await next()
    catch err
      ctx.throw 500, err.toString()

  resetPass: (ctx, next) ->
    try
      {hash, password} = ctx.request.body
      query = resetHash: hash
      update =
        $set:
          password: hashSync password, genSaltSync()
        $unset:
          resetAt: ''
          resetHash: ''
      ctx.response.body = db.get('user').findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  changePass: (ctx, next) ->
    try
      {email, password} = ctx.request.body
      query = email: email
      update =
        $set:
          password: hashSync password, genSaltSync()
      ctx.response.body = db.get('user').findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  # check if registration is expired
  update: (ctx, next) ->

  destroy: (ctx, next) ->
