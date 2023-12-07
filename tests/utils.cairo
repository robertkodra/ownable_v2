use starknet::{ContractAddress, account::Call};
use snforge_std::{declare, cheatcodes::contract_class::ContractClassTrait};
use snforge_std::signature::{interface::Signer, StarkCurveKeyPair};
use snforge_std::{TxInfoMock, TxInfoMockTrait};

// mock addresses
// https://cairopractice.com
mod Accounts {
    use traits::TryInto;
    use starknet::{ContractAddress};

    fn owner() -> ContractAddress {
        'owner'.try_into().unwrap()
    }

    fn new_owner() -> ContractAddress {
        'new_owner'.try_into().unwrap()
    }

    fn bad_actor() -> ContractAddress {
        'bad_actor'.try_into().unwrap()
    }
}

fn deploy_contract(constructor_args: Array<felt252>) -> ContractAddress {
    let contract = declare('CounterContract');
    return contract.deploy(@constructor_args).unwrap();
}

