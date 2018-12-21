import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'

Vue.config.productionTip = false

Vue.use(VueRouter)
const router = new VueRouter({
  routes: [
    {path: '/login', component: require('./login').default},
    {path: '/reset', component: require('./reset').default},
    {path: '/register', component: require('./register').default},
    {path: '*', redirect: '/login'}
  ]
})

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')
