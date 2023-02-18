# sui 前端开发脚手架

一个 基于 next.js Tailwind 的 sui move 应用脚手架。

## 项目依赖版本
node 16以上
react 18以上
sui 版本v0.26.1

垃圾sui 

```bash
yarn dev

## 启动准备
1.
- 设置包地址
- 设置模块名

2.部署合约
新建地址
sui client new-address ed25519
sun rotate squeeze payment appear frog infant garlic toilet frog mixed answer mobile train trip canal click dash mirror repeat little harbor drink budget
//查看部署账户
sui client addresses
//切换账户
sui client active-address
//查看账户余额
sui client objects

切换开发环境
sui client switch --env devnet

切换地址
sui client switch --address 0x2df84ad1c9a65f809940b56645253953d253db5f


sui client publish  --gas-budget 3000 ./

sui合约调用
sui client call --address 0x1083871113de333758c3d46136030d573f09ae18 --module HelloWorld --function say_hello --args 0x1083871113de333758c3d46136030d573f09ae18
sui client call --function transfer --module sui --package 0x2 --args 0x471c8e241d0473c34753461529b70f9c4ed3151b 0x3cbf06e9997b3864e3baad6bc0f0ef8ec423cd75 --gas-budget 1000
call test
sui client call --function mint --module CITI --package 0x7b771a749fad4a160308468ec716f37dd91cac90 --args 0x30259e7cbe09c1e9e6836400646473faa5c5f526 1000 0x2df84ad1c9a65f809940b56645253953d253db5f --gas-budget 1000
sui client call --function mint --module CITI --package 0x73bde317f791b81843c6fc9a1bfc0ed4d0b0188c --args 0xe9dbaa4321b38fa747a6f5ca5a15aac376fd2eb3 1000 0x2df84ad1c9a65f809940b56645253953d253db5f --gas-budget 1000


coin::TreasuryCap<0x7b771a749fad4a160308468ec716f37dd91cac90::CITI::CITI>
sui版本升级
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui

导入助记词
sui  keytool import "borrow year auto supreme tornado shoe tiger trial bacon craft fiction capable" ed25519

sui  keytool import "" ed25519
利息计算:

cycle * rate 
## 启动运行
1. git clone <https://github.com/v1xingyue/scaffold-move.git>
2. cd scaffold-move
3. yarn # 安装必须的前端包，注意自己本地的网络环境
4. 环境配置，部分全局变量在 .env.local 中,该变量会默认 注入到 yarn 启动的进程当中。
    其中两个参数需要注意:
    NEXT_PUBLIC_DAPP_PACKAGE 为合约发布的包地址
    NEXT_PUBLIC_DAPP_MODULE 为需要调用的模块名
    这个两个参数在dapp 内部调用合约的时候需要添加到调用参数里边。
4. yarn dev
5. yarn build #编译完成的 next.js 应用
6. 合约代码在 move_package 中


主要问题：
Nextjs的最新版本和旧版的node不兼容。
将node版本升高即可。


分时
2-3.30

3.45-5.15

5.30-6.30

## 今天工作 
新建一个页面获取数据并进行钱包合约交互
    //cycle * rate 就是利息
测试合约 完成合约部分编写
   #[test]
    public fun test_sword_create() {
        use sui::tx_context;

        // create a dummy TxContext for testing
        let ctx = tx_context::dummy();

        // create a sword
        let sword = Sword {
            id: object::new(&mut ctx),
            magic: 42,
            strength: 7,
        };

        // check if accessor functions return correct values
        assert!(magic(&sword) == 42 && strength(&sword) == 7, 1);
    }

test_only有什么区别
test_only 用于测试，不会被编译到合约中，而 test 会被编译到合约中，所以 test 用于测试和生产环境，而 test_only 仅用于测试环境。

sui move test 测试move项目
sui move test sword 测试指定unit tests

        虚拟地址
     // create a dummy TxContext for testing
        let ctx = tx_context::dummy();

[//]: # (   let admin = @0xBABE;)

[//]: # (        let initial_owner = @0xCAFE;)

[//]: # (        let final_owner = @0xFACE;)


debug::print(v);

PORT=9081 npx next start

内网部署
http://23.254.167.135:6001/
