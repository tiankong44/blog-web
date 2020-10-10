<!-- 排行榜 -->
<template>
  <div class="">
    <el-card class="box-card tiny-text">
      <div class="weathery">
        <!--                        <iframe scrolling="no" src="https://tianqiapi.com/api.php?style=ya&skin=pitaya" width="100%"-->
        <!--                                frameborder="0" allowtransparency="true"></iframe>-->
        <iframe scrolling="no" src="https://tianqiapi.com/api.php?style=tp&skin=pitaya" width="100%" frameborder="0" allowtransparency="true" height="260"></iframe>
      </div>
    </el-card>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';

export default {
  //import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    //这里存放数据
    return {
      value: 1,
      blogList: {},
      typeList: ['danger', 'warning', 'primary', 'success', 'info'],
      type: 'primary'
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getNewFiveBlog() {
      this.request
        .postJson(this.blogapi.getNewFiveBlog)
        .then((res) => {
          console.log(res.code)
          if (res.code == 0) {
            this.blogList = res.data.blogList
          } else {
          }
        })
        .catch((error) => {})
    },
    getNewFiveCommentBlog() {
      this.request
        .postJson(this.blogapi.getNewFiveCommentBlog)
        .then((res) => {
          if (res.code == 0) {
            this.blogList = res.data.blogList
          }
        })
        .catch((error) => {})
    },
    getTopFiveViewBlog() {
      this.request
        .postJson(this.blogapi.getTopFiveViewBlog)
        .then((res) => {
          if (res.code == 0) {
            this.blogList = res.data.blogList
          }
        })
        .catch((error) => {})
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getNewFiveBlog()
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