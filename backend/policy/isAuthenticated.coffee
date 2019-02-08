module.exports = (ctx, next) ->
  ctx.session.user ?= null
  if ctx.session.user?
    return await next()
  ctx.status = 401
