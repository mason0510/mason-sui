// ToDo
//fix this contract a float number add created time and end time as time to calculate the interest
module citi_coin::CITI{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::table;
    use sui::object::UID as MyUID;
    use sui::balance;
    use sui::table::Table;
    use sui::object;

    // index: u64 = 0;
    //define a index stuct
    struct Index has key, store, drop {
        index: u64
    }


    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be `COIN<MANAGED>`.
    struct CITI has drop {
    }

    // define a struct
    struct Stake has key, store, drop {
        id: UID,
        address:address,
        mybalance: balance::Balance<CITI>,

    }

    struct MyTable has key, store {
        id: UID,
        children: Table<u64, Stake>,
    }
    /// Register the CITIcurrency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: CITI, ctx: &mut TxContext) {
        //9 位
        // witness.total_value = 100000000000000000;
        // Get a treasury cap for the coin and give it to the transaction sender
        let (treasury_cap, metadata) = coin::create_currency<CITI>(witness, 9, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx);
        transfer::freeze_object(metadata);
        transfer::transfer(treasury_cap, tx_context::sender(ctx))
    }

    /// Manager can mint new coins
    /// add more coins supply
    public entry fun mint(
        treasury_cap: &mut TreasuryCap<CITI>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    /// Manager can burn coins
    public entry fun burn(treasury_cap: &mut TreasuryCap<CITI>, coin: Coin<CITI>) {
        coin::burn(treasury_cap, coin);
    }


    //stake
    //from current address to current contract address
    public entry fun stake(treasury_cap: &mut TreasuryCap<CITI>,coin: &Coin<CITI> , ctx: &mut TxContext) {
        //amount  address
        // define  a Stake
        // let stakePerson = Stake{myUid,myaddress,mybalance};

        //get current address
        let sender = tx_context::sender(ctx);
        //get current object balance
        let balance = coin::balance<CITI>(coin);
        // set a struct

        //transfer coin to current contract address
        //burn coin
        //&Coin<CITI> to Coin<CITI>
        // let coin = *coin;
        coin::burn(treasury_cap, *coin);
        //record the stake amount
        // let balance = *balance;
        //Get current Index length
        // let length=table::length(&child.children);
        table::borrow(&mut Index.index, 0);
        //old + amount as  new balance
        //+1
        // let index = length + 1;
        let myUid=object::new(ctx);
        record_stake(ctx,myUid,sender,balance);
    }
    /// record the stake amount and save into table
    fun record_stake(ctx: &mut TxContext,myUid:UID, myaddress :address,mybalance : sui::coin::Balance<CITI>) {
        //save the stake amount and stake sender address into table
        //get current object id
        //set index a UID
        // let myindex = UID::new(index);
        //from address to UID
        // let myaddress = object::id_from_address(myaddress);
        // let stakePerson = Stake{myUid,myaddress,mybalance};
        // let stakePerson = Stake{myUid,myaddress::address,mybalance};
        //define a new table
        let stakePerson = Stake{ id:myUid, address:myaddress, mybalance:mybalance};
        let mytable = MyTable{ id:myUid, children: Stake};
        //get current Index length
        //address to key
        let myaddress = object::id_from_address(myaddress);
        sui::table::add(  *mytable,myaddress, stakePerson);
    }

    //unstake
    // mint coin to current address and then delete the record
    public entry fun unstake(treasury_cap: &mut TreasuryCap<CITI>,child: &mut MyTable, index: u64, ctx: &mut TxContext) {
        //get current address
        let sender = tx_context::sender(ctx);
        //get the stake index and balance
        let Stake { id,address, mybalance} = table::remove(
            &mut MyTable.children,
            index
        );
        //delete the record
        object::delete(id);
        //transfer
        coin::mint_and_transfer(treasury_cap, *mybalance, sender, ctx);
    }

    //claim citi coin as interest
    //cycle * rate as interest by stake amount
    //now set a rate 0.1 as 10% as a fixed value
    //example: stake 1000 citi coin, 10% amount, interest 100 citi coin,and then mint 100 citi coin to current address
    public entry fun claim(treasury_cap: &mut TreasuryCap<CITI>,child: &mut MyTable, index: u64, cycle: u64, ctx: &mut TxContext) {
        //get current address
        let sender = tx_context::sender(ctx);
        //get the stake index and balance
        //struct how  go get data  amount
        let Stake { id,address, mybalance} = table::remove(
            &mut MyTable.children,
            index
        );
        //calculate the interest
        let value=*mybalance;
        // Take out mybalance
        //amount 10%
        let interest = value * 10 / 100;
        coin::mint_and_transfer(treasury_cap, interest, sender, ctx);
    }


    #[test]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(CITI{}, ctx)
        //debug::print(v);
    }

    #[test]
    public fun test_mint(treasury_cap: &mut TreasuryCap<CITI>, amount: u64, recipient: address, ctx: &mut TxContext) {
        // let (treasury_cap, metadata) = coin::create_currency<CITI>(CITI{}, 9, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx)
        let (treasury_cap, _) = coin::create_currency<CITI>(CITI{}, 9, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx);
        //consum the treasury_cap
        // let  treasury_cap = &mut treasury_cap;
        //drop the metadata
        // //Incompatible type 'TreasuryCap<CITI>', expected '&mut TreasuryCap<CITI>'
        // // let mut treasury_cap = treasury_cap;
        // // define treasury_cap: &mut TreasuryCap<CITI>,
        let  treasury_cap = &mut treasury_cap;
        mint(treasury_cap, 100, tx_context::sender(ctx), ctx)
        //println!("result is {}",result);
    }

    // #[test]
    // /// Wrapper of module initializer for testing
    // public fun test_burn(ctx: &mut TxContext) {
    //     init(CITI{}, ctx)
    // }
    //
    // #[test_only]
    // /// Wrapper of module initializer for testing
    // public fun test_stake(ctx: &mut TxContext) {
    //     init(CITI{}, ctx)
    // }
    //
    // #[test_only]
    // /// Wrapper of module initializer for testing
    // public fun test_unstake(ctx: &mut TxContext) {
    //     init(CITI{}, ctx)
    // }
    //
    // #[test_only]
    // /// Wrapper of module initializer for testing
    // public fun test_claim(ctx: &mut TxContext) {
    //     init(CITI{}, ctx)
    // }

}

