import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)
const blogHome = () => import("@/components/front/index.vue");
const blogDetail = () => import("@/components/front/blog.vue");
const index = () => import("@/components/front/firstPage.vue");
const tag = () => import("@/components/front/tag.vue");
const archive = () => import("@/components/front/archive.vue");
const login = () => import("@/components/front/login.vue");
const originalPush = Router.prototype.push

Router.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}
const router = new Router({
  mode: "hash",
  base: "/blog/",
  routes: [
    
    {
      path: "/blogHome",
      component: blogHome,
      children: [
        // {
        //   path: "/index",
        //   component: blogHome,
        // },
        {
          path: "/blog/:id",
          name: "blogDetail",
          component: blogDetail,

        },
        {
          path: "/index",
          name: "index",
          component: index,

        },
        {
          path: "/tag",
          name: "tag",
          component: tag,

        },
        {
          path: "/archive",
          name: "archive",
          component: archive,

        },
      ],
    },
    {
      path: "/",
      name: "blogHome",
      component: blogHome,
    },
    {
      path: "/blog/:id",
      name: "blogDetail",
      component: blogDetail,

    },
  
    // {
    //   path: "/index",
    //   component: index,
    // },
    // {
    //   path: "/blog/:id",
    //   name:"blogDetail",
    //   component: blogDetail,

    // },
    // {
    //   path: "/index",
    //   name:"index",
    //   component: index,

    // },
    // {
    //   path: "/tag",
    //   name:"tag",
    //   component: tag,

    // },
  ],
});

export default router;