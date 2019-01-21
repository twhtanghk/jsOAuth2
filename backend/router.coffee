Router = require 'koa-router'
router = new Router()
user = require './model/user'
app = require './model/app'

isAuthenticated = require './policy/isAuthenticated'
isAuthorized = require './policy/isAuthorized'

module.exports = router
  .post '/user/register', user.register, user.registerMail, user.omitAttr
  .get '/user/activate', user.registerExpire, user.activate, user.omitAttr
  .post '/user/login', user.login, user.omitAttr
  .get '/user/logout', user.logout
  .put '/user/reset/:email', user.validEmail, user.reset, user.resetMail, user.omitAttr
  .put '/user/reset', user.resetExpire, user.resetPass, user.omitAttr
  .put '/user/password', isAuthenticated, user.changePass, user.omitAttr
  .get '/user', user.find, user.omitAttr
  .get '/user/me', isAuthenticated, user.me, user.findOne, user.omitAttr
  .get '/user/:id', user.findOne, user.omitAttr
  .delete '/user/me', isAuthenticated, user.me, user.destroy, user.omitAttr
  .delete '/user/:id', isAuthenticated, isAuthorized, user.destroy, user.omitAttr
  .post '/app', isAuthenticated, app.create
  .get '/app', isAuthenticated, app.find
