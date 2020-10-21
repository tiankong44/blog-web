<!-- 智能推荐 -->
<template>
  <div class="">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>智能推荐</span>
        
      </div>
       <span id="blogList">
        <span v-for="(item, index) in blogList" :key="item.message">
          <hr class="opacity-tiny" />
          <el-badge :value="index + 1" class="item" :type="typeList[index]"></el-badge>
          <router-link class="recommend-text router-link-active" tag="a" :to="'/blog/' + item.id"  target="_blank">{{ item.title }}</router-link>
        </span>
      </span>
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
     getrecommend() {
      this.request
        .postJson(this.blogapi.getrecommend)
        .then((res) => {
          if (res.code == 0) {
            this.blogList = res.data.blogList
          } else {
          }
        })
        .catch((error) => {})
    },
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getrecommend()
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