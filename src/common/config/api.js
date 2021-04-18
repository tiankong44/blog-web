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
  getAlbum: '/myblog/album/getaAlbums',
  //用户管理
  login: '/myblog/admin/login',
  logout: '/myblog/admin/logout',
  getUserInfo: '/myblog/system/getUserInfo',
  getSysUserInfo: '/myblog/system/getSysUserInfo',
  avatarUpload:'/myblog/system/updateAvatar',
  //博客管理
  queryBlogList:'/myblog/admin/blog/queryBlogList',
  getTagsByUserId:'/myblog/admin/tag/getTagsByUserId',
  deleteBlog:'/myblog/admin/blog/delete',
  saveBlog:'/myblog/admin/blog/save',
  getAdminBlogDetail:'/myblog/admin/blog/blogDetail',
  updateBlog:'/myblog/admin/blog/update',
  uploadToGallery:'/myblog/admin/uploadToGallery',
  //标签管理
  queryTagList:'/myblog/admin/tag/queryTagList',
  deleteTag:'/myblog/admin/tag/delete',
  tagAdd:'/myblog/admin/tag/add',
  tagUpdate:'/myblog/admin/tag/update',
  //相册管理
  queryAlbumList:'/myblog/admin/album/queryAlbumList',
  mainPictureUpload:'/myblog/admin/album/mainPictureUpload',
  albumAdd:'/myblog/admin/album/add',
  albumDelete:'/myblog/admin/album/delete',
  albumDetail:'/myblog/admin/album/albumDetail',
  queryAlbumDetail:'/myblog/admin/album/queryAlbumDetail',
  albumPhotoDelete:'/myblog/admin/gallery/deleteAlbumGallery',
  justAlbumDetail:'/myblog/admin/album/justAlbumDetail',
  albumPhotosUpload:'/myblog/admin/album/albumPhotosUpload',
};

export { blogapi };
