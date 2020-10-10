// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from "./router";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import store from "./store";
import { request } from "@/common/utils/request";
import { blogapi } from "@/common/config/api.js";

Vue.use(ElementUI);
Vue.use(ElementUI, { size: "small", zIndex: 3000 });
Vue.prototype.request = request;
Vue.prototype.blogapi = blogapi;
Vue.config.productionTip = false;

/* eslint-disable no-new */
new Vue({
  el: "#app",
  router,
  store,
  render: (h) => h(App),
})
