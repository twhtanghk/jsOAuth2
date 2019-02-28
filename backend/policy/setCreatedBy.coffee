module.exports = (ctx, next) ->
  ctx.request.body ?= {}
  ctx.request.body.createdBy = ctx.session.user._id
  await next()
