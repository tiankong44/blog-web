import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)
const index = () => import("@/components/front/index.vue");
const router = new Router({
  mode: "hash",
  base: "/blog/",
  routes: [
    {
      path: "/",
      component: index,
    },
  ],
});

export default router;