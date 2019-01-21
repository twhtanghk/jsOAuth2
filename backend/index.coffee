cfg = require './config'
Koa = require 'koa'
logger = require 'koa-logger'
session = require 'koa-session'
bodyParser = require 'koa-bodyparser'
methodOverride = require 'koa-methodoverride'
router = require './router'
serve = require 'koa-static'
CSRF = require 'koa-csrf'

app = new Koa()
app.keys = cfg.session.keys
module.exports = app
  .use logger()
  .use session {maxAge: cfg.expiredTime * 60000}, app
  .use bodyParser()
  .use methodOverride()
  .use new CSRF
    invalidTokenMessage: JSON.stringify error: 'Invalid CSRF token'
  .use (ctx, next) ->
    ctx.cookies.set 'csrfToken', ctx.csrf, httpOnly: false
    await next()
  .use router.routes()
  .use router.allowedMethods()
  .use serve 'dist'
  .on 'session:missed', ->
    console.log 'sess missed'
  .listen cfg.port
