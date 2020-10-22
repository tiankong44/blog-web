<!-- 智能推荐 -->
<template>
  <body background="static\images\email-pattern.png">
    <div class="">
      <headernav></headernav>
      <br />
      <el-button type="danger" @click="AA">aa</el-button>
      <el-row :gutter="30">
        <el-col :span="5"><div class="hide">111</div></el-col>
        <el-col :span="14">
          <el-card class="box-card">
            <div slot="header" class="blog-header">
              <span><img class="userHeadPic" :src="blog.avatar" /></span>

              <cite>
                <span class="userName">{{ blog.nickName }}</span>
              </cite>
              &emsp;
              <span>
                <i class="el-icon-date"></i>
                {{ blog.updateTime }}
              </span>
              &emsp;
              <span>
                <i class="el-icon-view"></i>
                {{ blog.views }}
              </span>
              <span class="pull-right">
                <el-button size="small" round v-for="tag in blog.tags" :key="tag.name" :type="colorArr[Math.floor(Math.random() * 6)]">
                  {{ tag.name }}
                </el-button>
              </span>
            </div>
            <div>
              <div class="pull-center"><img class="first-pic" :src="blog.firstPicture" alt="" /></div>
            </div>
            <br />
            <div class="blogpage-title">{{ blog.title }}</div>

            <div class="blogpage-content" v-html="blog.content"></div>
            <hr class="opacity-tiny" />
            <div align="center">
              <el-popover placement="right" width="400" trigger="hover">
                <el-tabs v-model="activeName" @tab-click="handleClick">
                  <el-tab-pane label="支付宝" name="alipay"><img class="reward-pic" src="static\images\alipay.jpg" alt="" /></el-tab-pane>
                  <el-tab-pane label="微信" name="wechat"><img class="reward-pic" src="static\images\wechat.png" alt="" /></el-tab-pane>
                </el-tabs>

                <el-button slot="reference" type="danger" round>赏</el-button>
              </el-popover>
              <el-button type="danger" round @click="praise(blog.id)">
                <i class="el-icon-thumb"></i>
                {{ blog.praise }}
              </el-button>
            </div>

            <hr class="opacity-tiny" />
            <div>
              <comment></comment>
            </div>
          </el-card>
        </el-col>
      </el-row>
      <el-backtop :right="80" :bottom="80"></el-backtop>

      <br />
      <br />
      <myfooter></myfooter>
    </div>
  </body>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import prism from '../../../static/lib/prism/prism.js'
import headernav from '@/components/front/nav'
import myfooter from '@/components/front/footer'
import comment from '@/components/front/comment'
import {mapGetters} from "vuex"
export default {
  //import引入的组件需要注入到对象中才能使用
  components: { headernav, myfooter, comment },
  data() {
    //这里存放数据
    return {
      blogId: '',
      blog: {},
      colorArr: ['primary ', 'warning ', 'success ', 'danger', 'info'],

      activeName: 'alipay'
    }
  },
  //监听属性 类似于data概念
  computed: { ...mapGetters(['getTitle']) },
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    blogDetail() {
      let param = { id: this.blogId }
      this.request
        .postJson(this.blogapi.getBlogDetail, param)
        .then((res) => {
          if (res.code == 0) {
            this.blog = res.data
            this.timer = setTimeout(() => {
              prism.highlightAll() // 这里加定时器让它后执行，不然没效果
            }, 0)
          }
        })
        .catch((error) => {})
    },
    handleClick(tab, event) {},
    AA(){
      console.log(this.getTitle)
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.blogId = this.$route.params.id
    this.blogDetail()
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
<style scoped>
@import '../css/main.css';
@import '../../../static/lib/prism/prism.css';
</style>