import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)
//展示页面
const blogHome = () => import("@/components/front/index.vue");
const blogDetail = () => import("@/components/front/blog.vue");
const index = () => import("@/components/front/firstPage.vue");
const tag = () => import("@/components/front/tag.vue");
const archive = () => import("@/components/front/archive.vue");
const login = () => import("@/components/front/login.vue");
const album = () => import("@/components/front/album.vue");
const about = () => import("@/components/front/about.vue");
// 后台管理
const adminHome = () => import("@/components/admin/admin.vue");
const blogManagement = () => import("@/components/admin/blogManagement.vue");
const blogAdd = () => import("@/components/admin/blogAdd.vue");
const blogEdit = () => import("@/components/admin/blogEdit.vue");
const originalPush = Router.prototype.push

Router.prototype.push = function push(location) {
  return originalPush.call(this, location).catch(err => err)
}
const router = new Router({
  mode: "history",
  base: "/",
  routes: [
    {
      path: "/blogHome",
      redirect: '/index',
      component: blogHome,
      children: [
        // {
        //   path: "/index",
        //   component: blogHome,
        // },
        {
          path: "/blog",
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

        }, {
          path: "/album",
          name: "album",
          component: album,

        }, {
          path: "/about",
          name: "about",
          component: about,

        },
      ],
    },
    {
      path: "/",
      name: "blogHome",
      redirect: '/index',
      component: blogHome,
    },
    {
      path: "/blog/:id",
      name: "blogDetail",
      component: blogDetail,
    },
    {
      path: "/login",
      name: "login",
      component: login,
    },

    {
      path: "/admin",
      component: adminHome,
      children: [

        {
          path: "/blogManagement",
          name: "blogManagement",
          component: blogManagement,

        },
        {
          path: "/blogEdit",
          name: "blogEdit",
          component: blogEdit,
        },
        {
          path: "/blogAdd",
          name: "blogAdd",
          component: blogAdd,
        },


      ],
    },
    // {
    //   path: "/admin/blogs",
    //   component: login,
    // },

  ],
});

export default router;