module repo_handler::repo_handler{

    use std::string::{Self, String};
    use std::option::Option;
    // use std::vector;
    use sui::object::{Self, UID};
    // use sui::url::{Self, Url};
    use sui::transfer;
    // use sui::vec_set::{Self, VecSet};
    use sui::tx_context::{Self, TxContext};

    struct Repo has key, store {
        id: UID,
        name: String,
        owner: String,
        description: Option<String>,
        logo: Option<String>,
        repo_url: String,
        verification_url: Option<String>,
        sub_repoes: Option<String>,
        contributors: String,
        plugins: Option<String>
    }

    public entry fun mint_repo(
        name: vector<u8>, 
        owner: vector<u8>, 
        description: vector<u8>, 
        logo: vector<u8>, 
        repo_url: vector<u8>, 
        verification_url: vector<u8>, 
        sub_repoes: vector<u8>,
        contributors: vector<u8>,
        plugins: vector<u8>,
        ctx: &mut TxContext) {
        let repo: Repo = new_repo_obj(name, owner, description, logo, repo_url, verification_url, sub_repoes, contributors, plugins, ctx);
        transfer::transfer(repo, tx_context::sender(ctx));
    }

    public entry fun burn_repo(repo_obj: Repo) {
        let Repo {id, name: _, owner: _, description: _, logo: _, repo_url: _, verification_url: _, sub_repoes: _, contributors: _, plugins: _ } = repo_obj;
        object::delete(id);
    }

    fun new_repo_obj(
        name: vector<u8>, 
        owner: vector<u8>, 
        description: vector<u8>, 
        logo: vector<u8>, 
        repo_url: vector<u8>, 
        verification_url: vector<u8>, 
        sub_repoes: vector<u8>,
        contributors: vector<u8>,
        plugins: vector<u8>,
        ctx: &mut TxContext): Repo {
        let id = object::new(ctx);
        Repo {
            id,
            name: string::utf8(name),
            owner: string::utf8(owner),
            description: string::try_utf8(description),
            logo: string::try_utf8(logo),
            repo_url: string::utf8(repo_url),
            verification_url: string::try_utf8(verification_url), 
            sub_repoes: string::try_utf8(sub_repoes),
            contributors: string::utf8(contributors),
            plugins: string::try_utf8(plugins)
        }
    }
    
}