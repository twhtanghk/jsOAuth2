<template>
  <v-form @submit.stop.prevent='login'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='password' label='Password' type='password' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Sign in</v-btn>
    </v-layout>
    <v-layout row>
      <v-flex xs6>
        <a class='left' href='#/user/reset'>I can't access my account</a>
      </v-flex>
      <v-flex xs6>
        <a class='right' href='#/user/register'>Sign up</a>
      </v-flex>
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
      user = await User.login @email, @password
      eventBus.$emit 'auth', user
</script>

<style scoped>
button {
  margin: 0;
}

a {
  margin-top: 1.5em;
}
</style>
