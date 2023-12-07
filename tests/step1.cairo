use ownable::counter::{ ICounterContractDispatcher, ICounterContractDispatcherTrait };

use super::utils::deploy_contract;

#[test]
fn check_stored_counter() {
    let initial_counter = 12;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher{ contract_address };
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter, 'Wrong Stored Counter');
}

#[test]
fn check_increase_counter() {
    let initial_counter = 0;
    let contract_address = deploy_contract(initial_counter);
    let dispatcher = ICounterContractDispatcher{ contract_address };
    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, 'Wrong Increase Counter');
}