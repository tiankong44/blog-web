const getters = {
  getUserInfo: (state) => {
    return state.userInfo ? state.userInfo : {};
  },
};
export default getters;
