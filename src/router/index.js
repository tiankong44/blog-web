import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'

Vue.use(Router)
//const Demo_table = () => import("@/components/demo/table");
const router = new Router({
  mode: "hash",
  base: "/myblog/",
  routes: [
    {
      path: "/mockHome",
      component: mockHome,
      children: [
        {
          path: "/system",
          component: system,
        },

      ],
    },
    {
      path: "/",
      name: "mockHome",
      component: mockHome,
    },

 
  ],
});

export default router;