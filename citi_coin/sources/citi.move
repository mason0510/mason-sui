// ToDo
//fix this contract a float number add created time and end time as time to calculate the interest
module citi_coin::CITI{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::object::{Self, ID, UID};
    use sui::tx_context::{Self, TxContext};
    const ENonZero: u64 = 0;
    /// For when an overflow is happening on Supply operations.
    const EOverflow: u64 = 1;
    /// For when trying to withdraw more than there is.
    const ENotEnough: u64 = 2;

    /// The maximum unsigned bits that the coin value should be
    const MAX_COIN_BIT: u64 = 64;

    struct Supply has store {
        value: u64
    }


    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be `COIN<MANAGED>`.
    struct CITI has drop {
    }

    struct Stake has key, store, drop {
        id: UID,
        pool:address,
        stakes: Table<address, u64>,
        start_epoch: u64,
    }

    /// Register the CITIcurrency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: CITI, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let (treasury_cap, metadata) = coin::create_currency<CITI>(witness, 1, b"CITI", b"citi", b"one new stable coin on sui blockchain", option::none(), ctx);
        transfer::freeze_object(metadata);

        transfer::share_object(
            Stake {
                id: object::new(ctx),
                pool:tx_context::sender(ctx), //??
                stakes: table::new(ctx),
            }
        );

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


    public(friend) fun stake(self: &Stake, citi: Coin<CITI>, ctx: &mut TxContext) {
        // transfer citi to stake pool

        let amount = = coin::balance<CITI>(citi);
        transfer::transfer(citi, self.pool);

        let sender = tx_context::sender(ctx);
        if (!table::contains(&self.stakes, sender)) {
            table::add(&mut self.stakes, sender, amount);
        } else {
            let oldCount = table::borrow(&self.stakes, sender)
            let newCount = oldCount + amount
            // ?? update newCount to stake
            ??
        };

    }

    public(friend) fun unstake(self: &Stake, treasury_cap: &mut TreasuryCap<CITI>, ctx: &mut TxContext) {
        //
        let sender = tx_context::sender(ctx);
        if (table::contains(&self.stakes, sender)) {
            let oldCount = table::borrow(&self.stakes, sender)
            if(oldCount >= amount ){
                let newCount = oldCount - amount;
                // ?? update newCount to table

                //transfer coin to sender ????
                let coin = coin::take(&mut self.pool, amount, ctx);
                transfer::transfer(coin, sender);
            };
        } ;
    }

    //fixed
    public(friend) fun claim(receied: address, treasury_cap: &mut TreasuryCap<CITI>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        if (table::contains(&self.stakes, sender)) {
            let oldCount = table::borrow(&self.stakes, sender)
            if(oldCount > 0 ){
                let profits = oldCount * 0.1; //10%
                coin::mint_and_transfer(treasury_cap, profits, receied, ctx)
            };
        } ;
    }


    //for test
    public fun supply_value<CITI>(): u64 {
        100000000
    }



    //闪电贷
    use sui::object::{Self, ID, UID};
    use sui::table::Table;

    struct AdminCap has key, store {
        id: UID,
        flash_lender_id: ID,
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

