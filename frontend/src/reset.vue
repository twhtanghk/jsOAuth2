<template>
<v-container fluid>
  <v-form @submit.stop.prevent='reset'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Reset</v-btn>
    </v-layout>
  </v-form>
</v-container>
</template>

<script lang='coffee'>
{eventBus} = require('./lib').default
{User} = require('./model').default

export default
  data: ->
    email: ''
  methods:
    reset: ->
      User.reset @email
</script>

<style scoped>
button {
  margin: 0;
}
</style>
