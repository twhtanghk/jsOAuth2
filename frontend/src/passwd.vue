<template>
<v-container fluid>
  <v-form @submit.stop.prevent='passwd'>
    <v-layout row>
      <v-text-field v-model='oldPassword' label='Old password' type='password' :rules='[required($v.oldPassword), minLength($v.oldPassword)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='password' label='New password' type='password' :rules='[required($v.password), minLength($v.password)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='passwordAgain' label='New password confirmation' type='password' :rules='[required($v.passwordAgain), match($v.password, $v.passwordAgain)]' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Change</v-btn>
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
    oldPassword: ''
    password: ''
    passwordAgain: ''
  validations:
    oldPassword: { required, minLength: minLength(6) }
    password: { required, minLength: minLength(6) }
    passwordAgain: { required }
  methods:
    passwd: ->
      User
        .passwd @oldPassword, @password
        .then =>
          @$router.push path: '/user'
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
