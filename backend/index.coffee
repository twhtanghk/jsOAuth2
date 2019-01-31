cfg = require './config'
Koa = require 'koa'
logger = require 'koa-logger'
session = require 'koa-session'
bodyParser = require 'koa-bodyparser'
methodOverride = require 'koa-methodoverride'
router = require './router'
serve = require 'koa-static'
cors = require '@koa/cors'
MongoStore = require 'koa2-session-mongo'
Promise = require 'bluebird'
{parse} = require 'mongodb-uri'
{database} = parse cfg.model.url

app = new Koa()
app.context.onerror = require 'koa-better-error-handler'
app.keys = cfg.session.keys
module.exports = new Promise (resolve, reject) ->
  server = app
    .use logger()
    .use require 'koa-404-handler'
    .use session {store: new MongoStore(url: cfg.model.url, db: database), maxAge: cfg.expiredTime * 60000}, app
    .use bodyParser()
    .use methodOverride()
    .use cors()
    .use router.routes()
    .use router.allowedMethods()
    .use serve 'dist'
    .listen cfg.port, (err) ->
      if err?
        return reject err
      resolve server
