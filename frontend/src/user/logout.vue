<script lang='coffee'>
{eventBus} = require('../lib').default
{User} = require('../model').default

export default
  created: ->
    User
      .logout()
      .then =>
        eventBus.$emit 'logout'
        @$router.push path: '/user/login'
</script>
