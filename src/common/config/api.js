// 接口请求统一管理
const blogapi = {
 
  getNewFiveBlog:'/blog/getNewFiveBlog',
  getNewFiveCommentBlog:'/blog/getNewFiveCommentBlog',
  getTopFiveViewBlog:'/blog/getTopFiveViewBlog',
  getBlogList:'/blog/blogList',
  getTagList:'/blog/tagList',
  getBlogListByTagId:'/blog/tag',
  getrecommend:'/blog/recommend',
  getBlogDetail:'/blog/blogDetail',
  praise:'/blog/praise',
  getComments:'/blog/getComments',
  postComment:'/blog/comments'
  };
  
  export { blogapi };
  