/*
 *axios封装
 * 请求拦截、相应拦截、错误统一处理
 */
import axios from "axios";
import { _tiper, LOAD } from "@/common/utils/ui";

axios.defaults.timeout = 60000; // 请求超时时间
axios.defaults.headers.post["Content-Type"] = "application/json;charset=UTF-8"; // post json 编码

/**
 * 请求拦截器
 * TODO 后续根据网关拦截实现
 */

axios.interceptors.request.use(
  (config) => {
    return config;
  },
  (error) => {
    return Promise.error(error);
  }
);
/**
 * 响应拦截器
 * TODO 定义错误发生的处理事件
 */

axios.interceptors.response.use(
  (response) => {
    if (response.status === 200) {
      return Promise.resolve(response);
    } else {
      return Promise.reject(response);
    }
  },
  // 服务器状态码不是200的情况
  (error) => {
    if (error.response.status) {
      switch (error.response.status) {
        case 404:
          _tiper.error("接口请求不存在");
          break;
        // 其他错误，直接抛出错误提示
        default:
          _tiper.error("接口请求不存在", error.response.data.message);
      }
      return Promise.reject(error.response);
    }
  }
);

/**
 * axios post 请求
 * @param {String} method [请求接口方法名称]
 * @param {Object} param [请求参数]
 */
function postJson(method, param) {
  return new Promise((resolve, reject) => {
    // 根据jcf对接口请求封装
    // let postParam = { };

    axios
      .post(method, param)
      .then((res) => {
        resolve(res.data);
        loading(false);
      })
      .catch((err) => {
        reject(err.data);

      });
  });
}




/**
 * axios get 请求
 * @param {String} method [请求接口方法名称]
 * @param {Object} param [请求参数,如'/user?ID=12345' 应该为{ID: 12345}]
 */
function getJson(method, param) {
  return new Promise((resolve, reject) => {

    axios
      .get(method, {
        params: param,
      })
      .then((res) => {
        resolve(res.data);
        loading(false);
      })
      .catch((err) => {
        reject(err.data);

      });
  });
}
/**
 * 加载框事件
 * @param {boolean} flag  开关标志
 */
function loading(flag) {
  if (flag) {
    if (++request.temp.loadingCount === 1) {
      request.temp.loadingInstance = LOAD();
    }
  } else {
    if (--request.temp.loadingCount === 0) {
      if (request.temp.loadingInstance) {
        request.temp.loadingInstance.close();
        request.temp.loadingInstance = null;
      }
    }
  }
}

const request = {
  postJson: postJson,
  getJson: getJson,
  temp: {
    loadingCount: 0, // 加载计数器
    loadingInstance: null, // 加载实例
    userInfoTemp: null, // 用户信息缓存
  },
};

export { request };
