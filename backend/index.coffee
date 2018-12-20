cfg = require './config'
Koa = require 'koa'
logger = require 'koa-logger'
session = require 'koa-session'
bodyParser = require 'koa-bodyparser'
methodOverride = require 'koa-methodoverride'
router = require './router'
serve = require 'koa-static'

app = new Koa()
app.keys = ['abc']
module.exports = app
  .use logger()
  .use session {}, app
  .use bodyParser()
  .use methodOverride()
  .use router.routes()
  .use router.allowedMethods()
  .use serve 'dist'
  .on 'session:missed', ->
    console.log 'sess missed'
  .listen cfg.port

