<!-- 导航栏 -->
<template>
  <div class="">
    <div class="header">
      <el-row class="" :gutter="10">
        <el-menu class="el-menu-demo header-padding" mode="horizontal" @select="handleSelect" background-color="#000000" text-color="#fff" active-text-color="#0FD03F">
          <el-col :span="5">
            <div class="location-center hide">111</div>
          </el-col>

          <el-menu-item index="index" class="header-text">首页</el-menu-item>

          <el-menu-item index="tag" class="header-text">标签</el-menu-item>

          <el-menu-item index="archive" class="header-text">归档</el-menu-item>

          <!-- <el-menu-item index="album" class="header-text">相册</el-menu-item> -->

          <!-- <el-menu-item index="about" class="header-text">关于我</el-menu-item> -->
          <el-col :span="4">
            <div class="hide">1</div>
          </el-col>
          <el-col :span="3">
            <el-input placeholder="请输入内容" size="small" v-model="title" style="padding-top: 12px" @keyup.enter.native="search">
              <i slot="prefix" style="padding-top: 8px" class="el-input__icon el-icon-search"></i>
            </el-input>
          </el-col>
          <el-col :span="1">
            <div style="padding-top: 10px">
              <el-button type="success" icon="el-icon-search" size="small" @click="search">搜索</el-button>
            </div>
          </el-col>

          <el-submenu class="nav-user-avatar" index="user" v-if="userVo != null">
            <template slot="title">
              <el-avatar :src="userVo.avatar"></el-avatar>
              {{ userVo.nickname }}
            </template>

            <el-menu-item index="personalInformation" @click="toPersonalInformation">个人资料</el-menu-item>
            <el-menu-item index="admin" @click="toAdmin">后台管理</el-menu-item>
            <el-menu-item index="logout" @click="logout">退出</el-menu-item>
          </el-submenu>

          <el-menu-item index="login" class="nav-user-text" @click="toLogin" v-if="userVo == null">请登录</el-menu-item>
        </el-menu>
        <!-- <keep-alive> -->
        <searchResult v-if="isShow" :title="title" ref="child" @fatherMethod="closeSearch()"></searchResult>
        <router-view :key="$route.title" v-if="!isShow" />
        <!-- </keep-alive> -->
      </el-row>
    </div>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import searchResult from '@/components/front/searchResult'
import { mapGetters } from 'vuex'
import { _tiper } from '@/common/utils/ui.js'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: { searchResult },
  data() {
    //这里存放数据
    // return { title: '', homeSrc: '/index', config: { index: '/index', tag: '/tag', archive: '/archive', album: '/album', about: '/about' }, isShow: false, userVo: {} }
    return { title: '', homeSrc: '/index', config: { index: '/index', tag: '/tag', archive: '/archive' }, isShow: false, userVo: {} }
  },
  //监听属性 类似于data概念
  computed: {
    ...mapGetters(['getUsername'])
  },
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

    handleSelect(key, keyPath) {
      this.isShow = false
      this.$router.push(this.config[key])
    },
    search() {
      this.$store.commit('setTitle', this.title)
      console.log(this.title)
      //  this.isShow = false
      this.isShow = true
      this.timer = setTimeout(() => {
        this.$refs.child.getblogList()
      }, 0)

      // this.$emit('title', this.title)
      // this.$emit('fatherMethod')
    },
    closeSearch() {
      this.isShow = false
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
    toPersonalInformation() {
      this.$router.push({ path: '/about' })
    },
    toAdmin(){
      this.$router.push({ path: '/admin' })
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