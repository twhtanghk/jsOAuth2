<template>
<v-container fluid>
  <v-form @submit.stop.prevent='register'>
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
      <v-btn type='submit'>Create account</v-btn>
    </v-layout>
  </v-form>
</v-container>
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
      User
        .register @email, @password
        .then ->
          @$router.push path: '/user/login'
</script>

<style scoped>
button {
  margin: 0;
}
</style>
