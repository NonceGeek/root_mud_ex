module my_addr::did  {
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::table::{Self, Table};
    use std::string::{String};
    use std::vector;
    
    struct Did has key, store {
        id: UID,
        items: vector<String>,
        items_table: Table<String, address>,
    }

    /// On module init
    fun init(ctx: &mut TxContext) {
        transfer::transfer(Did {
            id: object::new(ctx),
            items: vector::empty(),
            items_table: table::new(ctx),
        }, tx_context::sender(ctx));
    }

    public entry fun add_item(
        did: &mut Did, 
        name: String, 
        addr: address,
        _: &mut TxContext
    ) {
        table::add(&mut did.items_table, name, addr);
        vector::push_back(&mut did.items, name);
    }

    public entry fun delete_item( 
        did: &mut Did, 
        name: String
    ) {
        table::remove(&mut did.items_table, name);

        let length = vector::length(&mut did.items);
        let i = 0;
        while (i < length) {
            let one_name = vector::borrow(&mut did.items, i);
            if (*one_name == name) {
                vector::remove(&mut did.items, i);
                break
            };
            i = i + 1;
        }
    }
}
