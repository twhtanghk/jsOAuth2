module.exports =
  port: parseInt(process.env.PORT) || 3000
  session:
    keys: process.env.KEYS?.split(',') || ['keep it secret']
  model:
    url: process.env.DB || 'mongodb://@mongo:27017/auth'
