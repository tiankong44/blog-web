<!--  -->
<template>
  <div class="">
    <el-row>
      <el-col :span="3"><div class="hide">11</div></el-col>
      <el-col :span="18">
        <div class="breadCrumbs">
          <!-- <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/tagManagement' }" @click="queryTagList()">列表</el-breadcrumb-item>
      
          </el-breadcrumb> -->
        </div>
        <br />
        <div class="params">
          <el-row>
            <el-col :span="1"><div class="hide">11</div></el-col>
            <el-col :span="6">
              <span>相册名</span>
              <el-input size="medium" placeholder="" v-model="albumName" style="width: 200px" clearable></el-input>
            </el-col>
            <el-col :span="8">
              <span>创建时间</span>
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
            <!-- <el-col :span="1"><div class="hide">11</div></el-col> -->
            <el-col :span="3">
              <el-button type="info" icon="el-icon-folder-delete" size="medium" @click="recycle()">回收站</el-button>
            </el-col>
            <el-col :span="3">
              <el-dialog title="新增相册" :visible.sync="showAddAlbum" center width="60%" >
                <albumAdd @fatherMethod="closeAddOrEditDialog"></albumAdd>
              </el-dialog>
              <el-button type="primary" icon="el-icon-circle-plus-outline" size="medium" @click="addAlbum()">新增</el-button>
            </el-col>
            <el-col :span="3">
              <el-button type="success" icon="el-icon-search" size="medium" @click="queryAlbum()">搜索</el-button>
            </el-col>
          </el-row>
        </div>
        <br />
        <el-row>
          <el-col :span="1"><div class="hide">11</div></el-col>
          <el-col :span="22">
            <div class="albumList">
              <el-table :data="albumList" style="width: 100%" border>
                <el-table-column prop="title" label="序号" width="50px" align="center" type="index"></el-table-column>
                <el-table-column prop="albumName" label="相册名" width="180" align="center"></el-table-column>
                <el-table-column prop="mainPicture" label="主图" align="center">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <div>
                      <el-image style="width: 200px; height: 150px" :src="scope.row.mainPicture" :fit="fit"></el-image>
                    </div>
                  </template>
                </el-table-column>
                <el-table-column prop="remark" label="创建时间" show-overflow-tooltip align="center"></el-table-column>
                <el-table-column prop="createTime" label="创建时间" show-overflow-tooltip align="center"></el-table-column>
                <el-table-column prop="type" label="类型" width="180" align="center">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <span v-if="scope.row.type == 1">公开</span>
                    <span v-else-if="scope.row.type == 2">私有</span>
                  </template>
                </el-table-column>

                <el-table-column prop="operation" label="操作" align="center" width="280px">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <div>
                      <!-- <el-button type="info" round size="small" @click="detail(scope.row.id)">管理</el-button> -->

                      <el-dialog :visible.sync="showAlbumDetail" center width="80%"    v-if="albumId == scope.row.id">
                        <albumView :albumId="albumId"></albumView>
                      </el-dialog>
                      <el-button type="success" round size="small" @click="view(scope.row.id)">查看</el-button>
                      <el-button round size="small" @click="albumManage(scope.row.id)">管理</el-button>

                      <el-dialog title="修改相册" :visible.sync="showEditAlbum" center width="60%"    v-if="albumId == scope.row.id">
                        <albumEdit :albumId="albumId" @fatherMethod="closeAddOrEditDialog" ></albumEdit>
                      </el-dialog>
                      <el-button type="primary" round size="small" @click="editAlbum(scope.row.id)">修改</el-button>
                      <el-popconfirm
                        confirm-button-text="确定"
                        cancel-button-text="不用了"
                        icon="el-icon-info"
                        icon-color="red"
                        title="确定删除吗？删除后相册里的照片也会消失哦！不过可以在回收站里面找回！"
                        @onConfirm="confirm"
                      >
                        <el-button slot="reference" type="danger" round size="small" :plain="true" @click="remove(scope.row.id)">删除</el-button>
                      </el-popconfirm>
                    </div>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </el-col>
        </el-row>
        <br />
        <div align="center">
          <el-button-group>
            <el-button v-on:click="firstPage()">首页</el-button>
            <el-button icon="el-icon-arrow-left" v-on:click="prePage()">上一页</el-button>
            <el-button v-on:click="nextPage()">
              下一页
              <i class="el-icon-arrow-right el-icon--right"></i>
            </el-button>

            <el-button v-on:click="lastPage()" class="lastPage">尾页</el-button>
          </el-button-group>
          <div align="center" style="font-size: 15px; opacity: 0.7">
            <span>
              <p>
                当前第
                <span class="green-text">{{ page.pageNum }}</span>
                页，总
                <span class="green-text">{{ page.size }}</span>
                页，共
                <span class="green-text">{{ page.total }}</span>
                条记录
              </p>
            </span>
          </div>
        </div>
      </el-col>
      <el-col :span="3"><div class="hide">11</div></el-col>
    </el-row>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';
