contract owned {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }
}

contract mortal is owned {
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

contract Faucet is mortal {
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    // Give out ether to anyone who asks
    function withdraw(uint256 withdraw_amount) public {
        // Limit withdrawal amount
        require(withdraw_amount <= 0.1 ether);
        require(this.balance >= withdraw_amount, "insufficient balance");
        // Send the amount to the address that requested it
        msg.sender.transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    }

    // Accept any incoming amount
    function() public payable {
        emit Deposit(msg.sender, msg.value);
    }
}
