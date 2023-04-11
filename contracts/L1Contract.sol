//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IBridge.sol";

contract L1Contract {
    address l1Bridge;

    constructor(address _l1Bridge) {
      l1Bridge = _l1Bridge;
    }

    function sendMessageToL2(address _to, bytes memory _calldata) payable public {
      IBridge bridge = IBridge(l1Bridge);
      uint32 destinationNetwork = 1;
      bool forceUpdateGlobalExitRoot = true;
      bridge.bridgeMessage{value: msg.value}(
        destinationNetwork,
        _to,
        forceUpdateGlobalExitRoot,
        _calldata
      );
    }
}
