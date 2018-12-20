module.exports = (ctx, next) ->
  ctx.session.user ?= null
  if ctx.session.user
    return next()
  ctx.throw 401
