cfg = require '../config'
path = require 'path'
{URL, URLSearchParams} = require 'url'

module.exports = (ctx, next) ->
  {response_type} = ctx.request.query
  ctx.session.user ?= null
  if ctx.session.user
    return await next()
  if response_type in ['code', 'token']
    next = new URL cfg.baseUrl
    next.pathname = path.join next.pathname, ctx.request.originalUrl
    url = new URL cfg.baseUrl
    url.hash = '/user/login'
    url.search = new URLSearchParams next: next.toString()
    return ctx.response.redirect url.toString()
  ctx.throw 401
