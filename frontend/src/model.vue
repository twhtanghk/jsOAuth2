<script lang='coffee'>
url = require 'url'
Vue = require('vue').default
Vue.use require('vue.model/src/plugin').default
{eventBus} = require('./lib').default

Vue.component 'rest',
  extends: Vue.component 'model'
  props:
    eventBus:
      default: ->
        eventBus
  data: ->
    mw: [
      @csrf
      @json
      @methodOverride
      @req
      @res
      @error
    ]
  methods:
    format: (data) ->
      if data.createdAt?
        data.createdAt = new Date data.createdAt
      if data.updatedAt?
        data.updatedAt = new Date data.updatedAt
      data
    fetch: (opts = {}) ->
      opts.url ?= @baseUrl
      for i in @mw
        opts = await i opts
      opts
  
export default
  User: new Vue
    extends: Vue.component 'rest'
    props:
      baseUrl:
        default: "user"
    methods:
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
      delete: ->
        @del url: "#{@baseUrl}/me"
  App: new Vue
    extends: Vue.component 'rest'
    props:
      baseUrl:
        default: "app"
      _authList:
        type: Object
        default: ->
          code: 'Authorization Code'
          implicit: 'Implicit Grant'
          password: 'Resource Owner Password'
          client: 'Client Crendentials'
    methods:
      format: (data) ->
        _.extend data, authDesc: @_authList[data.authType]
      authList: ->
        reducer = (result, desc, key) ->
          result.push
            text: desc
            value: key
          result
        _.reduce @_authList, reducer, []
</script>
