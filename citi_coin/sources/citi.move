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

