<template>
<v-container fluid>
  <v-form>
    <v-layout row>
      <v-text-field v-model='name' label='Name' :rules='[required($v.name)]' required disabled />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='clientId' label='Client ID' :rules='[required($v.clientId)]' required disabled />
    </v-layout>
    <v-layout row>
      <v-text-field v-model='clientSecret' label='Client Secret' :rules='[required($v.clientSecret)]' required disabled />
    </v-layout>
    <v-layout row>
      <v-select v-model='authType' :items='authList()' label='Authorization Grant Type' disabled />
    </v-layout row>
    <v-layout row>
      <v-text-field v-model='cbUrl' label='Redirect URL' :rules='[url($v.cbUrl)]' required disabled />
    </v-layout>
    <v-layout row>
      <v-btn @click.stop.prevent='edit'>Edit</v-btn>
      <v-btn @click.stop.prevent='destroy'>Delete</v-btn>
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
    edit: ->
      @$router.push path: "/app/edit/#{@$route.params.id}"
    destroy: ->
      @$router.push path: "/app/delete/#{@$route.params.id}"
    required: rule.required
    url: rule.url
  created: ->
    try
      app = await App.read data: id: @$route.params.id
      @name = app.name
      @clientId = app.clientId
      @clientSecret = app.clientSecret
      @authType = app.authType
      @cbUrl = app.cbUrl
    catch err
      console.error err.toString()
</script>

<style scoped>
button {
  margin: 0;
}
</style>
