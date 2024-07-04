// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {KonversiHarga} from "./KonversiHarga.sol";

error DanaiSaya__BukanPemilik();

contract DanaiSaya {
    using KonversiHarga for uint256;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    address[] public pendanai;
    mapping(address pendana => uint256 jumlahDiDanai) public addressKeJumlahPendanai;
    address public immutable i_pemilik;

    constructor() {
        i_pemilik = msg.sender;
    }

    function danai() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Dana ETH Tidak mencukupi");
        addressKeJumlahPendanai[msg.sender] += msg.value;
        pendanai.push(msg.sender);
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    modifier hanyaPemilik {
        // require(msg.sender == i_pemilik, "Pengirim bukan si Pemilik"); atau
        if (msg.sender != i_pemilik) revert DanaiSaya__BukanPemilik();
        _;
    }

    function tarik() public hanyaPemilik {
        for (uint256 pendanaIndex = 0; pendanaIndex < pendanai.length; pendanaIndex++) 
        {
            // code
            address pendana = pendanai[pendanaIndex];
            addressKeJumlahPendanai[pendana] = 0;
        }
        // reset the array
        pendanai = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call gagal");
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    receive() external payable {
        danai();
    }
    fallback()external payable {
        danai();
    }
}