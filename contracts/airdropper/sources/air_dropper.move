module air_dropper::air_dropper{

    use std::vector;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context::TxContext;

    const ENotEnoughCoin: u64 = 1;
    const ENumberNotMatch: u64 = 2;

    entry public fun airdrop_coins_equal<T>(airdrop_coin: &mut Coin<T>, receivers: vector<address>, uint_amount: u64, ctx: &mut TxContext) {
        let num_receivers: u64 = vector::length(&receivers);
        let require_amount = uint_amount * num_receivers;
        assert!(coin::value(airdrop_coin) >= require_amount, ENotEnoughCoin);

        let i = 0;
        while (i < num_receivers) {
            let receiver_address: address = vector::pop_back(&mut receivers);
            let to_deliver_coin: Coin<T> = coin::split(airdrop_coin, uint_amount, ctx);
            transfer::public_transfer(to_deliver_coin, receiver_address);
            i = i + 1;
        };

    }

    entry public fun airdrop_coins_unequal<T>(airdrop_coin: &mut Coin<T>, receivers: vector<address>, amounts: vector<u64>, ctx: &mut TxContext) {
        let num_receivers: u64 = vector::length(&receivers);
        let num_amounts: u64 = vector::length(&amounts);

        assert!(num_receivers == num_amounts, ENumberNotMatch);

        let require_amount: u64 = 0;
        let calculation_amounts = amounts;

        let i = 0;
        while (i < num_receivers) {
            let amount: u64 = vector::pop_back(&mut calculation_amounts);
            require_amount = require_amount + amount;
            i = i + 1;
        };

        assert!(coin::value(airdrop_coin) >= require_amount, ENotEnoughCoin);

        let i = 0;
        while (i < num_receivers) {
            let amount: u64 = vector::pop_back(&mut calculation_amounts);
            let to_deliver_coin: Coin<T> = coin::split(airdrop_coin, amount, ctx);
            let receiver_address: address = vector::pop_back(&mut receivers);
            transfer::public_transfer(to_deliver_coin, receiver_address);
            i = i + 1;
        };

    }

}