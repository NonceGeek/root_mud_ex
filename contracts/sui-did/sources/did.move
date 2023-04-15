module my_addr::did  {
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::table::{Self, Table};
    use std::string::{String};
    
    struct Did has key, store {
        id: UID,
        items: Table<String, address>,
    }

    /// On module init
    fun init(ctx: &mut TxContext) {
        transfer::transfer(Did {
            id: object::new(ctx),
            items: table::new(ctx),
        }, tx_context::sender(ctx));
    }

    public entry fun add_item(
        did: &mut Did, 
        name: String, 
        addr: address,
        _: &mut TxContext
    ) {
        table::add(&mut did.items, name, addr);
    }

    public entry fun delete_item( 
        did: &mut Did, 
        name: String
    ) {
        table::remove(&mut did.items, name);
    }
}
