module.exports =
  port: parseInt(process.env.PORT) || 3000
  model:
    url: process.env.DB || 'mongodb://@mongo:27017/auth'
