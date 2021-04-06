<!-- 导航栏 -->
<template>
  <div class="">
    <div class="header">
      <el-row class="" :gutter="10">
        <el-menu class="el-menu-demo header-padding" mode="horizontal" @select="handleSelect" background-color="#000000" text-color="#fff" active-text-color="#0FD03F">
          <el-col :span="5">
            <div class="location-center hide">111</div>
          </el-col>

          <el-menu-item index="blogManage" class="header-text">博客管理</el-menu-item>

          <el-menu-item index="tagManage" class="header-text">标签管理</el-menu-item>

          <el-menu-item index="albumManage" class="header-text">相册管理</el-menu-item>
          <el-menu-item index="galleryManage" class="header-text">图床管理</el-menu-item>
          <!-- <el-menu-item index="album" class="header-text">相册</el-menu-item> -->

          <!-- <el-menu-item index="about" class="header-text">关于我</el-menu-item> -->
          <el-col :span="4">
            <div class="hide">1</div>
          </el-col>

          <el-submenu class="nav-user-avatar" index="user" v-if="userVo != null">
            <template slot="title">
              <el-avatar :src="userVo.avatar"></el-avatar>
              {{ userVo.nickname }}
            </template>

            <el-menu-item index="personalInformation">资料修改</el-menu-item>
            <el-menu-item index="logout" @click="logout">退出</el-menu-item>
          </el-submenu>

          <el-menu-item index="login" class="nav-user-text" @click="toLogin" v-if="userVo == null">请登录</el-menu-item>
        </el-menu>
        <router-view :key="$route.title" v-if="!isShow" />
      </el-row>
    </div>
    <myfooter></myfooter>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';

import { _tiper } from '@/common/utils/ui.js'
import myfooter from '@/components/front/footer'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: { myfooter },
  data() {
    //这里存放数据
    return { title: '', homeSrc: '/admin', config: { blogManage: 'blogManagement', tagManage: '/tagManage', albumManage: '/albumManage', galleryManage: '/galleryManage' }, userVo: {}, isShow: false }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getSysUserInfo() {
      this.request
        .postJson(this.blogapi.getSysUserInfo)
        .then((res) => {
          if (res.code == 0) {
            this.userVo = res.data
          } else {
            this.userVo = null
          }
        })
        .catch((error) => {})
    },
    logout() {
      this.request
        .postJson(this.blogapi.logout)
        .then((res) => {
          if (res.code == 0) {
            this.$router.push('/login')
            _tiper.success(res.desc)
          } else {
            _tiper.warn(res.desc)
          }
        })
        .catch((error) => {})
    },
    toLogin() {
      if (this.userVo == null) {
        var url = window.location.href
        this.$router.push({ name: 'login', params: { url: url } })
      }
    },
    handleSelect(key, keyPath) {
      this.$router.push({ name: this.config[key], params: { userVo: this.userVo } })
    }
  },

  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getSysUserInfo()
  },
  beforeCreate() {}, //生命周期 - 创建之前
  beforeMount() {}, //生命周期 - 挂载之前
  beforeUpdate() {}, //生命周期 - 更新之前
  updated() {}, //生命周期 - 更新之后
  beforeDestroy() {}, //生命周期 - 销毁之前
  destroyed() {}, //生命周期 - 销毁完成
  activated() {} //如果页面有keep-alive缓存功能，这个函数会触发
}
</script>
<style src="../css/main.css" scoped>