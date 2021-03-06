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
  if method == 'insert'
    _.defaults args.data, createdAt: new Date()
  next args, method

updatedAt = (context) -> (next) -> (args, method) ->
  if method in [ 'update', 'findOneAndUpdate' ]
    args.update.$set ?= {}
    _.defaults args.update.$set, updatedAt: new Date()
  next args, method

db.addMiddleware createdAt
db.addMiddleware updatedAt 

module.exports = db
