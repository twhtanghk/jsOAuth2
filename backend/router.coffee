Router = require 'koa-router'
router = new Router()
user = require './model/user'

isAuth = require './policy/isAuth'
me = require './policy/me'

module.exports = router
  .all '/session', isAuth, (ctx, next) ->
    console.log ctx.session
    ctx.response.body = 'ok'
  .post '/user/register', user.register
  .post '/user/login', user.login
  .get '/user', user.find
  .get '/user/:id', isAuth, me, user.findOne
  .put '/user/:id', isAuth, user.update
  .delete '/user/:id', isAuth, user.destroy
