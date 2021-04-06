// 接口请求统一管理
const blogapi = {

  getNewFiveBlog: '/myblog/index/getNewFiveBlog',
  getNewFiveCommentBlog: '/myblog/index/getNewFiveCommentBlog',
  getTopFiveViewBlog: '/myblog/index/getTopFiveViewBlog',
  getBlogList: '/myblog/index/blogList',
  getTagList: '/myblog/index/tagList',
  getBlogListByTagId: '/myblog/index/tag',
  getrecommend: '/myblog/index/recommend',
  getBlogDetail: '/myblog/blog/blogDetail',
  praise: '/myblog/blog/praise',
  getComments: '/myblog/blog/getComments',
  postComment: '/myblog/blog/comments',
  getAllTagsInTagPage: '/myblog/tag/getTags',
  getBlogListByTagIdInTagPage: '/myblog/tag/getBlogList',
  getBlogMap: '/myblog/archivie/getArchive',
  getAlbum: '/myblog/album/getaAbums',
  login: '/myblog/admin/login',
  logout: '/myblog/admin/logout',
  getUserInfo: '/myblog/system/getUserInfo',
  getSysUserInfo: '/myblog/system/getSysUserInfo',
  avatarUpload:'/myblog/system/updateAvatar',
  queryBlogList:'/myblog/admin/blog/queryBlogList',
  getTagsByUserId:'/myblog/admin/tag/getTagsByUserId',
  deleteBlog:'/myblog/admin/blog/delete',
  saveBlog:'/myblog/admin/blog/save',
  getAdminBlogDetail:'/myblog/admin/blog/blogDetail',
  updateBlog:'/myblog/admin/blog/update',
  uploadToGallery:'/myblog/admin/uploadToGallery',
};

export { blogapi };