import { _tiper } from '@/common/utils/ui.js'
import albumAdd from '@/components/admin/albumManage/albumAdd'
import albumEdit from '@/components/admin/albumManage/albumEdit'
import albumView from '@/components/admin/albumManage/albumView'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: { albumAdd, albumView, albumEdit },
  props: [],
  data() {
    //这里存放数据
    return {
      albumName: '',
      albumList: [],
      page: {
        prePage: 0,
        pageNum: 1,
        nextPage: 2,
        pageSize: 15,
        size: 0,
        total: 0
      },
      albumId: '',
      showAddAlbum: false,
      showEditAlbum: false,
      showAlbumDetail: false,
      date: '',
     fit: "contain",
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
      //
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    closeAddOrEditDialog() {
      this.showAddAlbum = false
      this.showEditAlbum = false
      this.queryAlbum()
    },
    queryAlbum() {
      let param = {}
      if (typeof this.date === 'undefined' || this.date === null || this.date === '') {
        param = {
          albumName: this.albumName,
          pageNum: this.page.pageNum,
          pageSize: this.page.pageSize
        }
      } else {
        param = {
          albumName: this.albumName,
          pageNum: this.page.pageNum,
          pageSize: this.page.pageSize,
          startTime: this.date[0],
          endTime: this.date[1]
        }
      }

      this.request
        .postJson(this.blogapi.queryAlbumList, param)
        .then((res) => {
          if (res.code == 0) {
            this.albumList = res.data.list

            this.page.pageNum = res.data.pageNum
            this.page.total = res.data.total
            this.page.prePage = res.data.prePage
            this.page.nextPage = res.data.nextPage
            this.page.size = res.data.pages
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },

    firstPage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = 1
        this.queryAlbum()
      }
    },
    prePage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = this.page.prePage
        this.queryAlbum()
      }
    },
    nextPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.nextPage
        this.queryAlbum()
      }
    },
    lastPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.size
        this.queryAlbum()
      }
    },

    addAlbum() {
      this.showAddAlbum = true
    },
    editAlbum(id) {
      this.showEditAlbum = true
      this.albumId = id
    },
    remove(id) {
      this.albumId = id
    },

    confirm() {
      let param = {
        albumId: this.albumId
      }
      this.request
        .postJson(this.blogapi.albumDelete, param)
        .then((res) => {
          if (res.code == 0) {
            _tiper.success(res.desc)
            this.queryAlbum()
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },
    albumManage(id) {
      this.$router.push({ path: '/albumManage', query: { albumId: id } })
    },
    view(id) {
      // this.$router.push({ path: '/albumView', query: { albumId: id } })
      this.albumId = id
      this.showAlbumDetail = true
    }
    //
  },

  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.queryAlbum()
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
<style src="../../css/main.css" scoped>