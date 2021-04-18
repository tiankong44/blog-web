<!-- 新增或修改博客页面 -->
<template>
  <div class="">
    <el-dialog :visible.sync="showPhotoUpload" center width="60%" v-if="showPhotoUpload == true">
      <uploadImage :albumId="albumId" @fatherMethod="closeUploadDialog"></uploadImage>
    </el-dialog>
    <el-row :gutter="10">
      <el-col :span="1"><div class="hide">11</div></el-col>
      <el-col :span="22">
        <el-row :gutter="10">
          <br />
          <el-col :span="9">
            <span>上传时间</span>
            <el-date-picker
              v-model="date"
              type="daterange"
              align="right"
              unlink-panels
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="yyyy-MM-dd"
              :picker-options="pickerOptions"
            ></el-date-picker>
          </el-col>

          <el-col :span="2">
            <el-button type="success" icon="el-icon-search" size="medium" @click="albumDetail()">搜索</el-button>
          </el-col>
          <el-col :span="4"><div class="hide">11</div></el-col>
          <el-col :span="2">
            <el-button icon="el-icon-upload" size="medium" @click="uploadImages()">图片上传</el-button>
          </el-col>
          <el-col :span="2" v-if="chooseList.length > 0">
            <el-button type="warning" icon="el-icon-remove-outline" size="medium" @click="cancelChecked()">取消选中</el-button>
          </el-col>
          <el-col :span="2" v-if="chooseList.length > 0">
            <el-button type="danger" icon="el-icon-delete" size="medium" @click="deleteImage()">批量删除</el-button>
          </el-col>

          <el-col :span="2" v-if="chooseList.length > 0">
            <el-button type="primary" icon="el-icon-position" size="medium" @click="move()">移动</el-button>
          </el-col>
        </el-row>
        <br />
        <h2 style="color: #3fb8af" class="pull-center">{{ albumName }}</h2>
        <el-alert title="备注:" type="info" :description="remark" show-icon effect="dark"></el-alert>
        <el-row :gutter="10" type="flex" align="middle" justify="center">
          <div v-if="album.length == 0" class="pull-center">
            <el-col :span="24">
              <div style="margin: 120px 20px 10px 20px"><i class="el-icon-document-delete pull-center mid-icon"></i></div>
            </el-col>
          </div>
        </el-row>
        <el-row :gutter="10" type="flex" align="middle" justify="center" v-if="album.length == 0">
          <el-col :span="24">
            <p style="color: #5b5c5c" class="pull-center">什么都没有哦！上传两张照片吧！</p>
          </el-col>
        </el-row>
        <div v-for="(item, index) in album" :key="index">
          <h3 style="padding-top: 10px">{{ item.createTime }}</h3>

          <el-row :gutter="10">
            <el-col :span="6" v-for="(image, index2) in item.photos" :key="index2" style="margin: 10px 0px 10px 0px">
              <div>
                <el-card :class="{ cardBorder: image.ischeck }" style="cursor: pointer" :body-style="{ padding: '0' }" shadow="hover">
                  <div class="border">
                    <!-- <span class="badge badge-danger" style="position: absolute; right: 0; top: 0" >√</span> -->
                    <!-- <el-badge :value="选中" class="badge" v-if="item.ischeck"> -->

                    <span class="pull-center">
                      <el-image style="height: 250px" :src="image.path" :fit="fit" @click="choose(image)"></el-image>
                    </span>
                    <!-- </el-badge> -->

                    <!--               
                    <div class="" style="background: rgba(0, 0, 0, 0.5); margin-top: -25px; position: absolute">
                      <span class="small">{{ image.imgName }}</span>
                    </div> -->
                    <div class="dialog">
                      <el-dialog :visible.sync="bigImageShow" center width="80%" v-if="imageId == image.id" class="dialog">
                        <el-image class="pull-center" :src="image.path" :fit="fit"></el-image>
                      </el-dialog>
                    </div>
                    <div class="edit">
                      <el-dialog :visible.sync="imageEditShow" center width="80%" v-if="imageId == image.id" >
                        <editImage></editImage>
                      </el-dialog>
                    </div>
                    <div class="pull-center image-buttom-group">
                      <el-button-group>
                        <el-button icon="el-icon-view" size="medium" @click="previewImage(image)"></el-button>
                        <el-button icon="el-icon-edit" size="medium" @click="imageEdit(image)"></el-button>
                        <el-popconfirm
                          confirm-button-text="确定"
                          cancel-button-text="不用了"
                          icon="el-icon-info"
                          icon-color="red"
                          title="确定删除吗？删除后相册里的照片也会消失哦！不过可以在回收站里面找回！"
                          @onConfirm="confirm"
                        >
                          <el-button icon="el-icon-delete" slot="reference" size="medium" @click="imageDel(image)"></el-button>
                        </el-popconfirm>
                      </el-button-group>
                    </div>
                  </div>
                </el-card>
              </div>
            </el-col>
          </el-row>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'
