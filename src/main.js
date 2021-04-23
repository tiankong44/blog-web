// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from "./router";
import ElementUI from "element-ui";
import '../static/lib/prism/prism.css'
import "element-ui/lib/theme-chalk/index.css";
import store from "./store";
import { request } from "@/common/utils/request";
import { blogapi } from "@/common/config/api.js";
import VueDirectiveImagePreviewer from 'vue-directive-image-previewer'
import 'vue-directive-image-previewer/dist/assets/style.css'
import mavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'


import Viewer from 'v-viewer'
import 'viewerjs/dist/viewer.css'

import vueCropper from 'vue-cropper' 

Vue.use(vueCropper)

Vue.use(VueDirectiveImagePreviewer)
// import Prism from 'prismjs';
Vue.use(ElementUI);
Vue.use(ElementUI, { size: "small", zIndex: 3000 });
Vue.use(mavonEditor);
Vue.use(Viewer, {
  defaultOptions: {
    zIndex: 9999
  }
})
Vue.prototype.request = request;
Vue.prototype.blogapi = blogapi;
Vue.config.productionTip = false;

new Vue({
  el: "#app",
  router,
  store,
  render: (h) => h(App),
})
