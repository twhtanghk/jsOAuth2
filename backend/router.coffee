Router = require 'koa-router'
router = new Router()
user = require './model/user'

isAuthenticated = require './policy/isAuthenticated'
isAuthorized = require './policy/isAuthorized'

module.exports = router
  .post '/user/register', user.register
  .post '/user/login', user.login
  .get '/user', user.find
  .get '/user/activate', user.activate
  .get '/user/:id', user.findOne
  .put '/user/:id', isAuthenticated, isAuthorized, user.update
  .delete '/user/:id', isAuthenticated, isAuthorized, user.destroy
