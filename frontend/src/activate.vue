<script lang='coffee'>
url = require 'url'
{User} = require('./model').default

export default
  created: ->
    {query} = url.parse window.location.toString(), true
    User
      .activate query.hash
      .then =>
        @$router.push path: '/user/login'
</script>
