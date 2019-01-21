<template>
  <v-list two-line>
    <template v-for="(user, i) in list">
      <v-list-tile>
        <v-list-tile-avatar>
          <font-awesome-icon icon='user-circle' size='2x' />
        </v-list-tile-avatar>
        <v-list-tile-content>
          <v-list-tile-title v-html='user.email' />
          <v-list-tile-sub-title v-html="`Created at: ${user.createdAt.toDateString()}`" />
        </v-list-tile-content>
      </v-list-tile>
    </template>
  </v-list>
</template>

<script lang='coffee'>
{User} = require('../model').default

export default
  data: ->
    list: []
  created: ->
    for await i from User.iterAll data: {sort: 'email', skip: @list.length}
      @list.push i
</script>
