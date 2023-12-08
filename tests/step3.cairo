use core::traits::Into;
use ownable::counter::{ICounterContractDispatcher, ICounterContractDispatcherTrait};
use snforge_std::{start_prank, stop_prank, CheatTarget};
use super::utils::{deploy_contract, Accounts};
use starknet::{get_caller_address, ContractAddress, testing};

use ownable::ownable::{OwnableComponent};
use OwnableComponent::{InternalImpl, OwnableImpl};


#[starknet::contract]
mod MockContract {
    use ownable::ownable::{OwnableComponent};

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;

    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnableEvent: OwnableComponent::Event
    }
}

type TestingState = OwnableComponent::ComponentState<MockContract::ContractState>;

impl TestingStateDefault of Default<TestingState> {
    fn default() -> TestingState {
        OwnableComponent::component_state_for_testing()
    }
}

#[generate_trait]
impl TestingStateImpl of TestingStateTrait {
    fn new_with(owner: ContractAddress) -> TestingState {
        let mut ownable: TestingState = Default::default();
        ownable.initializer(owner);
        ownable
    }
}

#[test]
fn test_ownable_initializer() {
    let mut ownable: TestingState = Default::default();
    assert(ownable.owner().is_zero(), 'owner should be zero');

    ownable.initializer(Accounts::OWNER());

    assert(ownable.owner() == Accounts::OWNER(), 'Owner should be set');
}

#[test]
fn test_assert_only_owner() {
    let mut ownable: TestingState = TestingStateTrait::new_with(Accounts::OWNER());
    start_prank(CheatTarget::All, Accounts::OWNER());
    ownable.assert_only_owner();
    stop_prank(CheatTarget::All);
}

#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_assert_only_owner_not_owner() {
    let mut ownable: TestingState = TestingStateTrait::new_with(Accounts::OWNER());
    start_prank(CheatTarget::All, Accounts::BAD_ACTOR());
    ownable.assert_only_owner();
    stop_prank(CheatTarget::All);   
}