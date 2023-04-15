module repo_handler::repo_handler{

    use std::string::{String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct Repo has key, store {
        id: UID,
        name: String,
        owner: String,
        description: String,
        logo: String,
        repo_url: String,
        verification_url: String,
        sub_repoes: String,
        contributors: String,
        plugins: String
    }

    public entry fun mint_repo(
        name: String, 
        owner: String, 
        description: String, 
        logo: String, 
        repo_url: String, 
        verification_url: String, 
        sub_repoes: String,
        contributors: String,
        plugins: String,
        ctx: &mut TxContext) {
        let repo: Repo = new_repo_obj(name, owner, description, logo, repo_url, verification_url, sub_repoes, contributors, plugins, ctx);
        transfer::transfer(repo, tx_context::sender(ctx));
    }

    public entry fun burn_repo(repo_obj: Repo) {
        let Repo {id, name: _, owner: _, description: _, logo: _, repo_url: _, verification_url: _, sub_repoes: _, contributors: _, plugins: _ } = repo_obj;
        object::delete(id);
    }

    fun new_repo_obj(
        name: String, 
        owner: String, 
        description: String, 
        logo: String, 
        repo_url: String, 
        verification_url: String, 
        sub_repoes: String,
        contributors: String,
        plugins: String,
        ctx: &mut TxContext): Repo {
        let id = object::new(ctx);
        Repo {
            id,
            name: name,
            owner: owner,
            description: description,
            logo: logo,
            repo_url: repo_url,
            verification_url: verification_url, 
            sub_repoes: sub_repoes,
            contributors: contributors,
            plugins: plugins,
        }
    }
    
}