Promise = require 'bluebird'
cfg = require '../config'
transporter = require 'nodemailer'

module.exports =
  transporter: ->
    Promise.promisifyAll transporter.createTransport cfg.email.opts
