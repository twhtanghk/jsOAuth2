User = require '../model/user'

module.exports = (ctx, next) ->
  if ctx.params.id == 'me'
    ctx.body = User.findOne email: ctx.session.user.email
  next()
