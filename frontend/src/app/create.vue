<template>
<v-container fluid>
  <v-form @submit.stop.prevent='submit'>
    <v-layout row>
      <v-text-field v-model='name' label='Name' :rules='[required($v.name)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='clientId' label='Client ID' :rules='[required($v.clientId)]' required />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='clientSecret' label='Client Secret' :rules='[required($v.clientSecret)]' required />
    </v-layout>
    <v-layout row>
      <v-select v-model='authType' :items='authList()' label='Authorization Grant Type' />
    </v-layout row>
    <v-layout row>
      <v-text-field v-model='cbUrl' label='Redirect URL' :rules='[url($v.cbUrl)]' required />
    </v-layout>
    <v-layout row>
      <v-btn type='submit'>Create</v-btn>
    </v-layout>
  </v-form>
</v-container>
</template>

<script lang='coffee'>
{App} = require('../model').default
{required, url} = require 'vuelidate/lib/validators'
rule = require('../rule.vue').default
{generateHash} = require 'random-hash'

export default
  data: ->
    name: ''
    clientId: generateHash length: 41
    clientSecret: generateHash length: 129
    authType: 'implicit'
    cbUrl: ''
  validations:
    name: { required }
    clientId: { required }
    clientSecret: { required }
    cbUrl: { url }
  methods:
    authList: App.authList
    submit: ->
      @$v.$touch()
      if not @$v.$invalid
        App
          .create data: _.pick @, 'name', 'clientId', 'clientSecret', 'authType', 'cbUrl'
          .then =>
            @$router.push path: '/app'
          .catch (err) =>
            if err.message == 'Unauthorized access'
              @$router.push '/user/login'
            console.error err.toString()
    required: rule.required
    url: rule.url
</script>

<style scoped>
button {
  margin: 0;
}
</style>
