<template>
<v-container fluid>
  <v-layout row justify-center>
    <v-dialog value='true' persistent>
      <v-card>
        <v-card-title class='headline'>
          Confirm to delete?
        </v-card-title>
        <v-card-actions>
          <v-btn color='error' @click='confirm'>
            Confirm
          </v-btn>
          <v-btn color='info' @click='cancel'>
            Cancel
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-layout>
</v-container>
</template>

<script lang='coffee'>
{App} = require('../model').default

export default
  methods:
    confirm: ->
      App
        .delete data: id: @$route.params.id
        .then =>
          @$router.push path: '/app'
    cancel: ->
      @$router.push path: '/app'
</script>

<style scoped>
/deep/ .v-dialog {
  width: 400px;
}
</style>
