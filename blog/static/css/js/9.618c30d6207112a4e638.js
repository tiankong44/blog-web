webpackJsonp([9],{oWgK:function(t,e,s){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var a={name:"intro",data:function(){return{msg:"Welcome to mockWeb",activeName:"first"}},methods:{handleClick:function(t,e){console.log(t,e)}}},r={render:function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",[s("el-card",{staticClass:"box-card"},[s("div",{staticClass:"clearfix",attrs:{slot:"header"},slot:"header"},[s("span",[t._v("背景说明")])]),t._v(" "),s("div",{staticClass:"text item"},[s("p",[t._v("目前集客微服务平台、资金管理、订单系统等调用的三方系统接口包含CRM接口、无纸化接口等。")]),t._v(" "),s("p",[t._v("举个例子，如果CRM接口系统无法调用，就会导致开发不能进行或测试环境的测试不能进行。同时由于内网的要求，部署在公司内网的测试环境应用无法访问局方三方系统的接口，存在挡板测试的情况。")])])]),t._v(" "),s("el-card",{staticClass:"box-card"},[s("div",{staticClass:"clearfix",attrs:{slot:"header"},slot:"header"},[s("span",[t._v("如何模拟三方接口服务")])]),t._v(" "),s("div",{staticClass:"text item"},[s("p",[t._v("采用 SpringBoot 开发对应三方系统的Rest接口，具体的上面已经提到，如`/OAuth/restOauth2Server/access_token` ， `/openapi/httpService/` ;")]),t._v(" "),s("p",[t._v("模拟报文采用Mysql数据库新建表进行持久话存储，方便修改;")]),t._v(" "),s("p",[t._v("以`method+入参`作为参数请求对应的Rest接口，服务通过参数查询数据库返回对应的模拟报文;")]),t._v(" "),s("p",[t._v("模拟报文通过目前系统已有的日志记录表中获取，后续考虑提供导入、修改等功能。")])])]),t._v(" "),s("el-card",{staticClass:"box-card"},[s("div",{staticClass:"clearfix",attrs:{slot:"header"},slot:"header"},[s("span",[t._v("如何模拟三方接口服务")])]),t._v(" "),s("div",{staticClass:"text item"},[s("p",[t._v("采用 SpringBoot 开发对应三方系统的Rest接口，具体的上面已经提到，如`/OAuth/restOauth2Server/access_token` ， `/openapi/httpService/` ;")]),t._v(" "),s("p",[t._v("模拟报文采用Mysql数据库新建表进行持久话存储，方便修改;")]),t._v(" "),s("p",[t._v("以`method+入参`作为参数请求对应的Rest接口，服务通过参数查询数据库返回对应的模拟报文;")]),t._v(" "),s("p",[t._v("模拟报文通过目前系统已有的日志记录表中获取，后续考虑提供导入、修改等功能。")])])]),t._v(" "),s("el-card",{staticClass:"box-card"},[s("div",{staticClass:"clearfix",attrs:{slot:"header"},slot:"header"},[s("span",[t._v("模拟三方接口服务流程")])]),t._v(" "),s("div",{staticClass:"text item"},[s("p",[t._v("正常流程如下：")]),t._v(" "),s("img",{attrs:{src:"static/images/1.png"}}),t._v(" "),s("p",[t._v("通过模拟服务器流程如下：")]),t._v(" "),s("img",{attrs:{src:"static/images/2.png"}})])])],1)},staticRenderFns:[]},i=s("VU/8")(a,r,!1,null,null,null);e.default=i.exports}});
//# sourceMappingURL=9.618c30d6207112a4e638.js.map