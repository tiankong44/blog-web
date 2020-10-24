<!-- 导航栏 -->
<template>
  <div class="">
    <div class="header">
      <el-row class="" :gutter="10">
        <el-menu :default-active="activeIndex" :default-openeds="['1']" class="el-menu-demo header-padding" mode="horizontal" @select="handleSelect" background-color="#000000" text-color="#fff" active-text-color="#0FD03F">
          <el-col :span="5">
            <div class="location-center hide">111</div>
          </el-col>

          <el-menu-item index="index" class="header-text">首页</el-menu-item>

          <el-menu-item index="tag" class="header-text">标签</el-menu-item>

          <el-menu-item index="archive" class="header-text">归档</el-menu-item>

          <el-menu-item index="4" class="header-text">相册</el-menu-item>

          <el-menu-item index="5" class="header-text">关于我</el-menu-item>
          <el-col :span="2">
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
export default {
  //import引入的组件需要注入到对象中才能使用
  components: { searchResult },
  data() {
    //这里存放数据
    return { activeIndex:"index",title: '', homeSrc: '/index', config: { index: '/index', tag: '/tag', archive: '/archive' }, isShow: false }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
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
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    // this.$router.push(this.homeSrc)
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