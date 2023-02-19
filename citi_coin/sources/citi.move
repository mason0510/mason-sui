// ToDo
//fix this contract a float number add created time and end time as time to calculate the interest
module citi_coin::CITI{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::object::{ UID};
    use sui::tx_context::{Self, TxContext};
    use sui::balance::{ Balance};
    use sui::table::Table;
    use sui::table;

    struct CITI has drop,key,store {
    }

    //global
    struct Treasury has key, store {
        id: UID,
        balance: Balance<CITI>,
    }

    // struct Stake has key, store {
    //     id: UID,
    //     stakes: Table<address, u64>,
    //     start_epoch: u64,
    // }
    struct Stake has key, store {
        id: UID,
        stakes: Table<address, u64>,
    }

    // fun init(witness: CITI, ctx: &mut TxContext) {
    //     // witness.total_value = 100000000000000000;
    //     // Get a treasury cap for the coin and give it to the transaction sender
    //     let (treasury_cap, metadata) = coin::create_currency<CITI>(witness, 9, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx);
    //     transfer::freeze_object(metadata);
    //     transfer::transfer(treasury_cap, tx_context::sender(ctx))
    // }

    fun init(witness: CITI, ctx: &mut TxContext) {
        //record the treasury cap gloablly
        // transfer::share_object(Treasury {
        //     id: object::new(ctx),
        //     balance: balance::zero<CITI>(),
        // });
        let (treasury_cap, metadata) = coin::create_currency<CITI>(witness, 1, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx)
        sui::transfer::transfer(treasury_cap, tx_context::sender(ctx))
        transfer::freeze_object(metadata)
        transfer::share_object(
            Stake {
                id: object::new(ctx),
                stakes: table::new(ctx),
            }
        )

    }

    public entry fun mint(
        treasury_cap: &mut TreasuryCap<CITI>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    public entry fun burn(treasury_cap: &mut TreasuryCap<CITI>, coin: Coin<CITI>) {
        coin::burn(treasury_cap, coin);
    }

    // public(friend) fun stake(self: &mut Stake,citi: &Coin<CITI>, treasury_cap: &mut TreasuryCap<CITI>,ctx: &mut TxContext) {
    public(friend) fun stake(self: &mut Stake,ctx: &mut TxContext) {
        // transfer citi to stake pool
        // let amount  = coin::balance<CITI>(citi);
        let sender = tx_context::sender(ctx);
        // let oldCount = table::borrow(&self.stakes, sender);
        if (!table::contains(&self.stakes, sender)) {
            //amount to stake
            table::add(&mut self.stakes, sender,1000);
        } else {
           //  let newCount = oldCount + amount;
           // table::update(&mut self.stakes, sender, newCount);
            table::add(&mut self.stakes, sender,2000);
        };

    }

    public(friend) fun unstake(self: &Stake, myself: &mut Treasury, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        if (table::contains(&self.stakes, sender)) {
            let oldCount = table::borrow(&self.stakes, sender);
            if(*oldCount >= 1000 ){
                // let newCount = oldCount - amount;
                // ?? update newCount to table
                //transfer coin to sender ????
                let treasury_balance = &mut myself.balance;
                let coin = coin::take(treasury_balance, 1000, ctx);
                transfer::transfer(coin, sender);
            };
        } ;
    }

    //fixed
    public(friend) fun claim(treasury_cap: &mut TreasuryCap<CITI>, ctx: &mut TxContext) {
        //Get sender address
        let sender = tx_context::sender(ctx);
        //Get coin and transfer to sender
        // coin::mint_and_transfer(treasury_cap, 10000, sender, ctx)
        // if (table::contains(&self.stakes, sender)) {
        //     let oldCount = table::borrow(&self.stakes, sender)
        //     if(oldCount > 0 ){
        //         let profits = oldCount * 0.1; //10%
        //         coin::mint_and_transfer(treasury_cap, profits, receied, ctx)
        //     };
        // } ;
        coin::mint_and_transfer(treasury_cap, 10000, sender, ctx)
    }

    public fun supply_value<CITI>(): u64 {
        100000000
    }


    #[test]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(CITI{}, ctx);
    }

    #[test]
    public fun test_mint(treasury_cap: &mut TreasuryCap<CITI>, amount: u64, recipient: address, ctx: &mut TxContext) {
        // let (treasury_cap, metadata) = coin::create_currency<CITI>(CITI{}, 9, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx)
        let (treasury_cap, _) = coin::create_currency<CITI>(CITI{}, 9, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx);
        //consum the treasury_cap
        let  treasury_cap = &mut treasury_cap;
        mint(treasury_cap, 100, tx_context::sender(ctx), ctx);
        std::debug::print(treasury_cap);
    }


}

