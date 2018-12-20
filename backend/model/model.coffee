Promise = require 'bluebird'
_ = require 'lodash'
{MongoClient} = Promise.promisifyAll require 'mongodb'
cfg = require '../config'
mongoUri = require 'mongodb-uri'
uri = mongoUri.parse cfg.model.url
url = mongoUri.format _.omit uri, 'database'
dbName = uri.database

module.exports = ->
  client = await MongoClient.connectAsync url
  client.db dbName
