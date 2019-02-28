module.exports = (ctx, next) ->
  ctx.request.body ?= {}
  ctx.request.body.createdBy = ctx.req.user._id
  await next()
