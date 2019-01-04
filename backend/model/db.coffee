_ = require 'lodash'
util = require 'util'
cfg = require '../config'
db = require('monk')(cfg.model.url)

logger = (context) -> (next) -> (args, method) ->
  console.log method, args
  next args, method
    .then (res) ->
      console.log "method: #{util.inspect res}"
      res

createdAt = (context) -> (next) -> (args, method) ->
  _.defaults args.data, createdAt: new Date()
  next args, method

updatedAt = (context) -> (next) -> (args, method) ->
  _.defaults args.data, updatedAt: new Date()
  next args, method

db.addMiddleware createdAt
db.addMiddleware updatedAt 

module.exports = db
