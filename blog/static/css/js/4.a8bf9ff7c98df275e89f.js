webpackJsonp([4],{Qllj:function(e,t){},qGby:function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s={name:"interDetail",props:["params"],data:function(){return{form:{systemname:"",servicename:"",methodname:"",flag:"",requesttime:"",type:"",request:"",response:""}}},mounted:function(){var e=this,t={id:this.params.id};this.request.postJson(this.blogapi.detail,t).then(function(t){e.form.systemname=t.data.system,e.form.servicename=t.data.service,e.form.methodname=t.data.method,e.form.flag=t.data.flag,e.form.requesttime=t.data.opTime,e.form.type=t.data.type,e.form.request=t.data.request,e.form.response=t.data.response})},watch:{params:function(){this.qryInterDetail(this.params.id)}},methods:{qryInterDetail:function(e){var t=this,a={id:e};this.request.postJson(this.blogapi.detail,a).then(function(e){console.log(e.data),t.form.systemname=e.data.system,t.form.servicename=e.data.service,t.form.methodname=e.data.method,t.form.flag=e.data.flag,t.form.requesttime=e.data.opTime,t.form.type=e.data.type,t.form.request=e.data.request,t.form.response=e.data.response})}}},r={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("el-card",{staticClass:"box-card"},[a("div",[a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("系统名称")])]),e._v(" "),a("el-col",{attrs:{md:6}},[a("span",[e._v(e._s(e.form.systemname))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("服务名")])]),e._v(" "),a("el-col",{attrs:{md:20}},[a("span",[e._v(e._s(e.form.servicename))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("方法名")])]),e._v(" "),a("el-col",{attrs:{md:20}},[a("span",[e._v(e._s(e.form.methodname))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("有效标志")])]),e._v(" "),a("el-col",{attrs:{md:6}},[a("span",[e._v(e._s(e.form.flag))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("请求时间")])]),e._v(" "),a("el-col",{attrs:{md:20}},[a("span",[e._v(e._s(e.form.requesttime))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("请求方法")])]),e._v(" "),a("el-col",{attrs:{md:20}},[a("span",[e._v(e._s(e.form.type))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("请求报文")])]),e._v(" "),a("el-col",{attrs:{md:20}},[a("span",[e._v(e._s(e.form.request))])])],1),e._v(" "),a("el-row",[a("el-col",{attrs:{md:4}},[a("span",[e._v("返回报文")])]),e._v(" "),a("el-col",{attrs:{md:20}},[a("span",[e._v(e._s(e.form.response))])])],1)],1)])},staticRenderFns:[]};var o=a("VU/8")(s,r,!1,function(e){a("Qllj")},"data-v-7d3e7c2b",null);t.default=o.exports}});
//# sourceMappingURL=4.a8bf9ff7c98df275e89f.js.map