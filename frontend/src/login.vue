<template>
<v-container fluid>
  <v-form @submit.stop.prevent='login'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' :rules='[required($v.email), emailValid($v.email)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='password' label='Password' type='password' :rules='[required($v.password), minLength($v.password)]' required />
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
</v-container>
</template>

<script lang='coffee'>
{eventBus} = require('./lib').default
{User} = require('./model').default
{required, email, minLength} = require 'vuelidate/lib/validators'
rule = require('./rule').default

export default
  data: ->
    email: ''
    password: ''
  validations:
    email: { required, email }
    password: { required, minLength: minLength(6) }
  methods:
    login: ->
      @$v.$touch()
      if not @$v.$invalid
        User
          .login @email, @password
          .then (user) =>
            eventBus.$emit 'auth', user
            @$router.push path: '/user'
          .catch ->
            return
    required: rule.required
    emailValid: rule.email
    minLength: rule.minLength
</script>

<style scoped>
button {
  margin: 0;
}

a {
  margin-top: 1.5em;
}
</style>
