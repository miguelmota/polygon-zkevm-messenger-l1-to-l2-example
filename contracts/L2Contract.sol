//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract L2Contract {
    string private greeting;
    address l1Contract;
    address l2Bridge;
    address private caller;

    constructor(address _l1Contract, address _l2Bridge) {
      l1Contract = _l1Contract;
      l2Bridge = _l2Bridge;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function onMessageReceived(address originAddress, uint32 originNetwork, bytes memory data) external payable {
      require(originAddress == l1Contract);
      require(originNetwork == 0);
      caller = originAddress;
      (bool success, ) = address(this).call(data);
      if (!success) {
        revert('metadata execution failed');
      }
      caller = address(0);
    }

    function setGreeting(string memory _greeting) public {
        require(caller == l1Contract);
        greeting = _greeting;
    }
}
