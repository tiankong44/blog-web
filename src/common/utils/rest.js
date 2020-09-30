import { request } from "@/common/utils/request";
import { mockapi } from "@/common/config/api.js";
import { _tiper } from "@/common/utils/ui";

export function dictQuery(dictObj, cbEvent) {
  request.postJson(mockapi.dictQuery,dictObj).then(res=>{
    if(res.code == "0"){
      cbEvent(res.data);
    }else{
      _tiper.error(res.msg);
    }

  }).catch(err=>{
    _tiper.error("查询码表信息过程出现异常。");
  });
}
