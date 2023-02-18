import { useWallet } from "@suiet/wallet-kit";
import { useEffect, useState } from "react";
import React from "react";
import Link from 'next/link';
import { JsonRpcProvider } from '@mysten/sui.js';
import { SUI_PACKAGE, SUI_MODULE } from "../config/constants";

const BaseAddr = SUI_PACKAGE;
type NftListPros = { nfts: Array<{ url: string, id: string, name: string, description: string }> };
//this part is lists for nfts and swords
const NftList = ({ nfts }: NftListPros) => {
  return nfts && (
    <div className="card lg:card-side bg-base-100 shadow-xl mt-5">
      <div className="card-body">
        <h2 className="card-title">Minted NFTs:</h2>
        {
          nfts.map((item, i) => <div className="gallery" key={item.id}>
            <a target="_blank" href={"https://explorer.sui.io/object/" + item.id + "?network=" + process.env.NEXT_PUBLIC_SUI_NETWORK}>
              <img src={item.url} max-width="300" max-height="200"></img>
              <div className="name">{item.name}</div>
              <div className="desc">{item.description}</div>
            </a>
          </div>)
        }
      </div>
    </div>
  )
}


type SwordListPros = { swords: Array<{ id: string, magic: number, strength: number }>, transfer: Function };
const SwordList = ({ swords, transfer }: SwordListPros) => {
  return swords && (
    <div className="card lg:card-side bg-base-100 shadow-xl mt-5">
      <div className="card-body">
        <h2 className="card-title">swords list:</h2>

        <div className="overflow-x-auto">
          <table className="table w-full">
            <thead>
              <tr>
                <th>Id</th>
                <th>Magic</th>
                <th>Strength</th>
                <th>Operate</th>
              </tr>
            </thead>
            <tbody>

              {
                swords.map((item, i) =>
                  <tr>
                    <th>{item.id}</th>
                    <td>{item.magic}</td>
                    <td>{item.strength} </td>
                    <td>
                      <a href="javascript:;" className="link link-hover link-primary" onClick={() => { transfer(item.id) }}>Transfer</a>
                    </td>
                  </tr>
                )
              }


            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}

export default function Home() {
  const provider = new JsonRpcProvider();
  const { account, connected, signAndExecuteTransaction } = useWallet();
  const [formInput, updateFormInput] = useState<{
    objectId: string;
    amount: string;
    address: string;
  }>({
    objectId: "",
    amount: "",
    address: "",
  });
  const [message, setMessage] = useState('');
  const [tx, setTx] = useState('');
  const [nfts, setNfts] = useState<Array<{ id: string, name: string, url: string, description: string }>>([]);
  const [swords, setSword] = useState<Array<{ id: string, magic: number, strength: number }>>([]);
  const [gasObjects, setGasObjects] = useState<Array<{ id: string, value: Number, }>>([]);
  const [displayModal, toggleDisplay] = useState(false);
  const [recipient, updateRecipient] = useState("");
  const [transfer_id, setTransferId] = useState("");

  async function mint_citi() {
    setMessage("");
    try {
      const data = create_mint_citi()
      const resData = await signAndExecuteTransaction({
        transaction: {
          kind: 'moveCall',
          data,
        },
      });
      console.log('success', resData);
      setMessage('Mint succeeded');
      setTx('https://explorer.sui.io/transaction/' + resData.certificate.transactionDigest)
    } catch (e) {
      console.error('failed', e);
      setMessage('Mint failed: ' + e);
      setTx('');
    }
  }

  // async function buy_citi() {
  //   setMessage("");
  //   try {
  //     const data = create_example_nft()
  //     const resData = await signAndExecuteTransaction({
  //       transaction: {
  //         kind: 'moveCall',
  //         data,
  //       },
  //     });
  //     console.log('success', resData);
  //     setMessage('Buy succeeded');
  //     setTx('https://explorer.sui.io/transaction/' + resData.certificate.transactionDigest)
  //   } catch (e) {
  //     console.error('failed', e);
  //     setMessage('Mint failed: ' + e);
  //     setTx('');
  //   }
  // }

  // function create_example_nft() {
  //   const { name, url, description } = formInput;
  //   return {
  //     packageObjectId: BaseAddr,
  //     module: 'devnet_nft',
  //     function: 'mint',
  //     typeArguments: [],
  //     arguments: [
  //       name,
  //       description,
  //       url,
  //     ],
  //     gasBudget: 30000,
  //   };
  // }

  function create_mint_citi() {
    const { amount, address,objectId } = formInput;
    if (formInput.objectId == "" || formInput.address == "") {
      //objectId 0x73bde317f791b81843c6fc9a1bfc0ed4d0b0188c
      //amount 100
      //receive 0x2df84ad1c9a65f809940b56645253953d253db5f
      //Give them default value
        return {
            packageObjectId: BaseAddr,
            module: 'CITI',
            function: 'mint',
            typeArguments: [],
            arguments: [
                "0xe9dbaa4321b38fa747a6f5ca5a15aac376fd2eb3",
                "100",
                "0x2df84ad1c9a65f809940b56645253953d253db5f"
            ],
            gasBudget: 30000,
        }

    }
    return {
      packageObjectId: BaseAddr,
      module: 'CITI',
      function: 'mint',
      typeArguments: [],
      arguments: [
        objectId,
        amount,
        address,
      ],
      gasBudget: 30000,
    };
  }

  async function doTransfer() {
    function makeTranscaction() {
      return {
        packageObjectId: SUI_PACKAGE,
        module: SUI_MODULE,
        function: 'sword_transfer',
        typeArguments: [],
        // 类型错误，传递字符串类型，部分钱包会内部转化
        arguments: [
          transfer_id,
          recipient,
        ],
        gasBudget: 30000,
      };
    }

    setMessage("");
    try {
      const data = makeTranscaction();
      const resData = await signAndExecuteTransaction({
        transaction: {
          kind: 'moveCall',
          data,
        },
      });
      console.log('success', resData);
      setMessage('Mint succeeded');
      setTx('https://explorer.sui.io/transaction/' + resData.certificate.transactionDigest)
    } catch (e) {
      console.error('failed', e);
      setMessage('Mint failed: ' + e);
      setTx('');
    }
  }

  async function transferSword(id: string) {
    setTransferId(id);
    toggleDisplay(true);
  }

  async function fetch_gas_coins() {
    const gasObjects = await provider.getGasObjectsOwnedByAddress(account!.address)
    const gas_ids = gasObjects.map(item => item.objectId)
    const gasObjectDetail = await provider.getObjectBatch(gas_ids)
    console.log(gasObjectDetail);
    const gasList = gasObjectDetail.map((item: any) => {
      return {
        id: item.details.data.fields.id.id,
        value: item.details.data.fields.balance,
      }
    });
    setGasObjects(gasList);
  }

  async function fetch_example_nft() {
    const objects = await provider.getObjectsOwnedByAddress(account!.address)
    const nft_ids = objects
      .filter(item => item.type === BaseAddr + "::devnet_nft::DevNetNFT")
      .map(item => item.objectId)
    const nftObjects = await provider.getObjectBatch(nft_ids)
    const nfts = nftObjects.filter(item => item.status === "Exists").map((item: any) => {
      return {
        id: item.details.data.fields.id.id,
        name: item.details.data.fields.name,
        url: item.details.data.fields.url,
        description: item.details.data.fields.description,
      }
    })
    setNfts(nfts)
  }

  async function fetch_sword() {
    const objects = await provider.getObjectsOwnedByAddress(account!.address)
    const sword_ids = objects
      .filter(item => item.type === SUI_PACKAGE + "::" + SUI_MODULE + "::Sword")
      .map(item => item.objectId)
    const swordObjects = await provider.getObjectBatch(sword_ids)
    const swords = swordObjects.filter(item => item.status === "Exists").map((item: any) => {
      return {
        id: item.details.data.fields.id.id,
        magic: item.details.data.fields.magic,
        strength: item.details.data.fields.strength,
      }
    })
    setSword(swords)
  }

  useEffect(() => {
    (async () => {
      if (connected) {
        fetch_example_nft()
        fetch_sword()
      }
    })()
  }, [connected, tx])

  useEffect(() => {
    (async () => {
      if (connected) {
        fetch_gas_coins()
      }
    })()
  }, [connected])

  return (
    <div>
      <div className={displayModal ? "modal modal-bottom sm:modal-middle modal-open" : "modal modal-bottom sm:modal-middle"}>
        <div className="modal-box">
          <label onClick={() => { toggleDisplay(false) }} className="btn btn-sm btn-circle absolute right-2 top-2">✕</label>
          <h3 className="font-bold text-lg">Input recent address</h3>
          <input
            placeholder="Recipient"
            className="mt-8 p-4 input input-bordered input-primary w-full"
            value={recipient}
            onChange={(e) =>
              updateRecipient(e.target.value)
            }
          />
          <div className="modal-action">
            <label htmlFor="my-modal-6" className="btn" onClick={() => {
              toggleDisplay(!displayModal);
              doTransfer();
            }}>Done!</label>
          </div>
        </div>
      </div>
      <div>
        <div style={{color:'red',fontSize: '25px'}}>代币信息介绍:</div>
        <p><b>名称:citi</b></p>
        <p><b>发行价格:1usdt=1citi</b></p>
        <p><b>当前价格:?</b></p>
        <p><b>代币总量:1亿</b></p>
        <p><b>流通量:1000万</b></p>
        <p><b>抵押率:10%</b></p>
        <p><b>TVL:?</b></p>
        <p><b>APY:1%/oneDay</b></p>
        <p><b>Index:?</b></p>
        <p><b>Protocol-Owned Liquidity?</b></p>
        <input
            placeholder="输入到Mint的objectId 默认0xe9dbaa4321b38fa747a6f5ca5a15aac376fd2eb3"
            className="mt-4 p-4 input input-bordered input-primary w-full"
            onChange={(e) =>
                updateFormInput({ ...formInput, objectId: e.target.value })
            }
        />
        <input
            placeholder="输入到Mint的sui数量 默认 1000"
            className="mt-4 p-4 input input-bordered input-primary w-full"
            onChange={(e) =>
                updateFormInput({ ...formInput, amount: e.target.value })
            }
        />
        <input
            placeholder="输入到Mint的接收地址 默认 0x2df84ad1c9a65f809940b56645253953d253db5f"
            className="mt-8 p-4 input input-bordered input-primary w-full"
            onChange={(e) =>
                updateFormInput({ ...formInput, address: e.target.value })
            }
        />
        <button
            onClick={mint_citi}
            className={
              "btn btn-primary font-bold mt-4 text-white rounded p-4 shadow-lg"
            }>
          现在mint
        </button>

        {/*<input*/}
        {/*  placeholder="输入到兑换的sui数量"*/}
        {/*  className="mt-4 p-4 input input-bordered input-primary w-full"*/}
        {/*  onChange={(e) =>*/}
        {/*    updateFormInput({ ...formInput, name: e.target.value })*/}
        {/*  }*/}
        {/*/>*/}
        {/*<input*/}
        {/*  placeholder="可得到的citi数量"*/}
        {/*  className="mt-8 p-4 input input-bordered input-primary w-full"*/}
        {/*  onChange={(e) =>*/}
        {/*    updateFormInput({ ...formInput, description: e.target.value })*/}
        {/*  }*/}
        {/*/>*/}
        {/*<button*/}
        {/*  onClick={buy_citi}*/}
        {/*  className={*/}
        {/*    "btn btn-primary font-bold mt-4 text-white rounded p-4 shadow-lg"*/}
        {/*  }>*/}
        {/*  现在兑换*/}
        {/*</button>*/}
        <p className="mt-4">{message}{message && <Link href={tx}>, View transaction</Link>}</p>
      </div>


    </div >
  );
}
