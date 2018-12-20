module.exports =
  baseUrl: './'
  outputDir: '../backend/dist'
  lintOnSave: false
  devServer:
    host: '0.0.0.0'
    disableHostCheck: true
  configureWebpack: (config) ->
    config.module.rules.push
      test: /\.coffee$/
      use: ['babel-loader', 'coffee-loader']
    return
