use starknet::{ContractAddress};
use snforge_std::{declare, cheatcodes::contract_class::ContractClassTrait};

// mock addresses
// https://cairopractice.com
mod Accounts {
    use traits::TryInto;
    use starknet::{ContractAddress};

    fn OWNER() -> ContractAddress {
        'owner'.try_into().unwrap()
    }

    fn NEW_OWNER() -> ContractAddress {
        'new_owner'.try_into().unwrap()
    }

    fn BAD_ACTOR() -> ContractAddress {
        'bad_actor'.try_into().unwrap()
    }
}

fn deploy_contract(constructor_args: Array<felt252>) -> ContractAddress {
    let contract = declare('CounterContract');
    return contract.deploy(@constructor_args).unwrap();
}

