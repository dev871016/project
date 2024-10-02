// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./Project.sol";

contract ProjectFactory {
    address owner;
    address token;

    event CreateProject(
        address indexed owner,
        address indexed project,
        string name,
        string location,
        string description,
        uint256 totalBalance
    );

    modifier onlyOwner(address _owner) {
        require(_owner == msg.sender, "Invalid owner!");
        _;
    }

    constructor(address _token) {
        owner = msg.sender;
        token = _token;
    }

    function createProject(
        address _owner,
        string calldata _name,
        string calldata _location,
        string calldata _description,
        uint256 _totalBalance
    ) public onlyOwner(owner) {
        Project project = new Project(
            _owner,
            token,
            _name,
            _location,
            _description,
            _totalBalance
        );

        emit CreateProject(
            _owner,
            address(project),
            _name,
            _location,
            _description,
            _totalBalance
        );
    }
}
