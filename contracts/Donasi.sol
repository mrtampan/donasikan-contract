// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Donasi {
    uint104 public orderId;

    struct DonasiData {
        string name;
        string message;
        address addressDonatur;
        uint amount;
    }

    mapping(uint104 => DonasiData[]) public donasiData;

    event DonasiNote(
        uint104 indexed orderId,
        string name,
        string message,
        address indexed addressDonatur,
        uint amount
    );

    function getOrderId() external view returns (uint104) {
        return orderId;
    }

    function incrementOrderId() private {
        orderId += 1;
    }

    function donasi(
        string memory name,
        string memory message,
        address payable addressDonatur
    ) external payable returns (uint104) {
        // amount is the exact value to forward to addressDonatur
        require(msg.value > 0, "Amount harus lebih dari 0");
        require(addressDonatur != address(0), "Alamat donatur tidak valid");

        // Record the donation (store the provided amount)
        DonasiData memory newDonasi = DonasiData({
            name: name,
            message: message,
            addressDonatur: addressDonatur,
            amount: msg.value
        });

        // Effects: increment state and store donation
        incrementOrderId();
        donasiData[orderId].push(newDonasi);
        emit DonasiNote(orderId, name, message, addressDonatur, msg.value);

        // Interaction: send the provided amount to the donor address
        (bool success, ) = addressDonatur.call{value: msg.value}("");
        require(success, "Transfer gagal");

        return orderId;
    }
}
