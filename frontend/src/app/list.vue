<template>
  <v-list two-line>
    <v-list-tile v-for='(app, i) in list' :key='i' avatar @click.stop='read(app)'>
      <v-list-tile-avatar>
        <font-awesome-icon icon='tablet-alt' size='2x' />
      </v-list-tile-avatar>
      <v-list-tile-content>
        <v-list-tile-title>
          <span class='text--primary'>{{app.name}} - {{app.authDesc}}</span>
        </v-list-tile-title>
        <v-list-tile-sub-title>
          <span class='text--primary'>{{app.cbUrl}}</span>
        <v-list-tile-sub-title>
      </v-list-tile-content>
    </v-list-tile>
  </v-list>
</template>

<script lang='coffee'>
{App} = require('../model').default

export default
  data: ->
    list: []
  methods:
    read: (app) ->
      @$router.push path: "/app/#{app._id}"
  created: ->
    for await i from App.iterAll data: {sort: 'name', skip: @list.length}
      @list.push i
</script>
