module.exports =
  port: parseInt(process.env.PORT) || 3000
  session:
    keys: process.env.KEYS?.split(',') || ['keep it secret']
  admin: process.env.ADMIN.split(',') || ['admin@abc.com']
  model:
    url: process.env.DB || 'mongodb://@mongo:27017/auth'
  # minute to expire the registration
  expiredTime: parseInt process.env.EXPIRED_TIME
  isExpired: (date) ->
    date.getTime + module.exports.expiredTime * 60000 < Date.now()
  email:
    opts:
      host: process.env.SMTP_HOST || 'smtp.abc.com'
      port: parseInt(process.env.SMTP_PORT) || 25
      secure: false
    from: process.env.SMTP_FROM
    user:
      register:
        subject: 'Validation for your account registration'
        html: '<p>Thank your for joining. Plesae click the link below to complete the registration process for your account. This validation key will be accepted for 24 hours.</p><p>Confirm: <a href="<%=url%>"><%=url%></a></p><p>If you did not request an account, please ignore and delete this email.</p>'
      reset:
        subject: 'Verfiication code for your account password'
        html: '<p>Please click the link below to reset your password.</p><p>Confirm: <a href="<%-url%>"><%=url%></a></p><p>If you are not the intended recipient, please ignore and delete this email.</p>'
