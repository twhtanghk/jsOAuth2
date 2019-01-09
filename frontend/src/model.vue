<script lang='coffee'>
url = require 'url'
Vue = require('vue').default
Vue.use require('vue.model/src/plugin').default
{eventBus} = require('./lib').default

export default
  User: new Vue
    extends: Vue.component 'model'
    props:
      baseUrl:
        default: 'user'
      eventBus:
        default: eventBus
    methods:
      format: (data) ->
        if data.createAt?
          data.createdAt = new Date data.createdAt
        if data.updatedAt?
          data.updatedAt = new Date data.updatedAt
        data
      me: ->
        @read data: id: 'me'
      register: (email, password) ->
        @post 
          url: 'user/register'
          data:
            email: email
            password: password
      activate: (hash) ->
        @get
          url: url.format pathname: 'user/activate', query: hash: hash
      login: (email, password) ->
        @post 
          url: 'user/login'
          data:
            email: email
            password: password
      logout: ->
        @get url: 'user/logout'
      reset: (email) ->
        @put url: "user/reset/#{email}"
      resetPass: (hash, password) ->
        @put url: 'user/reset', data: {hash, password}
</script>
