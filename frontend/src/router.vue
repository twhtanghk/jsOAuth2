<script lang='coffee'>
Vue = require('vue').default
VueRouter = require('vue-router').default

Vue.use(VueRouter)

export default new VueRouter
  routes: [
    {path: '/user/register', component: require('./register').default}
    {path: '/user/activate', component: require('./activate').default}
    {path: '/user/login', component: require('./login').default}
    {path: '/user/reset', component: require('./reset').default}
    {path: '*', redirect: '/user/login'}
  ]
</script>
