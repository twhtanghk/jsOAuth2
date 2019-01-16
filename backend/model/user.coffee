cfg = require '../config'
db = require './db'
_ = require 'lodash'
{compareSync, hashSync, genSaltSync} = require 'bcrypt'
{createTransport} = require 'nodemailer'
{isEmail} = require 'validator'

model = db.get 'user'

# ensure email uniqueness 
model.createIndex {email: 1}, {unique: true}

# remove any expired registration
db.addMiddleware (context) -> (next) -> (args, method) ->
  model
    .remove
      registerHash:
        $exists: true
      createdAt:
        $lt: new Date(Date.now() - cfg.expiredTime * 60000)
    .then ->
      next args, method

# remove any expired reset hash
db.addMiddleware (context) -> (next) -> (args, method) ->
  query =
    resetAt:
      $lt: new Date(Date.now() - cfg.expiredTime * 60000)
  update =
    $unset:
      resetAt: ''
      resetHash: ''
  model
    .update query, update
    .then ->
      next args, method

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
      ctx.response.body = await model.insert data
      await next()
    catch err
      ctx.throw 500, err.toString()

  registerMail: (ctx, next) ->
    try
      transporter = createTransport cfg.email.opts
      data =
        from: cfg.email.from
        to: ctx.response.body.email
        subject: cfg.email.user.register.subject
        html: _.template(cfg.email.user.register.html)(url: 'url')
      await transporter.sendMail data
      await next()
    catch err
      ctx.throw 500, err.toString()

  # check if registration is expired
  registerExpire: (ctx, next) ->
    try
      user = await model.findOne registerHash: ctx.query.hash
      if cfg.isExpired user?.createdAt
        ctx.response.status = 403
        ctx.response.body = error:  'Registration expired'
      else
        await next()
    catch err
      ctx.throw 500, err.toString()

  # check if reset is expired
  resetExpire: (ctx, next) ->
    try
      user = await model.findOne resetHash: ctx.request.body.hash
      if cfg.isExpired user?.resetAt
        ctx.response.status = 403
        ctx.response.body = error: 'Reset password expired'
      else
        await next()
    catch err
      ctx.throw 500, err.toString()
      
  activate: (ctx, next) ->
    try
      query = registerHash: ctx.request.query.hash
      update =
        $set:
          isActive: true
        $unset:
          registerHash: ''
      ctx.response.body = await model.findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  login: (ctx, next) ->
    try
      {email, password} = ctx.request.body
      user = await model.findOne {email}
      if user?
        if user.isActive 
          if compareSync password, user.password
            ctx.session = user: user
            ctx.response.body = user
            await next()
          else
            ctx.response.status = 403
            ctx.response.body = error: 'invalid password'
        else
          ctx.response.status = 403
          ctx.response.body = error: 'user not yet activate'
      else
        ctx.response.status = 403
        ctx.response.body = error: 'user not found'
    catch err
      ctx.throw 500, err.toString()
    
  logout: (ctx) ->
    ctx.session.user = null
    ctx.response.body = {}

  find: (ctx, next) ->
    try
      optsField = ['limit', 'skip', 'sort']
      opts = _.pick ctx.request.body, optsField
      opts = _.defaults opts, {limit: 30, skip: 0}
      query = _.omit ctx.request.body, optsField
      ctx.response.body = await model.find query, opts
      await next()
    catch err
      ctx.throw 500, err.toString()

  me: (ctx, next) ->
    ctx.params.id = ctx.session.user._id.toString()
    await next()

  findOne: (ctx, next) ->
    try
      ctx.response.body = await model.findOne _id: ctx.params.id
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
      email = ctx.params.email
      query = {email}
      now = new Date()
      update = 
        $set:
          resetAt: now
          resetHash: require('object-hash') {email, resetAt: now}
      ctx.response.body = await model.findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  resetMail: (ctx, next) ->
    try
      transporter = createTransport cfg.email.opts
      data =
        from: cfg.email.from
        to: ctx.response.body.email
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
      ctx.response.body = model.findOneAndUpdate query, update
      await next()
    catch err
      ctx.throw 500, err.toString()

  changePass: (ctx, next) ->
    try
      {email} = ctx.session.user
      {oldpass, newpass} = ctx.request.body
      user = await model.findOne {email}
      if user?
        if compareSync oldpass, user.password
          update = 
            $set:
              password: hashSync newpass, genSaltSync()
          ctx.response.body = await model.findOneAndUpdate {email}, update
          await next()
        else
          ctx.response.status = 403
          ctx.response.body = error: 'invalid password'
      else
        ctx.response.status = 403
        ctx.response.body = error: 'user not found'
    catch err
      ctx.throw 500, err.toString()

  destroy: (ctx, next) ->
    try
      {id} = ctx.params
      ctx.response.body = await model.findOneAndDelete id
    catch err
      ctx.throw 500, err.toString()
