import { useWallet } from "@suiet/wallet-kit";
import { useEffect, useState } from "react";
import { SUI_PACKAGE, SUI_MODULE, NETWORK,TreasureAddress,TABLE_NAME } from "../config/constants";
import { JsonRpcProvider } from '@mysten/sui.js';



export default function Contract() {

    const provider = new JsonRpcProvider();
    const [magic, updateMagic] = useState('');
    const [strength, updateStrength] = useState('');
    const { signAndExecuteTransaction } = useWallet();
    const [recipient, updateRecipient] = useState("");
    const [tx, setTx] = useState('')

    function makeTranscaction() {
        let self=TABLE_NAME;
        let treasury_cap=TreasureAddress;
        console.log(self,treasury_cap)
        return {
            packageObjectId: SUI_PACKAGE,
            module: SUI_MODULE,
            function: 'unstake',
            typeArguments: [],
            // 类型错误，传递字符串类型，部分钱包会内部转化
            arguments: [
                self,
                treasury_cap,
            ],
            gasBudget: 30000,
        };
    }

    const unStakeCiti = async () => {
        try {
            const data = makeTranscaction();
            const resData = await signAndExecuteTransaction({
                transaction: {
                    kind: 'moveCall',
                    data
                }
            });
            console.log('success', resData);
            alert('unStake success---'+resData.certificate.transactionDigest);
            setTx('https://explorer.sui.io/transaction/' + resData.certificate.transactionDigest)
        } catch (e) {
            console.error('failed', e);
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
                    <h2 className="card-title">Take Back My Investment</h2>
                    <div className="card-actions justify-end">
                        <button
                            onClick={unStakeCiti}
                            className={
                                "btn btn-primary font-bold mt-4 text-white rounded p-4 shadow-lg"
                            }>
                            unstake
                        </button>
                    </div>
                </div>
            </div>

        </div>
    );
}
