<!-- 标签页 -->
<template>
  <div class="">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>标签</span>
        <el-button style="float: right; padding: 3px 0" type="text">more</el-button>
      </div>

      <el-button size="small" round v-for="tag in tagList" :key="tag.name" :type="colorArr[Math.floor(Math.random() * 6)]" @click="handleClick(tag.id)" style="margin-bottom:10px; ">{{ tag.name }}</el-button>

      <!-- <el-tag size="medium " color="#e8741c" effect="dark" hit="true" round v-for="tag in tagList" :key="tag.name" @click="handleClick(tag.id)">{{ tag.name }}</el-tag> -->
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
      tagList: {},
      colorArr: ['primary ', 'warning ', 'success ', 'danger', 'info']
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getTagList() {
      this.request
        .postJson(this.blogapi.getTagList)
        .then((res) => {
          if (res.code == 0) {
            this.tagList = res.data
          }
        })
        .catch((error) => {})
    },
    handleClick(id) {
      this.$emit('tagId', id)
      this.$emit('fatherMethod')
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getTagList()
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
<style>
</style>