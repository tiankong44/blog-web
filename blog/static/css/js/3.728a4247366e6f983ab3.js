webpackJsonp([3],{YfYE:function(t,o,n){"use strict";Object.defineProperty(o,"__esModule",{value:!0});var e=n("byj+"),s={name:"Login",data:function(){return{i:0}},computed:{},methods:{test2:function(){this.request.postJson(this.mockapi.queryCustomInfo,{groupId:"230151003840",region:"230"}).then(function(t){console.log(t)}).catch(function(t){console.log(t)})},test3:function(){this.request.getJson("/op/request2",{id:"444444"}).then(function(t){console.log(t)}).catch(function(t){console.log(t)})},test4:function(){this.request.postJson(this.mockapi.queryLogList,{groupId:"230151003840",region:"230"}).then(function(t){console.log(t)}).catch(function(t){console.log(t)})},download:function(){Object(e.a)({system:"",service:"",method:""},this.mockapi.interExport)}},mounted:function(){}},c={render:function(){var t=this,o=t.$createElement,n=t._self._c||o;return n("div",{attrs:{id:"login"}},[n("h1",[t._v("This is a test Page")]),t._v(" "),n("h1",[t._v("request is "+t._s(t.i))]),t._v(" "),n("button",{on:{click:t.test2}},[t._v("test2")]),t._v(" "),n("button",{on:{click:t.test3}},[t._v("test3")]),t._v(" "),n("button",{on:{click:t.test4}},[t._v("test4")]),t._v(" "),n("button",{on:{click:t.download}},[t._v("download")])])},staticRenderFns:[]};var i=n("VU/8")(s,c,!1,function(t){n("gUeG")},null,null);o.default=i.exports},gUeG:function(t,o){}});
//# sourceMappingURL=3.728a4247366e6f983ab3.js.map