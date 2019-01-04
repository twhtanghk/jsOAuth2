<template>
<v-container fluid>
  <v-form @submit.stop.prevent='reset'>
    <v-layout row>
      <v-text-field v-model='email' label='Email' :rules='[emailRequired, emailValid]' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Reset</v-btn>
    </v-layout>
  </v-form>
</v-container>
</template>

<script lang='coffee'>
{User} = require('./model').default
{required, email} = require 'vuelidate/lib/validators'

export default
  data: ->
    email: ''
  validations:
    email: { required, email }
  methods:
    reset: ->
      @$v.$touch()
      if not @$v.$invalid
        User
          .reset @email
    emailRequired: ->
      @$v.email.required || 'Required'
    emailValid: ->
      @$v.email.email || 'Invalid email address'
</script>

<style scoped>
button {
  margin: 0;
}
</style>
