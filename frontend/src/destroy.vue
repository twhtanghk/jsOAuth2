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
{User} = require('./model').default

export default
  methods:
    confirm: ->
      User
        .destroy()
        .then =>
          @$router.push path: '/user/logout'
    cancel: ->
      @$router.push path: '/user'
</script>

<style scoped>
/deep/ .v-dialog {
  width: 400px;
}
</style>
