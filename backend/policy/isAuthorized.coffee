cfg = require '../config'

module.exports = (ctx, next) ->
  {user} = ctx.session
  {id} = ctx.params
  if user._id.toString() != id and user.email not in cfg.admin
    return ctx.throw 401
  await next()
