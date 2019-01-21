<template>
<v-container fluid>
  <v-form @submit.stop.prevent='submit'>
    <v-layout row>
      <v-text-field v-model='password' label='New password' type='password' :rules='[required($v.password), minLength($v.password)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='passwordAgain' label='New password confirmation' type='password' :rules='[required($v.passwordAgain), minLength($v.passwordAgain), match($v.password, $v.passwordAgain)]' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Reset</v-btn>
    </v-layout>
  </v-form>
</v-container>
</template>

<script lang='coffee'>
url = require 'url'
{User} = require('../model').default
{required, minLength} = require 'vuelidate/lib/validators'
rule = require('../rule').default

export default
  data: ->
    hash: ''
    password: ''
    passwordAgain: ''
  validations:
    password: { required, minLength: minLength(6) }
    passwordAgain: { required, minLength: minLength(6) }
  methods:
    submit: ->
      User
        .resetPass @hash, @password
    required: rule.required
    minLength: rule.minLength
    match: rule.match
  created: ->
    {query} = url.parse window.location.toString(), true
    @hash = query.hash
</script>

<style scoped>
button {
  margin: 0;
}
</style>
