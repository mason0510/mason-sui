# SUI-As
An improved version of the Move ecology AS algorithm Stablecoin project
## Demo

[Demo Link](http://23.254.167.135:6001/)
how to ensure investor's interests?
1.sui区块链的合约基本安全性保证。Based on sui System ,ensure the stability and safety of the system
2.代币的应用场景。Games is based on the stablecoin, the introduction of game theory for add more citi scene.
Eos top Rink games will be introduced , these games will be the games to use the citi stablecoin.
3.Dao基金会控制协议。the introduction of the DAO system to ensure the interests of investors for winning more trust
4.Game theory(博弈论)的引入。只有bond和stake的用户长期看才能获得最大的收益，避免市场过度抛售。
![SUI-As 博弈论的说明](https://p.ipic.vip/vnnf5f.png)
If both hodlers bond & stake = (3, 3), the total score would be 6 (HIGHEST)
If one bonds & one stakes = (3, 1), the total score would be 4
If one sells = (1, -1), the total score would be 0
If both sell = (-3, -3), the total score would be -6 (LOWEST)
With the matrix table overview, it is pretty clear that bonding and staking will be the best choice for all of our IMMO hodlers. 
Theoretically, if everyone stakes and bonds, CITI will be able to deliver the best for holders and treasury assets.
In CITI System, CITI can only be minted or burnt by the protocol and it also guarantees that each CITI is always backed by some amount of 1 mcUSD.

5.当币价低于1美元时,市场处于极端情况将启动互助机制，(投资者的代币将会启动自动锁定或者紧急销毁机制，直到代币代币重新挂钩),确保不会出现luna式死亡螺旋。
The unique hook mechanism can ensure that the stablecoin is not affected by the market and the price is stable

risk？
早期入场者包括私募将获取巨额收益远超过后来者，导致市场过度炒作，抵押率将不断降低,citi币价大幅上升。
An overheated market leads to an unfair distribution of gains.


# Sui-as 
设计思路:
Citi协议的最终目标是提供一种高度可扩展的、去中心化的算法货币.现有算法稳定币的基础上，增加了使用部分稳定币作为抵押资产.
在创世阶段只需要消耗USDC,初始时抵押率为100%，即全部使用USDC抵押按照1:1铸造CITI，之后抵押率八个小时调整一次，若CITI价格大于1美元，则降低抵押率，增加CITI在其中的份额；
若FRAX低于1美元则升高抵押率。抵押率8小时调整一次，每次调整0.25%。当出现极端抛售，将会将所有代币锁定直到恢复正常。


