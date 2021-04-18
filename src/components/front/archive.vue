<!--  -->
<template>
  <body background="static\images\email-pattern.png">
    <div class="block">
      <br />
      <br />
      <el-row :gutter="30">
        <el-col :span="6"><div class="hide">111</div></el-col>
        <el-col :span="11">
          <el-timeline>
            <el-timeline-item :timestamp="blog.date" placement="top" v-for="blog in blogMap.data" :key="blog.id">
              <el-card>
                <div v-for="item in blog.list" :key="item.id">
                  <el-card :body-style="bodyStyle">
                    <router-link class="blog-title" :to="{ name: 'blogDetail', params: { id: item.id } }">
                      <h6 style="margin: -1px 0px -2px 0px">{{ item.title }}</h6>
                    </router-link>
                    <!-- <h4>{{ item.title }}</h4>  -->
                    <p style="margin: 16px 0px -3px 0px">{{ item.user.nickname }} 更新于 {{ item.updateTime }}</p>
                  </el-card>
                  <br v-if="blog.list.length > 1" />
                </div>
              </el-card>
            </el-timeline-item>
          </el-timeline>
          <div align="center">
            <el-button-group>
              <el-button v-on:click="firstPage()">首页</el-button>
              <el-button icon="el-icon-arrow-left" v-on:click="prePage()">上一页</el-button>
              <el-button v-on:click="nextPage()">
                下一页
                <i class="el-icon-arrow-right el-icon--right"></i>
              </el-button>

              <el-button v-on:click="lastPage()" class="lastPage">尾页</el-button>
            </el-button-group>
            <div align="center" style="font-size: 15px; opacity: 0.7">
              <span>
                <p>
                  当前第
                  <span class="green-text">{{ page.pageNum }}</span>
                  页，总
                  <span class="green-text">{{ page.size }}</span>
                  页，共
                  <span class="green-text">{{ page.total }}</span>
                  条记录
                </p>
              </span>
            </div>
          </div>
          <el-backtop :right="80" :bottom="80"></el-backtop>
        </el-col>
      </el-row>
    </div>
  </body>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    //这里存放数据
    return {
      blogMap: {},
      blogList: {},
      bodyStyle: { 'background-color': '#f5f7fd' },
      page: {
        prePage: 0,
        pageNum: 1,
        nextPage: 2,
        pageSize: 10,
        size: 0,
        total: 0
      }
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getBlogMap() {
      let param = {
        pageNum: this.page.pageNum,
        pageSize: this.page.pageSize
      }
      this.request
        .postJson(this.blogapi.getBlogMap, param)
        .then((res) => {
          if (res.code == 0) {
            this.blogMap = res.data
            this.page.pageNum = res.data.pageInfo.pageNum
            this.page.total = res.data.pageInfo.total
            this.page.prePage = res.data.pageInfo.prePage
            this.page.nextPage = res.data.pageInfo.nextPage
            this.page.size = res.data.pageInfo.pages
            this.backTop()
          }
        })
        .catch((error) => {})
    },
    firstPage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = 1
        this.getBlogMap()
        this.backTop()
      }
    },
    prePage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = this.page.prePage
        this.getBlogMap()
        this.backTop()
      }
    },
    nextPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.nextPage
        this.getBlogMap()
        this.backTop()
      }
    },
    lastPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.size
        this.getBlogMap()
        this.backTop()
      }
    },
    backTop() {
      document.body.scrollTop = 0
      document.documentElement.scrollTop = 0
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getBlogMap()
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