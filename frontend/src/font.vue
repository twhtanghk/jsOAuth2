<script lang='coffee'>
Vue = require('vue').default
{library} = require '@fortawesome/fontawesome-svg-core'
{FontAwesomeIcon} = require '@fortawesome/vue-fontawesome'
{faUserCircle, faQuestion, faSearch, faList, faUserShield, faUserLock, faTabletAlt} = require '@fortawesome/free-solid-svg-icons'
library.add faUserCircle, faQuestion, faSearch, faList, faUserShield, faUserLock, faTabletAlt
Vue.component 'font-awesome-icon', FontAwesomeIcon
</script>

<style lang='scss'>
@import '~@fortawesome/fontawesome-svg-core/styles.css';
</style>
