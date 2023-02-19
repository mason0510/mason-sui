import { useWallet } from "@suiet/wallet-kit";
import React, { useEffect, useState } from "react";
import {SUI_PACKAGE, SUI_MODULE,TreasureAddress, NETWORK, TABLE_NAME,OwnerAddress2} from "../config/constants";
import { JsonRpcProvider } from '@mysten/sui.js';
export default function Contract() {
    const provider = new JsonRpcProvider();

    const [magic, updateMagic] = useState('');
    const [strength, updateStrength] = useState('');
    const { signAndExecuteTransaction } = useWallet();
    const [received, updateRecipient] = useState("");
    const [tx, setTx] = useState('')
    const [message, setMessage] = useState('');

    function makeTranscaction() {
        let treasury_cap = TreasureAddress;
        let received = "0x4e4fdd76615bffff6d44aac333e771c4865bdae7";
        console.log('treasury_cap', treasury_cap);
        console.log('received', received);
        console.log('SUI_PACKAGE', SUI_PACKAGE);
        console.log('SUI_MODULE', SUI_MODULE);
        return {
            packageObjectId: SUI_PACKAGE,
            module: SUI_MODULE,
            function: 'claim',
            typeArguments: [],
            // 类型错误，传递字符串类型，部分钱包会内部转化
            arguments: [
                treasury_cap,
                received,
            ],
            gasBudget: 30000,
        };
    }

    const claimCiti = async () => {
        setMessage("");
        try {
            const data = makeTranscaction();
            const resData = await signAndExecuteTransaction({
                transaction: {
                    kind: 'moveCall',
                    data
                }
            });
            console.log('success', resData);
            setMessage('Claim succeeded');
            alert('unStake success---'+resData.certificate.transactionDigest);
            //打印显示成功的交易
            setTx('https://explorer.sui.io/transaction/' + resData.certificate.transactionDigest)
            console.log('success2', resData);
        } catch (e) {
            console.error('failed', e);
            setMessage('Claim failed: ' + e);
            setTx('');
        }
    }

    return (
        <div>
            <div className="alert alert-info shadow-lg">
                <div>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" className="stroke-current flex-shrink-0 w-6 h-6"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span>
                        Sui Test Package Module: <a className="link link-primary" target={"_blank"} href={"https://explorer.sui.io/object/" + SUI_PACKAGE + "?network=" + NETWORK}>{SUI_PACKAGE}</a>
                    </span>
                </div>
            </div>

            <div className="card lg:card-side bg-base-100 shadow-xl mt-5">
                <div className="card-body">
                    <h2 className="card-title">Withdrawal Interest </h2>
                    <p><b>当前利息:1000</b></p>
                    <input
                        placeholder="Recipient Address 默认当前地址"
                        className="mt-8 p-4 input input-bordered input-primary w-full"
                        value={received}
                        onChange={(e) =>
                            updateRecipient(e.target.value)
                        }
                    />
                    <div className="card-actions justify-end">
                        <button
                            onClick={claimCiti}
                            className={
                                "btn btn-primary font-bold mt-4 text-white rounded p-4 shadow-lg"
                            }>
                            claim
                        </button>
                    </div>
                </div>
            </div>

        </div>
    );
}
