compose = require 'koa-compose'
CSRF = require 'koa-csrf'

module.exports = 
  compose [
    new CSRF
      invalidTokenMessage: JSON.stringify error: 'Invalid CSRF token'
    (ctx, next) ->
      ctx.cookies.set 'csrfToken', ctx.csrf, httpOnly: false
      await next()
  ]
