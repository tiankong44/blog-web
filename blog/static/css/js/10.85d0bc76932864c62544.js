webpackJsonp([10],{RMAE:function(e,r,t){"use strict";Object.defineProperty(r,"__esModule",{value:!0});var l={render:function(){var e=this,r=e.$createElement,t=e._self._c||r;return t("el-card",[t("el-form",{ref:"ruleForm",attrs:{model:e.ruleForm,rules:e.rules,"label-width":"140px"}},[t("el-form-item",{attrs:{label:"系统名称",prop:"systemName"}},[t("el-select",{attrs:{placeholder:"请选择系统名称"},model:{value:e.ruleForm.systemName,callback:function(r){e.$set(e.ruleForm,"systemName",r)},expression:"ruleForm.systemName"}},e._l(e.in_system,function(r){return t("el-option",{key:r.code,attrs:{label:r.name,value:r.code}},[e._v(e._s(r.name))])}),1)],1),e._v(" "),t("el-form-item",{attrs:{label:"请求方式",prop:"type"}},[t("el-select",{attrs:{placeholder:"请选择请求方式"},model:{value:e.ruleForm.type,callback:function(r){e.$set(e.ruleForm,"type",r)},expression:"ruleForm.type"}},e._l(e.in_req,function(r){return t("el-option",{key:r.code,attrs:{label:r.name,value:r.code}},[e._v(e._s(r.name))])}),1)],1),e._v(" "),t("el-form-item",{attrs:{label:"服务名",prop:"service"}},[t("el-input",{model:{value:e.ruleForm.service,callback:function(r){e.$set(e.ruleForm,"service",r)},expression:"ruleForm.service"}})],1),e._v(" "),t("el-form-item",{attrs:{label:"方法名",prop:"method"}},[t("el-input",{model:{value:e.ruleForm.method,callback:function(r){e.$set(e.ruleForm,"method",r)},expression:"ruleForm.method"}})],1),e._v(" "),t("el-form-item",{attrs:{label:"请求报文",prop:"request"}},[t("el-input",{model:{value:e.ruleForm.request,callback:function(r){e.$set(e.ruleForm,"request",r)},expression:"ruleForm.request"}})],1),e._v(" "),t("el-form-item",{attrs:{label:"返回报文",prop:"response"}},[t("el-input",{model:{value:e.ruleForm.response,callback:function(r){e.$set(e.ruleForm,"response",r)},expression:"ruleForm.response"}})],1),e._v(" "),t("el-form-item",{attrs:{label:"有效标志",prop:"flag"}},[t("el-select",{attrs:{placeholder:"请选择有效标志"},model:{value:e.ruleForm.flag,callback:function(r){e.$set(e.ruleForm,"flag",r)},expression:"ruleForm.flag"}},e._l(e.in_type,function(r){return t("el-option",{key:r.code,attrs:{label:r.name,value:r.code}},[e._v(e._s(r.name))])}),1)],1),e._v(" "),t("el-form-item",{attrs:{label:"其它参数配置1",prop:"bak1"}},[t("el-input",{model:{value:e.ruleForm.bak1,callback:function(r){e.$set(e.ruleForm,"bak1",r)},expression:"ruleForm.bak1"}})],1),e._v(" "),t("el-form-item",{attrs:{label:"其它参数配置2",prop:"bak2"}},[t("el-input",{model:{value:e.ruleForm.bak2,callback:function(r){e.$set(e.ruleForm,"bak2",r)},expression:"ruleForm.bak2"}})],1),e._v(" "),t("el-form-item",{staticStyle:{float:"right"}},[t("el-button",{attrs:{type:"primary"},on:{click:function(r){return e.submitForm("ruleForm")}}},[e._v("提交")]),e._v(" "),t("el-button",{attrs:{type:"info"},on:{click:function(r){return e.resetForm("ruleForm")}}},[e._v("重置")])],1)],1)],1)},staticRenderFns:[]},s=t("VU/8")({data:function(){return{in_system:[],in_type:[],in_req:[],ruleForm:{systemName:"",type:"",service:"",method:"",request:"",response:"",flag:"",bak1:"",bak2:""},rules:{systemName:[{required:!0,message:"请选择系统名称",trigger:"change"}],type:[{required:!0,message:"请选择活动区域",trigger:"change"}],service:[{required:!0,message:"请输入服务名",trigger:"blur"}],method:[{required:!0,message:"请输入方法名",trigger:"blur"}],request:[{required:!0,message:"请输入请求报文",trigger:"blur"}],response:[{required:!0,message:"请输入返回报文",trigger:"blur"}],flag:[{required:!0,message:"请选择有效标志",trigger:"change"}],bak1:[{required:!1,message:"请输入其它参数配置1",trigger:"blur"}],bak2:[{required:!1,message:"请输入其它参数配置2",trigger:"blur"}]}}},methods:{submitForm:function(e){var r=this;this.$refs[e].validate(function(e){if(!e)return r.$message({message:"添加失败！"}),!1;var t=r.ruleForm;r.request.postJson(r.blogapi.add,t).then(function(e){r.$message({message:"添加成功！",type:"success"}),r.clear()})})},resetForm:function(e){this.$refs[e].resetFields()},clear:function(){this.ruleForm=""}},mounted:function(){var e=this;this.request.postJson(this.blogapi.dictQuery,{dictColumn:"SYSTEM"}).then(function(r){e.in_system=r.data}),this.request.postJson(this.blogapi.dictQuery,{dictColumn:"FLAG"}).then(function(r){e.in_type=r.data}),this.request.postJson(this.blogapi.dictQuery,{dictColumn:"REQUEST"}).then(function(r){e.in_req=r.data})}},l,!1,null,null,null);r.default=s.exports}});
//# sourceMappingURL=10.85d0bc76932864c62544.js.map