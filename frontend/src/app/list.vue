<template>
  <v-list two-line>
    <v-list-tile v-for='(app, i) in list' :key='i' avatar @click=''>
      <v-list-tile-avatar>
        <font-awesome-icon icon='tablet-alt' size='2x' />
      </v-list-tile-avatar>
      <v-list-tile-content>
        <v-list-tile-title v-html="title(app)" />
        <v-list-tile-sub-title v-html="subtitle(app)" />
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
    title: (app) ->
      "<span class='text--primary'>#{app.name} - #{app.authDesc}</span>"
    subtitle: (app) ->
      "<span class='text--primary'>#{app.cbUrl}</span> #{app.clientId} #{app.clientSecret}</span>"
  created: ->
    for await i from App.iterAll data: {sort: 'name', skip: @list.length}
      @list.push i
</script>
