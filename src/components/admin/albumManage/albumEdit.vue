<!-- 新增或修改博客页面 -->
<template>
  <div class="">
    <el-row>
      <el-col :span="3"><div class="hide">11</div></el-col>
      <el-col :span="18">
        <div class="breadCrumbs">
          <!-- <br />
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/blogManagement' }">列表</el-breadcrumb-item>
            <el-breadcrumb-item><a href="/blogEdit" style="cursor: pointer">发布</a></el-breadcrumb-item>
          </el-breadcrumb> -->
        </div>
        <br />

        <el-form ref="form" label-width="80px" size="large" :rules="rules" :model="form">
          <el-form-item label="相册名" prop="albumName">
            <el-input placeholder="相册名" v-model="form.albumName">
              <!-- <template slot="prepend">标题</template> -->
            </el-input>
          </el-form-item>
          <br />
          <el-form-item label="主图">
            <el-input placeholder="主图地址" v-model="form.mainPicture"></el-input>
          </el-form-item>
          <br />
          <el-form-item label="">
            <div class="pull-center">
              <el-upload
                class="upload-demo"
                drag
                ref="upload"
                :action="url"
                :on-preview="handlePreview"
                :on-remove="handleRemove"
                :auto-upload="false"
                :multiple="false"
                :file-list="fileList"
                :on-success="onSuccess"
                :on-error="onError"
                :before-upload="beforeUpload"
                :limit="1"
                accept=".jpg,.png"
              >
                <i class="el-icon-upload"></i>
                <div class="el-upload__text">
                  将文件拖到此处，或
                  <em>点击上传</em>
                </div>
                <div class="el-upload__tip" slot="tip">只能上传jpg/png文件</div>
              </el-upload>
            </div>
            <el-button type="primary" class="pull-right" @click="submitUpload">确 定</el-button>
          </el-form-item>
          <br />

          <el-form-item label="备注">
            <el-input type="textarea" :autosize="{ minRows: 3, maxRows: 10 }" placeholder="备注" v-model="form.remark"><template slot="prepend">备注</template></el-input>
          </el-form-item>
          <br />
          <el-form-item label="类型">
            <el-radio v-model="form.type" label="1">公开</el-radio>
            <el-radio v-model="form.type" label="2">私有</el-radio>
          </el-form-item>
          <br />
          <el-button type="success" class="pull-right" @click="submitForm(form)">提交</el-button>
        </el-form>
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
      rules: {
        albumName: [{ required: true, message: '相册名不能为空！', trigger: 'blur' }]
      },
      form: {
        albumName: '',
        mainPicture: '',
        type: '2',
        remark: ''
      },

      userVo: {},
      url: this.blogapi.mainPictureUpload,
      fileList: [],
      dialogTableVisible: false
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
        .postJson(this.blogapi.justAlbumDetail, param)
        .then((res) => {
          if (res.code == 0) {
            this.form.albumName = res.data.albumName
            this.form.mainPicture = res.data.mainPicture
            this.form.type = res.data.type
            this.form.remark = res.data.remark
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },
    submitForm() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.addAlbum()
        } else {
          _tiper.error('新增相册失败')
        }
      })
    },

    updateAlbum() {
      let param = {
        albumName: this.form.albumName,
        mainPicture: this.form.mainPicture,
        remark: this.form.remark,
        type: this.form.type
      }

      this.request
        .postJson(this.blogapi.albumAdd, param)
        .then((res) => {
          if (res.code == 0) {
            this.$emit('fatherMethod', this.dialogTableVisible)
            _tiper.success(res.desc)
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },

    //文件上传
    submitUpload() {
      this.$refs.upload.submit()
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
    handlePreview(file) {},
    onSuccess(res) {
      console.log('成功')
      if (res.code == 0) {
        _tiper.success(res.desc)
        this.form.mainPicture = res.data.path

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
  },
  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
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