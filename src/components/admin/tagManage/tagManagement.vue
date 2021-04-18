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
              <span>标签名</span>
              <el-input size="medium" placeholder="" v-model="tagName" style="width: 200px" clearable></el-input>
            </el-col>
            <el-col :span="11"><div class="hide">11</div></el-col>
            <el-col :span="3">
              <el-button type="primary" icon="el-icon-circle-plus-outline" size="medium" @click="addTag()">新增</el-button>
            </el-col>
            <el-col :span="3">
              <el-button type="success" icon="el-icon-search" size="medium" @click="queryTagList()">搜索</el-button>
            </el-col>
          </el-row>
        </div>
        <br />
        <el-row>
          <el-col :span="1"><div class="hide">11</div></el-col>
          <el-col :span="22">
            <div class="blogList">
              <el-table :data="tagList" style="width: 100%" border>
                <el-table-column prop="index" label="序号" width="50px" align="center" type="index"></el-table-column>
                <el-table-column prop="tags" label="标签" align="center">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <el-tag effect="plain" style="margin-right: 5px">
                      {{ scope.row.label }}
                    </el-tag>
                  </template>
                </el-table-column>

                <el-table-column prop="operation" label="操作" align="center">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <div>
                      <el-button type="primary" round size="small" @click="edit(scope.row.value)">修改</el-button>

                      <el-popconfirm confirm-button-text="确定" cancel-button-text="不用了" icon="el-icon-info" icon-color="red" title="确定删除吗？博客所关联的标签也会消失哦！" @onConfirm="confirm">
                        <el-button slot="reference" type="danger" round size="small" :plain="true" @click="remove(scope.row.value)">删除</el-button>
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
export default {
  //import引入的组件需要注入到对象中才能使用
  components: {  },
  props: [],
  data() {
    //这里存放数据
    return {
      tagName: '',
      tagList: [],
      tagId: '',
      page: {
        prePage: 0,
        pageNum: 1,
        nextPage: 2,
        pageSize: 15,
        size: 0,
        total: 0
      },
      //
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    queryTagList() {
      let param = {
        pageNum: this.page.pageNum,
        pageSize: this.page.pageSize,
        tagName: this.tagName
      }
      this.request
        .postJson(this.blogapi.queryTagList, param)
        .then((res) => {
          if (res.code == 0) {
            this.tagList = res.data.list

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

    addTag() {
      this.$prompt('请输入标签名', '新增标签', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /\S/,
        inputErrorMessage: '标签名不能为空'
      })
        .then(({ value }) => {
          let param = {
            tagName: value
          }
          this.request
            .postJson(this.blogapi.tagAdd, param)
            .then((res) => {
              if (res.code == 0) {
                this.queryTagList()
              } else if (res.code == 1) {
                _tiper.error(res.desc)
              }
            })
            .catch((error) => {})
        })
        .catch(() => {
          //  _tiper.info('取消输入')
        })
    },
    firstPage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = 1
        this.queryTagList()
      }
    },
    prePage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = this.page.prePage
        this.queryTagList()
      }
    },
    nextPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.nextPage
        this.queryTagList()
      }
    },
    lastPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.size
        this.queryTagList()
      }
    },

    remove(id) {
      this.tagId = id
      console.log(this.tagId)
    },

    confirm() {
      var param = {
        tagId: this.tagId
      }
      this.request
        .postJson(this.blogapi.deleteTag, param)
        .then((res) => {
          if (res.code == 0) {
            _tiper.success(res.desc)
            this.queryTagList()
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },
    edit(id) {
      this.$prompt('请输入新的标签名', '修改标签', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /\S/,
        inputErrorMessage: '标签名不能为空'
      })
        .then(({ value }) => {
      
          var param = {
            newTagName: value,
            tagId: id
          }
          this.request
            .postJson(this.blogapi.tagUpdate, param)
            .then((res) => {
              if (res.code == 0) {
                this.queryTagList()
              } else if (res.code == 1) {
                _tiper.error(res.desc)
              }
            })
            .catch((error) => {})
        })
        .catch(() => {
          //  _tiper.info('取消输入')
        })
    }
  },

  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.queryTagList()
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