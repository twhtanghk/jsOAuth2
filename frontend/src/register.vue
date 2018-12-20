<template>
  <v-form action='user/register'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='password' label='Password' type='password' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='passwordAgain' label='Password confirmation' type='password' required />
    </v-layout>
    <v-layout row>
      <v-btn class='login' @click='register'>Create account</v-btn>
    </v-layout>
  </v-form>
</template>

<script lang='coffee'>
{User} = require('./model').default

export default
  data: ->
    email: ''
    password: ''
    passwordAgain: ''
  methods:
    register: ->
      if @password == '' or @password != @passwordAgain
        console.error 'mismatch password'
        return
      User.register @email, @password
</script>

<style scoped>
button {
  margin: 0;
}
</style>
