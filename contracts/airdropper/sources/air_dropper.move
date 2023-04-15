module air_dropper::air_dropper{

    use std::vector;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    const ENotEnoughCoin: u64 = 1;
    const ENumberNotMatch: u64 = 2;

    entry public fun airdrop_coins_equal<T>(airdrop_coin: &mut Coin<T>, receivers: vector<address>, uint_amount: u64, ctx: &mut TxContext) {
        let num_receivers: u64 = vector::length(&receivers);
        let require_amount = uint_amount * num_receivers;
        assert!(airdrop_coin.balance >= require_amount, ENotEnoughCoin);

        let deliver_coin: Coin<T> = coin::split<T>(airdrop_coin, require_amount, ctx);
        let to_deliver_coins: vector<Coin<T>> = deliver_coin.divide_into_n(num_receivers, ctx);

        for _ in 0..num_receivers {
            let receiver_address: address = vector::pop_back(&mut receivers);
            let to_deliver_coin: Coin<T> = vector::pop_back(&mut to_deliver_coins);
            transfer::transfer(to_deliver_coin, receiver_address);
        }

        airdrop_coin.join(deliver_coin);
    }

    entry public fun airdrop_coins_unequal<T>(airdrop_coin: &mut Coin<T>, receivers: vector<address>, amounts: vector<u64>, ctx: &mut TxContext) {
        let num_receivers: u64 = vector::length(&receivers);
        let num_amounts: u64 = vector::length(&amounts);

        assert!(num_receivers == num_amounts, ENumberNotMatch);

        let require_amount: u64 = 0;
        let calculation_amounts = amounts;

        for _ in 0..num_amounts {
            let amount: u64 = vector::pop_back(&mut calculation_amounts);
            require_amount = require_amount + amount;
        }

        assert!(airdrop_coin.balance >= require_amount, ENotEnoughCoin);

        for _ in 0..num_amounts {
            let amount: u64 = vector::pop_back(&mut calculation_amounts);
            let to_deliver_coin: Coin<T> = airdrop_coin.split(amount, ctx);
            let receiver_address: address = vector::pop_back(&mut receivers);
            transfer::transfer(to_deliver_coin, receiver_address);
        }

    }

}