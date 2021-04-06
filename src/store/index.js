import Vue from "vue";
import Vuex from "vuex";
import getters from "@/store/getters";
import mutations from "@/store/mutations";

Vue.use(Vuex);

const state = {
  title: "",
  username: "",
};

const store = new Vuex.Store({
  state: state,
  mutations: mutations,
  getters: getters,
});

export default store;
