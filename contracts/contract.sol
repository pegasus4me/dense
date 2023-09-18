// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9;

library safeMath  {
 function add(uint self, uint b) external pure returns (uint)  {
   return self+b;
 }
}


contract transporter {
    using safeMath for uint;
}