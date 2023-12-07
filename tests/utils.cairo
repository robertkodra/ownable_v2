use starknet::{ContractAddress, testing};
use snforge_std::{declare, cheatcodes::contract_class::ContractClassTrait};

// mock addresses
// https://cairopractice.com
mod Accounts {
    use traits::TryInto;
    use starknet::{ContractAddress, contract_address_const};

    fn OWNER() -> ContractAddress {
        'owner'.try_into().unwrap()
    }

    fn NEW_OWNER() -> ContractAddress {
        'new_owner'.try_into().unwrap()
    }

    fn BAD_ACTOR() -> ContractAddress {
        'bad_actor'.try_into().unwrap()
    }

    fn ZERO() -> ContractAddress {
        contract_address_const::<0>()
    }
}

fn deploy_contract(constructor_args: Array<felt252>) -> ContractAddress {
    let contract = declare('CounterContract');
    return contract.deploy(@constructor_args).unwrap();
}