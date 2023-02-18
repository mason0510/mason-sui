w为什么要使用Redux？
大型组件很难拆分和重构，也很难测试。
业务逻辑分散在组件的各个方法之中，导致重复逻辑或关联逻辑。
组件类引入了复杂的编程模式，比如 render props 和高阶组件。
useState()
useContext()
useReducer()
useEffect()


一、在Next.js项目中安装Redux和react-redux：

// 使用npm安装
npm install --save redux react-redux

// 或者使用yarn安装
yarn add redux react-redux
二、创建Redux store

我们需要创建一个React可以访问的Redux store。新建一个文件store.js，添加以下代码：

import { createStore} from 'redux';

// 初始化一个默认 state
const defaultState = {                                        
  count: 0,
  message: ""
};
 
// 创建 store
const store = createStore(
  (state = defaultState, action) => {       
    switch (action.type) {
      case 'MODIFY_COUNT':
        return {
          ...state,
          count: action.payload
        };
      case 'MODIFY_MESSAGE':
        return {
          ...state,
          message: action.payload
        };
      default:
        return state;
    }
  }
);

export default store;

三、必要文件

新建一个文件pages/_app.js，用来挂载Redux：

import React from 'react';
import App from 'next/app';
import { Provider } from "react-redux";
import store from '../store';
 
class MyApp extends App {
  render() {
    const { Component, pageProps } = this.props
    return (
      <Provider store={store}>
        <Component {...pageProps} />
      </Provider>
    )
  }
}
 
export default MyApp
四、添加action和reducer

新建一个文件actions.js ，使用action来改变store的值：

export const modifyCount = (count) => {
  return {
    type: 'MODIFY_COUNT',
    payload: count
  }
}
 
export const modifyMessage = (message) => {
  return {
    type: 'MODIFY_MESSAGE',
    payload: message
  }
}
新建一个文件reducers.js，使用reducer来获取store的值：

function reducers(state,action) {
  switch(action.type){
    case "MODIFY_COUNT":
      return {...state, count: action.payload};
    case "MODIFY_MESSAGE":
      return {...state, message: action.payload};
    default:
      return state;
  }
}

export default reducers;
五、使用Redux传递值

在Next.js项目中任意文件中，import store以及对应的actions和reducers：

import {ModifyCount,ModifyMessage} from "../actions";
import store from "../store";
接下来可以使用store.dispatch()方法修改值：

store.dispatch(ModifyCount(1));
store.dispatch(ModifyMessage('hello world'));
最后，可以使用store.getState()方法获取Redux中的值：

const count = store.getState().count;
const message = store.getState().message;
