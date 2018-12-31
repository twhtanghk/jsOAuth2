<template>
  <v-toolbar color='primary' dark>
    <v-toolbar-title class="white--text">
      <router-link class='title' to='/user/login'>
        Home
      </router-link>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <v-menu bottom left v-if='user'>
      <v-btn slot='activator' dark icon>
        <font-awesome-icon icon='user-circle' size='2x' />
      </v-btn>
      <v-list>
        <v-list-tile>
          <v-list-tile-title>{{user.email}}</v-list-tile-title>
        </v-list-tile>
        <v-divider></v-divider>
        <v-list-tile v-for='(action, desc) in actions' :key='desc' @click='action'>
          <v-list-tile-title>{{desc}}</v-list-tile-title>
        </v-list-tile>
      </v-list>
    </v-menu>
  </v-toolbar>
</template>

<script lang='coffee'>
{eventBus} = require('./lib').default

export default
  data: ->
    user: null
    actions:
      Applications: ->
      'Change Password': ->
      'Delete Account': ->
      Logout: ->
  created: ->
    eventBus.$on 'auth', (user) =>
      @user = user
</script>

<style scoped>
.title {
  color: inherit;
}

a.title:hover {
  text-decoration: none currentcolor solid;
}
</style>
