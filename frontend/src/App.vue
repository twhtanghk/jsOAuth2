<template>
  <v-app>
    <toolbar />
    <router-view />
  </v-app>
</template>

<script lang='coffee'>
Vue = require('vue').default
require './font'
{eventBus} = require('./lib').default
{User} = require('./model').default

Vue.use require 'vuetify'
Vue.use require('vuelidate').default

export default
  name: 'app'
  components:
    toolbar: require('./toolbar').default
  created: ->
    User
      .me()
      .then (user) =>
        eventBus.$emit 'auth', user
        @$router.push path: '/user'
      .catch ->
        return
</script>

<style lang='scss'>
@import url('https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Material+Icons');
@import '~vuetify/dist/vuetify.min.css';

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  * {
    text-transform: none !important;
  }
}
</style>
