<template>
  <v-toolbar color='primary'>
    <v-toolbar-title class="white--text">
      <router-link class='title' :to="user ? '/user' : '/user/login'">
        Home
      </router-link>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <v-menu offset-y v-if='user'>
      <v-btn slot='activator' dark flat>
        Applications
        <v-icon>arrow_drop_down</v-icon>
      </v-btn>
      <v-list>
        <v-list-tile v-for='(action, desc) in appMenu' :key='desc' @click='action'>
          <v-list-tile-title>{{desc}}</v-list-tile-title>
        </v-list-tile>
      </v-list>
    </v-menu>
    <v-menu offset-y v-if='user'>
      <v-btn slot='activator' dark icon>
        <font-awesome-icon icon='user-circle' size='2x' />
      </v-btn>
      <v-list>
        <v-list-tile>
          <v-list-tile-title>{{user.email}}</v-list-tile-title>
        </v-list-tile>
        <v-divider></v-divider>
        <v-list-tile v-for='(action, desc) in userMenu' :key='desc' @click='action'>
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
    userMenu:
      'Change Password': =>
        @$router.push path: '/user/passwd'
      'Delete Account': =>
        @$router.push path: '/user/delete'
      Logout: =>
        @$router.push path: '/user/logout'
    appMenu:
      List: =>
        @$router.push path: '/app'
      Create: =>
        @$router.push path: '/app/create'
  created: ->
    eventBus
      .$on 'auth', (user) =>
        @user = user
      .$on 'logout', =>
        @user = null
</script>

<style scoped>
.title {
  color: inherit;
}

a.title:hover {
  text-decoration: none currentcolor solid;
}
</style>
