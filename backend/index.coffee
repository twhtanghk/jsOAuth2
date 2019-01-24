cfg = require './config'
Koa = require 'koa'
logger = require 'koa-logger'
session = require 'koa-session'
bodyParser = require 'koa-bodyparser'
methodOverride = require 'koa-methodoverride'
router = require './router'
serve = require 'koa-static'
Promise = require 'bluebird'

app = new Koa()
app.context.onerror = require 'koa-better-error-handler'
app.keys = cfg.session.keys
module.exports = new Promise (resolve, reject) ->
  server = app
    .use logger()
    .use require 'koa-404-handler'
    .use session {maxAge: cfg.expiredTime * 60000}, app
    .use bodyParser()
    .use methodOverride()
    .use router.routes()
    .use router.allowedMethods()
    .use serve 'dist'
    .listen cfg.port, (err) ->
      if err?
        return reject err
      resolve server
