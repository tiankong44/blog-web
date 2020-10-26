<!--  -->
<template>
  <div class="block">
    <br />
    <br />
    <el-row :gutter="30">
      <el-col :span="6"><div class="hide">111</div></el-col>
      <el-col :span="11">
        <el-timeline>
          <el-timeline-item :timestamp="blog.date" placement="top" v-for="blog in blogMap" :key="blog.id">
            <el-card>
              <div v-for="(item,index) in blog.list" :key="item.id">
                <el-card :body-style="bodyStyle">
                  <h4>{{ item.title }}</h4>
                  <p>{{ item.user.nickname }} 更新于 {{ item.updateTime }}</p>
                </el-card>
                <br v-if="blog.list.length > 1 " />
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </el-col>
    </el-row>
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
      blogMap: {},
      blogList: {},
      bodyStyle: { 'background-color': '#f5f7fd' }
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getBlogMap() {
      this.request
        .postJson(this.blogapi.getBlogMap)
        .then((res) => {
          if (res.code == 0) {
            this.blogMap = res.data
          }
        })
        .catch((error) => {})
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