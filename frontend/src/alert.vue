<template>
  <v-container fluid>
    <v-layout column>
      <v-flex>
        <v-alert dismissible transition='fade' v-for='(alert, i) in alerts' :value='alerts.length' :type='alert.type' @input='close($event, i)'>
          {{alert.msg}}
        </v-alert>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script lang='coffee'>
_ = require 'lodash'

export default
  data: ->
    alerts: []
  methods:
    close: (visible, i) ->
      if not visible
        @$delete @alerts, i
  created: ->
    _.extend console, 
      log: (msg) =>
        @alerts.push {type: 'success', msg}
      info: (msg) =>
        @alerts.push {type: 'info', msg}
      warn: (msg) =>
        @alerts.push {type: 'warning', msg}
      error: (msg) =>
        @alerts.push {type: 'error', msg}
</script>

<style lang='scss' scoped>
.container {
  z-index: 4;
  position: absolute;
  left: 50%;
  width: 50%;

  .v-alert {
    border-radius: .5em;
  }
}
</style>
