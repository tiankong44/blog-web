<!--  -->
<template>
  <body background="static\images\email-pattern.png">
    <div class="">
      <el-row :gutter="30">
        <el-col :span="6"><div class="hide">111</div></el-col>
        <el-col :span="13">
          <!-- <h2 align="center" style="color: #3fb8af; padding-top: 10px">关于我</h2> -->

          <el-card class="box-card">
            <div slot="header" class="clearfix">
              <h3 style="color: #3fb8af; padding-top: 10px" class="pull-center">个人资料</h3>
            </div>
            <div>
              <el-row>
                <el-col :span="2">
                  <div class="hide">111</div>
                </el-col>
                <el-col :span="4">
                  <div>
                    <el-avatar shape="square" :size="160" :src="userInfo.avatar"></el-avatar>
                    <br />

                    <!-- <el-button type="text" @click="dialogVisible = true">修改头像</el-button> -->
                    <div class="pull-center changeAvatar-text">
                      <el-button type="text" @click="dialogVisible = true">修改头像</el-button>
                    </div>

                    <el-dialog title="头像上传" :visible.sync="dialogVisible" width="30%">
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
                      <!-- <div class="pull-center">
                        <el-button style="margin-left: 10px;" size="small" type="primary" @click="submitUpload">确定</el-button>
                     </div> -->

                      <span slot="footer" class="dialog-footer">
                        <el-button @click="dialogVisible = false">取 消</el-button>
                        <el-button type="primary" @click="submitUpload">确 定</el-button>
                      </span>
                    </el-dialog>
                  </div>
                </el-col>
                <el-col :span="1">
                  <div class="hide">111</div>
                </el-col>
                <el-col :span="15">
                  <el-form :label-position="labelPosition" label-width="80px">
                    <el-form-item label="用户名">
                      <div class="">{{ userInfo.username }}</div>
                    </el-form-item>
                    <el-form-item label="邮箱">
                      <div class="">{{ userInfo.email }}</div>
                    </el-form-item>
                    <el-form-item label="昵称">
                      <div class="">{{ userInfo.nickName }}</div>
                    </el-form-item>
                    <el-form-item label="性别">
                      <div class="" v-if="userInfo.sex == 1">男</div>
                      <div class="" v-else>女</div>
                    </el-form-item>
                    <el-form-item label="年龄">
                      <div class="">{{ userInfo.age }}</div>
                    </el-form-item>
                    <el-form-item label="生日">
                      <div class="">{{ userInfo.birthDay }}</div>
                    </el-form-item>
                    <el-form-item label="介绍">
                      <div class="">{{ userInfo.introduction }}</div>
                    </el-form-item>
                  </el-form>
                </el-col>
              </el-row>
            </div>
            <el-divider></el-divider>
            <div>
              <h3 style="color: #3fb8af; padding-top: 10px" class="pull-center">我的技能</h3>
              <br />
              <div class="pull-center">
                <span v-for="skill in userInfo.skills" :key="skill.skillId" style="margin: padding-right: 10px">
                  <div class="skill-text" :style="{ color: customColors[Math.floor(Math.random() * 20)] }">{{ skill.skillName }}</div>
                  <br />
                  <div class="pull-center">
                    <el-progress type="circle" :percentage="skill.percentage" :stroke-width="strokeWidth" :color="customColors[Math.floor(Math.random() * 20)]" :width="circelWidth"></el-progress>
                  </div>
                </span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
      <myfooter></myfooter>
    </div>
  </body>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'
import myfooter from '@/components/front/footer'

export default {
  //import引入的组件需要注入到对象中才能使用
  components: { myfooter },
  data() {
    //这里存放数据
    return {
      customColors: [
        '#1c97f5',
        '#e8741c',
        '#73685f',
        '#27e146',
        '#b627e1',
        '#102cba',
        '#ed135c',
        '#ed3013',
        '#0b1441',
        '#8e9ad6',
        '#988d2d',
        '#39541b',
        '#082E54',
        '#A066D3',
        '#2E8B57',
        '#191970',
        '#696969',
        '#FF8C00',
        '#808000',
        '#008080'
      ],
      userInfo: {},
      labelPosition: 'right',
      strokeWidth: 20,
      textInsid: true,
      showText: true,
      circelWidth: 120,
      dialogVisible: false,
      url: this.blogapi.avatarUpload,
      fileList: []
    }
  },
  //监听属性 类似于data概念
  computed: {
    // 这里定义上传文件时携带的参数，即表单数据
  },
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    getUserInfo() {
      if (this.userInfo != null) {
        this.request
          .postJson(this.blogapi.getUserInfo)
          .then((res) => {
            if (res.code == 0) {
              this.userInfo = res.data
            } else {
              _tiper.warn(res.desc)
            }
          })
          .catch((error) => {})
      } else {
        _tiper.warn('请先登录！')
      }
    },
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
      if (res.code == 0) {
        _tiper.success(res.desc)
        this.wait(500)
        this.fileList = []
        this.dialogVisible = false
        this.getUserInfo()
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
  created() {
    this.getUserInfo()
  },
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
<style src="../css/main.css" scoped>