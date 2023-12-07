use core::traits::Into;
use ownable::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};
use ownable::counter::{IOwnableDispatcher, IOwnableDispatcherTrait};
use snforge_std::{start_prank, stop_prank, CheatTarget};
use super::utils::{deploy_contract, Accounts};
use debug::PrintTrait;
use starknet::{get_caller_address};

#[test]
fn check_increase_counter_as_owner() {
    let initial_counter = 0;
    let constructor_args = array![initial_counter.into(), Accounts::owner().into()];
    let contract_address = deploy_contract(constructor_args);
    let dispatcher = ICounterContractDispatcher { contract_address };
    start_prank(CheatTarget::One(contract_address), Accounts::owner());
    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, 'Wrong Increase Counter');
    stop_prank(CheatTarget::One(contract_address));
}


#[test]
#[should_panic(expected: ('Caller is not the owner', ))]
fn check_increase_counter_as_bad_actor() {
    let initial_counter = 0;
    let constructor_args = array![initial_counter.into(), Accounts::owner().into()];
    let contract_address = deploy_contract(constructor_args);
    let dispatcher = ICounterContractDispatcher{ contract_address };

    start_prank(CheatTarget::One(contract_address), Accounts::bad_actor());
    dispatcher.increase_counter();
    let stored_counter = dispatcher.get_counter();
    assert(stored_counter == initial_counter + 1, 'Wrong Increase Counter');
    stop_prank(CheatTarget::One(contract_address));
}

#[test]
fn check_transfer_ownership_as_owner() {
    let initial_counter = 0;
    let constructor_args = array![initial_counter.into(), Accounts::owner().into()];
    let contract_address = deploy_contract(constructor_args);
    let dispatcher = IOwnableDispatcher{ contract_address };

    start_prank(CheatTarget::One(contract_address), Accounts::owner());
    dispatcher.transfer_ownership(Accounts::new_owner());
    let current_owner = dispatcher.owner();
    assert(current_owner == Accounts::new_owner(), 'Owner not changed');
    stop_prank(CheatTarget::One(contract_address));
}