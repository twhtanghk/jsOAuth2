<template>
  <v-toolbar color='primary' dark>
    <v-toolbar-title class="white--text">
      <router-link class='title' to='/login'>
        Home
      </router-link>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <v-toolbar-items clsas='hidden-sm-and-down' v-if='isAuth'>
      <v-btn flat>Applications</v-btn>
      <v-btn flat>Change Password</v-btn>
      <v-btn flat>Delete Account</v-btn>
      <v-btn flat>Logout</v-btn>
    </v-toolbar-items>
  </v-toolbar>
</template>

<script lang='coffee'>
{eventBus} = require('./lib').default
{User} = require('./model').default

export default
  data: ->
    isAuth: false
  created: ->
    eventBus.$on 'auth', (flag) =>
      @isAuth = flag
</script>

<style scoped>
.title {
  color: inherit;
}

a.title:hover {
  text-decoration: none currentcolor solid;
}
</style>
