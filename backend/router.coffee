Router = require 'koa-router'
router = new Router()
{omitAttr, register, registerMail, registerExpire, activate, login, logout, validEmail, reset, resetMail, resetExpire, resetPass, changePass, find, me, findOne, destroy}= require './model/user'

isAuthenticated = require './policy/isAuthenticated'
isAuthorized = require './policy/isAuthorized'

module.exports = router
  .post '/user/register', register, registerMail, omitAttr
  .get '/user/activate', registerExpire, activate, omitAttr
  .post '/user/login', login, omitAttr
  .get '/user/logout', logout
  .put '/user/reset/:email', validEmail, reset, resetMail, omitAttr
  .put '/user/reset', resetExpire, resetPass, omitAttr
  .put '/user/password', isAuthenticated, changePass, omitAttr
  .get '/user', find, omitAttr
  .get '/user/me', isAuthenticated, me, findOne, omitAttr
  .get '/user/:id', findOne, omitAttr
  .delete '/user/me', isAuthenticated, me, destroy, omitAttr
  .delete '/user/:id', isAuthenticated, isAuthorized, destroy, omitAttr