import uploadImage from '@/components/admin/albumManage/uploadImage'
import editImage from '@/components/admin/albumManage/albumImageEdit'
export default {
  //import引入的组件需要注入到对象中才能使用
  props: ['albumId'],
  components: { uploadImage, editImage },
  data() {
    //这里存放数据
    return {
      checkAll: false,
      isIndeterminate: true,
      showPhotoUpload: false,
      albumName: '',
      album: {},

      remark: '',
      fit: 'scale-down',
      chooseList: [],
      date: '',
      url: '',
      imageId: '',
      bigImageShow: false,
      imageEditShow: false,
      pickerOptions: {
        shortcuts: [
          {
            text: '最近一周',
            onClick(picker) {
              const end = new Date()
              const start = new Date()
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7)
              picker.$emit('pick', [start, end])
            }
          },
          {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date()
              const start = new Date()
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30)
              picker.$emit('pick', [start, end])
            }
          },
          {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date()
              const start = new Date()
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90)
              picker.$emit('pick', [start, end])
            }
          }
        ]
      }
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    albumDetail() {
      let param = {}
      if (typeof this.date === 'undefined' || this.date === null || this.date === '') {
        param = {
          albumId: this.albumId
        }
      } else {
        param = {
          albumId: this.albumId,
          startTime: this.date[0],
          endTime: this.date[1]
        }
      }

      this.request
        .postJson(this.blogapi.queryAlbumDetail, param)
        .then((res) => {
          if (res.code == 0) {
            this.album = res.data.data
            this.albumName = res.data.albumName
            this.remark = res.data.remark
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },
    choose(item) {
      // 选中
      if (!item.ischeck) {
        // 加入选中
        this.chooseList.push(item.id)

        // 修改状态
        item.ischeck = true
      } else {
        item.ischeck = false
        let index = this.findId(item.id)
        this.chooseList.splice(index, 1)
      }
    },
    findId(id) {
      // let arr = this.chooseList
      if (this.chooseList.length > 0) {
        for (var i = 0; i < this.chooseList.length; i++) {
          if (this.chooseList[i] == id) return i
        }
        return -1
      } else {
        return -1
      }
    },
    cancelChecked() {
      this.chooseList = []
      for (let index = 0; index < this.album.length; index++) {
        for (let i = 0; i < this.album[index].photos.length; i++) {
          this.album[index].photos[i].ischeck = false
          // console.log( this.album[index][i].ischeck)
        }
      }
    },
    deleteImage() {
      let id = ''
      if (this.chooseList.length > 0) {
        for (let i = 0; i < this.chooseList.length; i++) {
          id = id + this.chooseList[i] + ','
        }
        id = id.substring(0, id.length - 1)

        let param = {
          photos: id,
          albumId: this.albumId
        }
        this.request
          .postJson(this.blogapi.albumPhotoDelete, param)
          .then((res) => {
            if (res.code == 0) {
              this.chooseList = []
              this.albumDetail()
              _tiper.success(res.desc)
            } else if (res.code == 1) {
              _tiper.error(res.desc)
            }
          })
          .catch((error) => {})
      } else {
        _tiper.error('请至少选择一张图片!')
      }
    },
    uploadImages() {
      this.showPhotoUpload = true
    },
    closeUploadDialog() {
      this.showPhotoUpload = false
      this.albumDetail()
    },

    previewImage(image) {
      this.bigImageShow = true

      this.imageId = image.id
    },
    imageEdit(image) {
      this.imageId = image.id
      this.imageEditShow = true
    },
    imageDel(image) {
      this.imageId = image.id
    },
    confirm() {
      let param = {
        photos: this.imageId,
        albumId: this.albumId
      }
      this.request
        .postJson(this.blogapi.albumPhotoDelete, param)
        .then((res) => {
          if (res.code == 0) {
            this.chooseList = []
            this.albumDetail()
            _tiper.success(res.desc)
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
    this.albumId = this.$route.query.albumId
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

<style>
.el-alert__title {
  font-size: 16px !important;
}
.el-alert__description {
  font-size: 15px !important;
}
.dialog /deep/ .el-dialog__wrapper {
  background-color: rgba(0, 0, 0, 1);
}
.dialog .el-dialog__body {
  background-color: rgba(0, 0, 0, 1);
}
.dialog .el-dialog__header {
  background-color: rgba(0, 0, 0, 1);
}
</style>
 
<style scoped>
@import '../../css/main.css';
</style>