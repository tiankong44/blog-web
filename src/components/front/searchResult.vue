<!-- 博客列表 -->
<template>
 <body background="static\images\email-pattern.png">
  <div class="">
    <br />
    <br />
    <el-row :gutter="30">
      <el-col :span="6"><div class="hide">111</div></el-col>
      <el-col :span="11">
        <div v-for="item in blogList" :key="item.id">
          <el-card class="box-card">
            <!-- <el-link target="_blank" @click="blogDetail(item.id)" class="my-link" :underline="false">
          <div class="blog-title">{{ item.title }}</div>
        </el-link> -->
            <router-link class="blog-title" :to="{ name: 'blogDetail', params: { id: item.id } }" >
              <div class="blog-title"  @click="closeSearch()">{{ item.title }}</div>
            </router-link>

            <el-row>
              <el-col :span="16">
                <div class="precontent-opacity">{{ item.description }}</div>
              </el-col>
              <el-col :span="8"><img v-image-preview class="pic-index" alt="" :src="'' + item.firstPicture" /></el-col>
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
                  <el-button size="mini"  @click="closeSearch()">阅读全文</el-button>
                </router-link>
              </span>
            </div>
          </el-card>
          <br />
        </div>
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
      </el-col>
    </el-row>
     <el-backtop :right="80" :bottom="80"></el-backtop>
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
  props: ['title'],
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
      tags: {},
      blogList: {}
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
    },
    getblogList() {
      let param = {
        title: this.title,
        tagId: 0,
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
    },
    closeSearch(){
   
          this.$emit('fatherMethod')
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