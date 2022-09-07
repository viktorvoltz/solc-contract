// a vulnerable Ethereum vault that allows depositors to withdraw only 1 ether per week
//@dev vulnerability is on line 19

contract EtherStore {
    uint256 public withdrawLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiTowithdraw);

        require(_weiToWithdraw <= withdrawLimit);

        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        require(msg.sender.call.value(_weiToWithdraw)());
        balances[msg.sender] -= _weiToWithdraw;

        lastWithdrawTime[msg.sender] = now;
    }
}
