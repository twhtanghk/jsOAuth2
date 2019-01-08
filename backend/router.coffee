Router = require 'koa-router'
router = new Router()
{omitAttr, register, registerMail, registerExpire, activate, login, logout, validEmail, reset, resetMail, resetExpire, resetPass, changePass, find, me, findOne, update, destroy}= require './model/user'

isAuthenticated = require './policy/isAuthenticated'
isAuthorized = require './policy/isAuthorized'

module.exports = router
  .post '/user/register', register, registerMail, omitAttr
  .get '/user/activate', registerExpire, activate, omitAttr
  .post '/user/login', login, omitAttr
  .get '/user/logout', logout
  .put '/user/reset/:email', validEmail, reset, resetMail, omitAttr
  .put '/user/reset', resetExpire, resetPass, omitAttr
  .post '/user/password', changePass, omitAttr
  .get '/user', find, omitAttr
  .get '/user/:id', me, findOne, omitAttr
  .put '/user/:id', isAuthenticated, isAuthorized, update, omitAttr
  .delete '/user/:id', isAuthenticated, isAuthorized, destroy, omitAttr
