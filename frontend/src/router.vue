<script lang='coffee'>
Vue = require('vue').default
VueRouter = require('vue-router').default

Vue.use(VueRouter)

export default new VueRouter
  routes: [
    {path: '/user/register', component: require('./user/register').default}
    {path: '/user/activate', component: require('./user/activate').default}
    {path: '/user/login', component: require('./user/login').default}
    {path: '/user/logout', component: require('./user/logout').default}
    {path: '/user/reset', component: require('./user/reset').default}
    {path: '/user/resetPass', component: require('./user/resetPass').default}
    {path: '/user/passwd', component: require('./user/passwd').default}
    {path: '/user/delete', component: require('./user/destroy').default}
    {path: '/user', component: require('./user/list').default}
    {path: '/app/create', component: require('./app/create').default}
    {path: '/app', component: require('./app/list').default}
    {path: '*', redirect: '/user'}
  ]
</script>
