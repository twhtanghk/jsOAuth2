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
        default: "user"
      eventBus:
        default: eventBus
    methods:
      format: (data) ->
        if data.createdAt?
          data.createdAt = new Date data.createdAt
        if data.updatedAt?
          data.updatedAt = new Date data.updatedAt
        data
      me: ->
        @read data: id: 'me'
      register: (email, password) ->
        @post 
          url: "#{@baseUrl}/register"
          data:
            email: email
            password: password
      activate: (hash) ->
        @get
          url: url.format pathname: "#{@baseUrl}/activate", query: hash: hash
      login: (email, password) ->
        @post 
          url: "#{@baseUrl}/login"
          data:
            email: email
            password: password
      logout: ->
        @get url: "#{@baseUrl}/logout"
      reset: (email) ->
        @put url: "#{@baseUrl}/reset/#{email}"
      resetPass: (hash, password) ->
        @put url: "#{@baseUrl}/reset", data: {hash, password}
      passwd: (oldpass, newpass) ->
        @put url: "#{@baseUrl}/password", data: {oldpass, newpass}
      destroy: ->
        @del url: "#{@baseUrl}/me"
    created: ->
      @mw.unshift @csrf
</script>
