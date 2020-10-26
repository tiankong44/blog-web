// 接口请求统一管理
const blogapi = {
 
  getNewFiveBlog:'/blog/index/getNewFiveBlog',
  getNewFiveCommentBlog:'/blog/index/getNewFiveCommentBlog',
  getTopFiveViewBlog:'/blog/index/getTopFiveViewBlog',
  getBlogList:'/blog/index/blogList',
  getTagList:'/blog/index/tagList',
  getBlogListByTagId:'/blog/index/tag',
  getrecommend:'/blog/index/recommend',
  getBlogDetail:'/blog/blog/blogDetail',
  praise:'/blog/blog/praise',
  getComments:'/blog/blog/getComments',
  postComment:'/blog/blog/comments',
  getAllTagsInTagPage:'/blog/tag/getTags',
  getBlogListByTagIdInTagPage:'/blog/tag/getBlogList',
  getBlogMap:'/blog/archivie/getArchive',
  };
  
  export { blogapi };
  