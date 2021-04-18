<!-- 新增或修改博客页面 -->
<template>
  <div class="">
    <el-row>
      <el-col :span="1"><div class="hide">11</div></el-col>
      <el-col :span="22">
        <br />
        <h2 style="color: #3fb8af" class="pull-center">{{ albumName }}</h2>
        <div v-if="album.length == 0" class="pull-center">
          <div style="margin: 60px 20px 100px 20px"><i class="el-icon-document-delete pull-center big-icon"></i></div>

          <h3 style="margin: 40px 40px 40px 40px" class="pull-center">什么都没有哦！</h3>
        </div>
        <div v-for="(images, index) in album" :key="index">
          <h3 style="padding-top: 10px">{{ images.createTime }}</h3>

          <viewer :images="images.photos">
            <template v-for="(image, index) in images.photos">
              <img :src="image.path" class="image-album" :key="index" :data-src="image.path" />
            </template>
          </viewer>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'
export default {
  //import引入的组件需要注入到对象中才能使用
  props: ['albumId'],
  components: {},
  data() {
    //这里存放数据
    return {
      albumName: '',
      album: {}
      // albumId: ''
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    albumDetail() {
      let param = {
        albumId: this.albumId
      }
      this.request
        .postJson(this.blogapi.albumDetail, param)
        .then((res) => {
          if (res.code == 0) {
            this.album = res.data.data
            console.log(this.album)
            this.albumName = res.data.albumName
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    // this.albumId = this.$route.query.albumId
    this.albumDetail()
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
@import '../../css/main.css';
</style>