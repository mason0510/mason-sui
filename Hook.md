一段运行函数。
例如，假设你想要实现每个页面开启的时候都会运行一段代码，使用Next.js可以比较方便的实现。

使用Next.js创建新项目:

$ yarn create next-app my-app
$ cd my-app
$ yarn dev
在pages文件夹下创建一个index.js文档：

// pages/index.js
import { useEffect } from 'react'
function HomePage() {
useEffect(() => {
//你可以添加任何在页面开启时要执行的代码
console.log('This message appears when the page opens!')
}, [])
return <h1>Hello World</h1>
}
export default HomePage
运行 yarn dev 后，当你打开首页的时候，就会看到控制台打印出 “This message appears when the page opens！” 的消息。
