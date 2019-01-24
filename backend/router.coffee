Router = require 'koa-router'
router = new Router()
user = require './model/user'
oauth2 = require './model/oauth2'
app = require './model/app'
csrf = require './csrf'

isAuthenticated = require './policy/isAuthenticated'

module.exports = router
  # user
  .post '/user/register', csrf, user.register, user.registerMail, user.omitAttr
  .get '/user/activate', csrf, user.registerExpire, user.activate, user.omitAttr
  .post '/user/login', csrf, user.login, user.omitAttr
  .get '/user/logout', csrf, user.logout
  .put '/user/reset/:email', csrf, user.validEmail, user.reset, user.resetMail, user.omitAttr
  .put '/user/reset', csrf, user.resetExpire, user.resetPass, user.omitAttr
  .put '/user/password', csrf, isAuthenticated, user.changePass, user.omitAttr
  .get '/user', csrf, user.find, user.omitAttr
  .get '/user/me', csrf, isAuthenticated, user.me, user.findOne, user.omitAttr
  .get '/user/:id', csrf, user.findOne, user.omitAttr
  .delete '/user/me', csrf, isAuthenticated, user.me, user.destroy, user.omitAttr
  .delete '/user/:id', csrf, isAuthenticated, user.isAuthorized, user.destroy, user.omitAttr
  # app
  .post '/app', csrf, isAuthenticated, app.create
  .get '/app', csrf, isAuthenticated, app.find
  .get '/app/:id', csrf, isAuthenticated, app.isAuthorized, app.findOne
  .put '/app/:id', csrf, isAuthenticated, app.isAuthorized, app.update
  .delete '/app/:id', csrf, isAuthenticated, app.isAuthorized, app.destroy
  # token
  .get '/oauth2/authorize', csrf, isAuthenticated, app.validClient, oauth2.authorize
  .post '/oauth2/token', app.clientAuth, user.login, oauth2.token
  .get '/oauth2/verify', oauth2.verify
