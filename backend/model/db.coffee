util = require 'util'
cfg = require '../config'
db = require('monk')(cfg.model.url)
logger = (context) -> (next) -> (args, method) ->
  console.log method, args
  next args, method
    .then (res) ->
      console.log "method: #{util.inspect res}"
      res

module.exports = db
