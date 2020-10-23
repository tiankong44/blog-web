<!-- 博客列表 -->
<template>
  <div class="">
    <div v-for="item in blogList" :key="item.id">
      <el-card class="box-card">
        <!-- <el-link target="_blank" @click="blogDetail(item.id)" class="my-link" :underline="false">
          <div class="blog-title">{{ item.title }}</div>
        </el-link> -->
        <router-link class="blog-title" :to="{ name: 'blogDetail', params: { id: item.id } }">
          <div class="blog-title">{{ item.title }}</div>
        </router-link>

        <el-row>
          <el-col :span="16">
            <div class="precontent-opacity">{{ item.description }}</div>
          </el-col>
          <el-col :span="8"><img class="pic-index" alt="" :src="'' + item.firstPicture" /></el-col>
        </el-row>
        <hr class="opacity-tiny" />
        <div class="opacity-min">
          <span>
            <!-- <el-avatar :src="'' + item.user.avatar" :size="20"></el-avatar> -->
          </span>
          <span>
            <i class="el-icon-user"></i>
            <cite>
              {{ item.user.nickname }}
            </cite>
          </span>
          &emsp;
          <span>
            <i class="el-icon-price-tag">
              <span v-for="tag in item.tags" :key="tag.id">{{ tag.name }}&nbsp;</span>
            </i>
          </span>
          &emsp;
          <span>
            <i class="el-icon-date"></i>
            {{ item.updateTime }}
          </span>
          &emsp;
          <span>
            <i class="el-icon-view"></i>
            {{ item.views }}
          </span>
          <span>
            <router-link class="pull-right" :to="{ name: 'blogDetail', params: { id: item.id } }">
              <el-button size="mini">阅读全文</el-button>
            </router-link>
          </span>
        </div>
      </el-card>
      <br />
    </div>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'

export default {
  //import引入的组件需要注入到对象中才能使用
  components: {},
  props: ['blogList'],
  data() {
    //这里存放数据
    return {
      page: {
        prePage: 0,
        pageNum: 1,
        nextPage: 2,
        pageSize: 8,
        size: 0,
        total: 0
      },
      tags: {}
      // blogList: {}
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    setTags() {
      this.tags = this.blogList.tags
    },
    blogDetail(id) {
      this.$router.push({ path: '/blog', params: { id: id } })
      // let routeData = this.$router.resolve({ path: '/blog', query: {  id: 1 } });
      // window.open(routeData.href, '_blank');
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    // this.getblogList()
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