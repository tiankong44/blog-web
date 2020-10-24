<!--  -->
<template>
  <div class="">
    <h3 class="pull-center">用户评论</h3>

    <div class="comment-parent" v-for="comment in comments" :key="comment.id">
      <el-row :gutter="70">
        <el-col :span="1">
          <div class="">
            <el-avatar :src="comment.avatar" :size="50"></el-avatar>
          </div>
        </el-col>
        <el-col :span="18">
          <div class="">
            <span>
              <span class="nickname comment-padding">{{ comment.nickname }}</span>
              &nbsp;
            </span>
            <div class="comment-content opacity-full comment-padding">{{ comment.content }}</div>
            <div class="opacity-min-mintext">
              <span>{{ comment.createTime }}</span>
              &nbsp;
              <a class="reply" @click="reply(comment.id, comment.nickname)" style="cursor: pointer">回复</a>
            </div>
            <div class="reply-area" v-if="isShow && parentCommentId == comment.id">
              <el-card shadow="never" :body-style="bodyStyle">
                <el-row>
                  <el-col :span="18">
                    <el-input type="textarea" :rows="4" :placeholder="placeholder" v-model="content"></el-input>
                  </el-col>
                </el-row>
                <el-row :gutter="40">
                  <br />
                  <el-col :span="7">
                    <div class=""><el-input placeholder="昵称" suffix-icon="el-icon-user" v-model="nickname"></el-input></div>
                  </el-col>

                  <el-col :span="7">
                    <div class=""><el-input placeholder="邮箱" suffix-icon="el-icon-message" v-model="email"></el-input></div>
                  </el-col>
                  <el-col :span="7">
                    <el-button type="success" round @click="postReply">发布</el-button>
                  </el-col>
                </el-row>
              </el-card>
              <br />
            </div>
          </div>
          <div v-if="comment.replyComments != null">
            <div class="comment-childs" v-for="reply in comment.replyComments" :key="reply.id">
              <el-card shadow="never" :body-style="bodyStyle">
                <el-row :gutter="40">
                  <el-col :span="2">
                    <div class="">
                      <el-avatar :src="reply.avatar" size="large"></el-avatar>
                    </div>
                  </el-col>
                  <el-col :span="18">
                    <div class="">
                      <span>
                        <span class="nickname comment-padding">{{ reply.nickname }}</span>
                      </span>
                      <span class="reply-text">回复</span>

                      <span class="nickname comment-padding">{{ comment.nickname }}</span>
                      <div class="comment-content opacity-full comment-padding">{{ reply.content }}</div>
                      <div class="opacity-min-mintext">
                        <span>{{ reply.createTime }}</span>
                      </div>
                    </div>
                  </el-col>
                </el-row>
              </el-card>
              <br />
            </div>
          </div>
        </el-col>
      </el-row>
      <hr class="opacity-tiny" />
    </div>
    <div class="reply-area">
      <el-card shadow="never" :body-style="bodyStyle">
        <el-row>
          <el-col :span="17">
            <el-input type="textarea" :rows="6" :placeholder="commentPlaceholder" v-model="commentContent"></el-input>
          </el-col>
        </el-row>
        <el-row :gutter="40">
          <br />
          <el-col :span="7">
            <div class=""><el-input placeholder="昵称" suffix-icon="el-icon-user" v-model="commentNickname"></el-input></div>
          </el-col>

          <el-col :span="7">
            <div class=""><el-input placeholder="邮箱" suffix-icon="el-icon-message" v-model="commentEmail"></el-input></div>
          </el-col>
          <el-col :span="7">
            <el-button type="success" round @click="postComment">发布</el-button>
          </el-col>
          <br />
          <br />
        </el-row>
      </el-card>
      <br />
    </div>
  </div>
</template>

<script>
//这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
//例如：import 《组件名称》 from '《组件路径》';

export default {
  //import引入的组件需要注入到对象中才能使用
  components: {},
  props: ['comments', 'blogId'],
  data() {
    //这里存放数据
    return {
      bodyStyle: { 'background-color': '#f5f7fd' },
      isShow: false,
      content: '',
      placeholder: '请输入内容',
      parentCommentId: -1,
      nickname: '',
      email: '',
      commentPlaceholder: '请输入内容',
      commentContent: '',
      commentNickname: '',
      commentEmail: ''
    }
  },
  //监听属性 类似于data概念
  computed: {},
  //监控data中的数据变化
  watch: {},
  //方法集合
  methods: {
    reply(id, nickname) {
      if (id != this.parentCommentId) {
        this.isShow = true
        this.nickname="";
        this.email=""
      } else {
        this.isShow = !this.isShow
      }
      this.parentCommentId = id
      this.placeholder = '@' + nickname
    },
    postReply() {
      let param = {
        blogId: this.blogId,
        parentCommentId: this.parentCommentId,
        nickname: this.nickname,
        email: this.email,
        content: this.content
      }
      this.request
        .postJson(this.blogapi.postComment, param)
        .then((res) => {
          if (res.code == 0) {
            this.$emit('fatherMethod')
            this.content = ''
            this.nickname = ''
            this.email = ''
            this.placeholder = ''
            this.isShow = false
          }
        })
        .catch((error) => {})
    },
    postComment() {
      let param = {
        blogId: this.blogId,
        parentCommentId: -1,
        nickname: this.commentNickname,
        email: this.commentEmail,
        content: this.commentContent
      }
      this.request
        .postJson(this.blogapi.postComment, param)
        .then((res) => {
          if (res.code == 0) {
            this.$emit('fatherMethod')
            this.commentContent = ''
            this.commentNickname = ''
            this.commentEmail = ''
          }
        })
        .catch((error) => {})
    }
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
@import '../css/main.css';
</style>