<template>
<v-container fluid>
  <v-form @submit.stop.prevent='register'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' :rules='[required($v.email), emailValid($v.email)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='password' label='Password' type='password' :rules='[required($v.password), minLength($v.password)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='passwordAgain' label='Password confirmation' type='password' :rules='[required($v.passwordAgain), match($v.password, $v.passwordAgain)]' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Create account</v-btn>
    </v-layout>
  </v-form>
</v-container>
</template>

<script lang='coffee'>
{User} = require('./model').default
{required, email, minLength} = require 'vuelidate/lib/validators'
rule = require('./rule.vue').default

export default
  data: ->
    email: ''
    password: ''
    passwordAgain: ''
  validations:
    email: { required, email }
    password: { required, minLength: minLength(6) }
    passwordAgain: { required }
  methods:
    register: ->
      @$v.$touch()
      if not @$v.$invalid
        User
          .register @email, @password
          .then ->
            @$router.push path: '/user/login'
            console.info 'You have successfully registered. Please open the notification email and follow the steps to activate your account accordingly'
          .catch (err) ->
            console.error err.toString()
    required: rule.required
    emailValid: rule.email
    minLength: rule.minLength
    match: rule.match
</script>

<style scoped>
button {
  margin: 0;
}
</style>
