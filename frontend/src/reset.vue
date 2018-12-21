<template>
  <v-form action='user/login'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Reset</v-btn>
    </v-layout>
  </v-form>
</template>

<script lang='coffee'>
{eventBus} = require('./lib').default
{User} = require('./model').default

export default
  data: ->
    email: ''
    password: ''
  methods:
    login: ->
      User.login @email, @password
    register: ->
      eventBus.$emit 'register'
</script>

<style scoped>
button {
  margin: 0;
}

a {
  margin-top: 1.5em;
}
</style>
