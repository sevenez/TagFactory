import { createRouter, createWebHistory } from 'vue-router'
import Home from '../pages/Home.vue'
import Tags from '../pages/Tags.vue'
import Profile from '../pages/Profile.vue'
import Groups from '../pages/Groups.vue'
import GroupList from '../pages/GroupList.vue'
import GroupCreate from '../pages/GroupCreate.vue'
import Data from '../pages/Data.vue'
import Api from '../pages/Api.vue'
import Approvals from '../pages/Approvals.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/tags', component: Tags },
  { path: '/profile', component: Profile },
  { path: '/groups', component: Groups },
  { path: '/groups/list', component: GroupList },
  { path: '/groups/create', component: GroupCreate },
  { path: '/data', component: Data },
  { path: '/api', component: Api },
  { path: '/approvals', component: Approvals }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
