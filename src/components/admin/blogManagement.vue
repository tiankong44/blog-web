<!--  -->
<template>
  <div class="">
    <el-row>
      <el-col :span="3"><div class="hide">11</div></el-col>
      <el-col :span="18">
        <div class="breadCrumbs">
          <br />
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/blogManagement' }" @click="queryBlogList()">列表</el-breadcrumb-item>
            <el-breadcrumb-item><a href="/blogAdd" style="cursor: pointer">发布</a></el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <br />
        <div class="params">
          <el-row>
            <el-col :span="1"><div class="hide">11</div></el-col>
            <el-col :span="6">
              <span>标题</span>
              <el-input size="medium" placeholder="请输入标题" v-model="title" style="width: 200px" clearable></el-input>
            </el-col>
            <el-col :span="8">
              <span>标签</span>
              <el-select v-model="tagValues" multiple placeholder="请选择" style="width: 200px" size="medium">
                <el-option v-for="tag in tags" :key="tag.value" :label="tag.label" :value="tag.value"></el-option>
              </el-select>
            </el-col>

            <el-col :span="6">
              <div style="margin: 6px 0px 0px 0px">
                <span>推荐</span>
                <el-tooltip content="被推荐的内容" placement="top">
                  <el-switch v-model="recommend" active-color="#13ce66" inactive-color="#DCDFE6"></el-switch>
                </el-tooltip>
              </div>
            </el-col>
            <el-col :span="3">
              <el-button type="success" icon="el-icon-search" size="medium" @click="queryBlogList()">搜索</el-button>
            </el-col>
          </el-row>
        </div>
        <br />
        <el-row>
          <el-col :span="1"><div class="hide">11</div></el-col>
          <el-col :span="22">
            <div class="blogList">
              <el-table :data="blogList" style="width: 100%" border>
                <el-table-column prop="title" label="标题" width="180" align="center"></el-table-column>
                <el-table-column prop="tags" label="标签" width="160" align="center">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <el-tag v-for="tag in scope.row.tags" :key="tag.label" :type="tag.type" effect="plain" style="margin-right: 5px">
                      {{ tag.name }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="description" label="描述" show-overflow-tooltip align="center"></el-table-column>
                <el-table-column prop="updateTime" label="更新时间" width="180" align="center"></el-table-column>
                <el-table-column prop="recommend" label="推荐" width="50" align="center">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <span v-if="scope.row.recommend == true">是</span>
                    <span v-else-if="scope.row.recommend == false">否</span>
                  </template>
                </el-table-column>
                <el-table-column prop="operation" label="操作" align="center" width="280px">
                  <template slot-scope="scope">
                    <!-- <div :style="operationWidth"> -->
                    <div>
                      <el-dialog title="博客预览" :visible.sync="dialogTableVisible" v-if="blogId == scope.row.id" center width="60%">
                        <blogPreView :blogId="blogId"></blogPreView>
                      </el-dialog>

                      <el-button type="info" round size="small" @click="detail(scope.row.id)">查看</el-button>

                      <el-button type="primary" round size="small" @click="edit(scope.row.id)">编辑</el-button>

                      <el-popconfirm confirm-button-text="确定" cancel-button-text="不用了" icon="el-icon-info" icon-color="red" title="确定删除吗？" @onConfirm="confirm">
                        <el-button slot="reference" type="danger" round size="small" :plain="true" @click="remove(scope.row.id)">删除</el-button>
                      </el-popconfirm>
                    </div>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </el-col>
        </el-row>
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
import blogPreView from '@/components/admin/blogPreView'
export default {
  //import引入的组件需要注入到对象中才能使用
  components: { blogPreView },
  props: [],
  data() {
    //这里存放数据
    return {
      title: '',
      tags: [],
      tagValues: [],
      recommend: false,
      blogList: [],
      page: {
        prePage: 0,
        pageNum: 1,
        nextPage: 2,
        pageSize: 10,
        size: 0,
        total: 0
      },
      blogId: '',
      dialogTableVisible: false
      //
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    queryBlogList() {
      let ids = ''
      for (let index = 0; index < this.tagValues.length; index++) {
        ids = ids + this.tagValues[index] + ','
        // const element = array[index]
      }
      if (ids.length > 0) {
        ids = ids.substring(0, ids.length - 1)
      }

      let param = {
        pageNum: this.page.pageNum,
        pageSize: this.page.pageSize,
        tagIds: ids,
        title: this.title,
        recommend: this.recommend
      }
      this.request
        .postJson(this.blogapi.queryBlogList, param)
        .then((res) => {
          if (res.code == 0) {
            this.blogList = res.data.list

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

    firstPage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = 1
        this.queryBlogList()
      }
    },
    prePage() {
      if (this.page.prePage == 0) {
        _tiper.warn('已经在第一页了哦！')
      } else {
        this.page.pageNum = this.page.prePage
        this.queryBlogList()
      }
    },
    nextPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.nextPage
        this.queryBlogList()
      }
    },
    lastPage() {
      if (this.page.nextPage == 0) {
        _tiper.warn('已经到最后一页了！')
      } else {
        this.page.pageNum = this.page.size
        this.queryBlogList()
      }
    },

    detail(id) {
      this.blogId = id
      this.dialogTableVisible = true
    },
    remove(id) {
      this.blogId = id
      console.log(this.blogId)
    },

    confirm() {
      let param = {
        blogId: this.blogId
      }
      this.request
        .postJson(this.blogapi.deleteBlog, param)
        .then((res) => {
          if (res.code == 0) {
            _tiper.success(res.desc)
            this.queryBlogList()
          } else if (res.code == 1) {
            _tiper.error(res.desc)
          }
        })
        .catch((error) => {})
    },
    edit(id) {
      console.log(id)
      this.$router.push({ path: '/blogEdit', query: { blogId: id } })
    }
  },

  //生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  //生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.queryBlogList()
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
<style src="../css/main.css" scoped>