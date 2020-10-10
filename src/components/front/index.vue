<!-- 展示首页 -->
<template>
  <body background="static\images\email-pattern.png">
    <div class="">
      <headernav @title="getTitle" @fatherMethod="getblogList()"></headernav>
      <br />
      <el-row :gutter="30">
        <el-col :span="5"><div class="hide">111</div></el-col>
        <el-col :span="11">
          <blogList :blogList="blogList" :tagId="tagId"></blogList>
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
                  <span class="green-text">{{page.pageNum}}</span>
                  页，总
                  <span class="green-text">{{page.size}}</span>
                  页，共
                  <span class="green-text">{{page.total}}</span>
                  条记录
                </p>
              </span>
            </div>
          </div>
        </el-col>
        <el-col :span="5">
          <weather></weather>
          <br />
          <br />
          <br />
          <tagCard @tagId="getTagId" @fatherMethod="getblogList()"></tagCard>
          <br />
          <br />
          <br />
          <leaderboard></leaderboard>
          <br />
          <br />
          <br />
          <intelligentRecommend></intelligentRecommend>
        </el-col>
      </el-row>
      <br />
      <br />
      <myfooter></myfooter>
    </div>
  </body>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import headernav from '@/components/front/nav'
import blogList from '@/components/front/blogList'
import tagCard from '@/components/front/tagCard'
import leaderboard from '@/components/front/leaderboard'
import intelligentRecommend from '@/components/front/intelligentRecommend'
import myfooter from '@/components/front/footer'
import weather from '@/components/front/weather'
import { _tiper } from '@/common/utils/ui.js'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: {
    headernav,
    blogList,
    tagCard,
    leaderboard,
    intelligentRecommend,
    myfooter,
    weather
  },
  data() {
    //这里存放数据
    return {
      title: '',
      tagId: 0,
      page: {
        prePage: 0,
        pageNum: 1,
        nextPage: 2,
        pageSize: 8,
        size: 0,
        total: 0
      },
      blogList: {}
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getTitle(title) {
      this.title = title
    },
    getTagId(tagId) {
      this.tagId = tagId
    },
    getblogList() {
      let param = {
        title: this.title,
        tagId: this.tagId,
        pageNum: this.page.pageNum,
        pageSize: this.page.pageSize
      }
      this.request
        .postJson(this.blogapi.getBlogList, param)
        .then((res) => {
          if (res.code == 0) {
            this.blogList = res.data.list
            this.page.pageNum = res.data.pageNum
            this.page.total = res.data.total
            this.page.prePage = res.data.prePage
            this.page.nextPage = res.data.nextPage
            this.page.size = res.data.pages
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
        this.getblogList()
        this.backTop()
      }
    },
    prePage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = this.page.prePage
        this.getblogList()
        this.backTop()
      }
    },
    nextPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.nextPage
        this.getblogList()
        this.backTop()
      }
    },
    lastPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.size
        this.getblogList()
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
    this.getblogList()
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
</style>