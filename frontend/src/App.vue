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
{eventBus} = require('./lib').default
{User} = require('./model').default
Vuetify = require 'vuetify'

Vue.use Vuetify

export default
  name: 'app'
  components:
    toolbar: require('./toolbar').default
  data: ->
    eventBus: eventBus
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
