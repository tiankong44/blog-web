<!--  -->
<template>
  <div class="">
    <div>
      <div class="pull-center">
        <el-upload
          class="upload-demo"
          drag
          ref="upload"
          :action="url"
          :on-preview="handlePreview"
          :on-remove="handleRemove"
          :auto-upload="false"
          :multiple="true"
          :file-list="fileList"
          :on-success="onSuccess"
          :on-error="onError"
          :before-upload="beforeUpload"
          accept="image/*"
        >
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">
            将文件拖到此处，或
            <em>点击上传</em>
          </div>
          <div class="el-upload__tip" slot="tip">只能上传jpg/png文件</div>
        </el-upload>
      </div>
      <br />
      <div class="el-upload__tip" slot="tip" v-if="percentShow">
        <div style="color: red">*图片上传中，请耐心等待！</div>
        <el-progress :text-inside="true" :stroke-width="24" :percentage="percent" status="success"></el-progress>
      </div>
      <br />
      <div><el-button type="primary" class="pull-right" @click="submitUpload">确 定</el-button></div>
    </div>
    <br />
    <br />
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'
import axios from 'axios'
export default {
  //import引入的组件需要注入到对象中才能使用
  props: ['albumId'],
  components: { axios },
  data() {
    //这里存放数据
    return {
      fileList: [],
      url: this.blogapi.albumPhotosUpload,
      percent: 0,
      percentShow: false
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    //文件上传
    submitUpload() {
      this.percentShow = true
      // console.log(this.albumId)
      // this.$refs.upload.submit()
      let { uploadFiles } = this.$refs.upload
      let form = new FormData()
      uploadFiles.forEach((item) => {
        form.append('files', item.raw)
      })
      form.append('albumId', this.albumId)
      // this.request
      //   .postJson(this.blogapi.albumPhotosUpload, form)
      //   .then((res) => {
      //     if (res.code == 0) {
      //       _tiper.success(res.desc)
      //       this.$emit('fatherMethod', this.dialogTableVisible)
      //     } else if (res.code == 1) {
      //       _tiper.error(res.desc)
      //     }
      //   })
      //   .catch((error) => {})

      axios
        .post(this.blogapi.albumPhotosUpload, form, {
          headers: {
            'Content-Type': 'multipart/form-data'
          },
          onUploadProgress: (progressEvent) => {
            if (progressEvent.lengthComputable) {
              var complete = ((progressEvent.loaded / progressEvent.total) * 100) | 0
              this.percent = complete

              if (complete >= 100) {
                // this.percentShow = false
                // this.percent = 0 // 重新置0
              }
            }
          }
        })
        .then((res) => {
          console.log(res.data)
          if (res.data.code == 0) {
            this.percentShow = false
            _tiper.success(res.data.desc)
            this.$emit('fatherMethod', this.dialogTableVisible)
          } else if (res.data.code == 1) {
            _tiper.error(res.data.desc)
          }
        })
    },
    beforeUpload(file) {
      var testmsg = file.name.substring(file.name.lastIndexOf('.') + 1)
      const extension = testmsg === 'jpg'
      const extension2 = testmsg === 'png'
      if (!extension && !extension2) {
        _tiper.error('上传文件只能是 jpg、png格式!')
      }
      return extension || extension2
    },
    handleRemove(file, fileList) {
      // _tiper.error('已取消上传改文件')
    },
    handlePreview(file) {
      console.log(file)
    },
    onSuccess(res) {
      console.log('成功')
      if (res.code == 0) {
        _tiper.success(res.desc)

        // this.dialogVisible = false
      }
    },
    onError(err) {
      if (err.code != 0) {
        _tiper.error(res.desc)
      }
    },
    wait(ms) {
      var start = new Date().getTime()
      var end = start
      while (end < start + ms) {
        end = new Date().getTime()
      }
    }
    // getData() {
    //   return {
    //     albumId: this.albumId
    //   }
    // }
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {},
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