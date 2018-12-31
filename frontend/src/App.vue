<template>
  <v-app>
    <toolbar />
    <v-container fluid>
      <router-view />
    </v-container>
  </v-app>
</template>

<script lang='coffee'>
Vue = require('vue').default
require './font'
{eventBus} = require('./lib').default
{User} = require('./model').default

Vue.use require 'vuetify'

export default
  name: 'app'
  components:
    toolbar: require('./toolbar').default
  created: ->
    try
      user = await User.me()
      eventBus.$emit 'auth', user
    catch err
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
