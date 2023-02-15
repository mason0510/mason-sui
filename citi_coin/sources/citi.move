module citi_coin::CITI{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// Name of the coin. By convention, this type has the same name as its parent module
    /// and has no fields. The full type of the coin defined by this module will be `COIN<MANAGED>`.
    struct CITI has drop {}

    /// Register the CITIcurrency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: CITI, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction sender
        let (treasury_cap, metadata) = coin::create_currency<CITI>(witness, 9, b"CITI", b"", b"", option::none(), ctx);
        transfer::freeze_object(metadata);
        transfer::transfer(treasury_cap, tx_context::sender(ctx))
    }

    /// Manager can mint new coins
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




    //unstake



    //claim citi coin



    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(CITI{}, ctx)
    }
}