use starknet::{ ContractAddress, account::Call };
use snforge_std::{ 
    declare,
    cheatcodes::contract_class::ContractClassTrait
};
use snforge_std::signature::{ interface::Signer, StarkCurveKeyPair };
use snforge_std::{ TxInfoMock, TxInfoMockTrait };

fn deploy_contract(initial_counter: u32) -> ContractAddress {
    let contract = declare('CounterContract');
    let constructor_args = array![initial_counter.into()];
    return contract.deploy(@constructor_args).unwrap();
}
