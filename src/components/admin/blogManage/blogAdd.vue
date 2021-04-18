<!-- 新增或修改博客页面 -->
<template>
  <div class="">
    <el-row>
      <el-col :span="3"><div class="hide">11</div></el-col>
      <el-col :span="18">
        <div class="breadCrumbs">
          <br />
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/blogManagement' }">列表</el-breadcrumb-item>
            <el-breadcrumb-item><a href="/blogEdit" style="cursor: pointer">发布</a></el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <br />

        <el-form ref="form" label-width="80px" size="large" :rules="rules" :model="form">
          <el-form-item label="标题" prop="title">
            <el-input placeholder="标题" v-model="form.title" >
              <!-- <template slot="prepend">标题</template> -->
            </el-input>
          </el-form-item>
          <br />
          <el-form-item label="首图">
            <el-input placeholder="首图地址" v-model="form.firstPic"></el-input>
          </el-form-item>
          <br />
          <el-form-item label="正文" prop="content">
            <mavon-editor v-model="form.content" :ishljs="true" placeholder="在此编辑正文..." :navigation="true" :toolbars="toolbars" @imgAdd="handleEditorImgAdd" ref="md"></mavon-editor>
          </el-form-item>
          <br />

          <el-form-item label="描述" prop="description">
            <el-input type="textarea" :autosize="{ minRows: 3, maxRows: 10 }" placeholder="添加描述" v-model="form.description"><template slot="prepend">描述</template></el-input>
          </el-form-item>

          <br />
          <el-form-item label="标签" prop="tagValues">
            <el-select v-model="form.tagValues" multiple placeholder="请选择" style="width: 200px" size="medium" multiple-limit="3" filterable allow-create default-first-option>
              <el-option v-for="tag in tags" :key="tag.value" :label="tag.label" :value="tag.value"></el-option>
            </el-select>
          </el-form-item>
          <br />
          <el-form-item label="功能">
            <el-switch v-model="form.appreciation" active-text="赞赏" inactive-text=""></el-switch>
            <el-switch v-model="form.commentabled" active-text="评论" inactive-text=""></el-switch>
            <el-switch v-model="form.published" active-text="发布" inactive-text=""></el-switch>
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
  components: {},
  data() {
    //这里存放数据
    return {
      rules: {
        title: [{ required: true, message: '文章标题不能为空！', trigger: 'blur' }],
        description: [{ required: true, message: '请添加描述', trigger: 'blur' }],
        content: [{ required: true, message: '请添加正文内容', trigger: 'blur' }],
        tagValues: [{ required: true, message: '请至少选择一个标签', trigger: 'change' }]
      },
      form: {
        title: '',
        firstPic: '',
        description: '',
        content: '',
        appreciation: true,
        commentabled: true,
        published: true,
        tagValues: []
      },

      tags: [],

      userVo: {},
      toolbars: {
        bold: true, // 粗体
        italic: true, // 斜体
        header: true, // 标题
        underline: true, // 下划线
        strikethrough: true, // 中划线
        mark: true, // 标记
        superscript: true, // 上角标
        subscript: true, // 下角标
        quote: true, // 引用
        ol: true, // 有序列表
        ul: true, // 无序列表
        link: true, // 链接
        imagelink: true, // 图片链接
        code: true, // code
        table: true, // 表格
        fullscreen: true, // 全屏编辑
        readmodel: true, // 沉浸式阅读
        htmlcode: true, // 展示html源码
        help: true, // 帮助
        /* 1.3.5 */
        undo: true, // 上一步
        redo: true, // 下一步
        trash: true, // 清空
        save: false, // 保存（触发events中的save事件）
        /* 1.4.2 */
        navigation: true, // 导航目录
        /* 2.1.8 */
        alignleft: true, // 左对齐
        aligncenter: true, // 居中
        alignright: true, // 右对齐
        /* 2.2.1 */
        subfield: true, // 单双栏模式
        preview: true // 预览
      }
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
        .postJson(this.blogapi.getTagsByUserId)
        .then((res) => {
          if (res.code == 0) {
            this.tags = res.data
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },

    submitForm() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.publish()
        } else {
          _tiper.error('文章发布失败')
        }
      })
    },

    publish() {
      let ids = ''
      for (let index = 0; index < this.form.tagValues.length; index++) {
        ids = ids + this.form.tagValues[index] + ','
        // const element = array[index]
      }
      if (ids.length > 0) {
        ids = ids.substring(0, ids.length - 1)
      }
      let param = {
        title: this.form.title,
        firstPic: this.form.firstPic,
        content: this.form.content,
        description: this.form.description,
        tagIds: ids,
        published: this.form.published,
        commentabled: this.form.commentabled,
        appreciation: this.form.appreciation
      }

      this.request
        .postJson(this.blogapi.saveBlog, param)
        .then((res) => {
          if (res.code == 0) {
            this.$router.push('/blogManagement')
            _tiper.success(res.desc)
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },

    handleEditorImgAdd(pos, $file) {
      var formData = new FormData()
      formData.append('files', $file)
      var _this = this
      // 第一步.将图片上传到服务器.
      // var formdata = new FormData()
      // formdata.append('image', $file)
      this.request.postJson(this.blogapi.uploadToGallery, formData).then((res) => {
        var url = res.data //取出上传成功后的url
        if (res.code == 0) {
          //  _this.$refs.md.$imgUpdateByUrl(pos, json.msg)
          _this.$refs.md.$imglst2Url([[pos, url]])
          _tiper.success(res.desc)
        } else {
          _tiper.error(res.desc)
        }
      })
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
<style scoped>
@import '../../css/main.css';
</style>