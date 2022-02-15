pragma solidity ^0.5.5;

import "./AudioCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

/* This crowdsale contract will manage the entire process, allowing users to send ETH and get back AUDIO (AudioCoin).
This contract will mint the tokens automatically and distribute them to buyers all in one transaction.
*/

/* 
It will need to inherit Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, and MintedCrowdsale.
*/
contract AudioCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, 
RefundablePostDeliveryCrowdsale {

    constructor(

        uint rate, // rate in TKNbits
        address payable wallet, // token sale beneficiary manual address
        AudioCoin token, // the AudioCoin token itself that the AudioCoinSale contract will work with
        uint fakenow,
        // In the original AudioCoincoinsale, close = now + 24 weeks (crowdsale runtime)
        // For test purposes only, a) a variable "fakenow" is created and b) close = fakenow + 1 minutes
        uint close,
        uint goal
    )
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        //TimedCrowdsale(open = now, close = now + 1 minutes) in this case
        //        TimedCrowdsale(fakenow, fakenow + 1 minutes)
        //TimedCrowdsale(open = fakenow, close = fakenow + 24 weeks)
        TimedCrowdsale(now, now + 24 weeks)

        RefundableCrowdsale(goal)

        public
    {

    }
}

contract AudioCoinSaleDeployer {

    address public audio_token_address;
    address public token_address;

    constructor(

        string memory name,
        string memory symbol,
        address payable wallet, // this address will receive all ETH raised by the sale
        uint goal
        //uint fakenow
    )
        public
    {
        // creation of the AudioCoin token and its address
        AudioCoin token = new AudioCoin(name, symbol, 0);
        token_address = address(token);

        // create the AudioCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        //AudioCoinSale audio_token = new AudioCoinSale(1, wallet, token, goal, fakenow, fakenow + 2 minutes);
        AudioCoinSale audio_token = new AudioCoinSale(
                            1, // = 1 wei
                            wallet, // = address collecting the tokens
                            token, // = token sales
                            goal, // = maximum supply of tokens 
                            now, 
                            now + 24 weeks);
                            //replace now by fakenow to get a test function

        //To test the time functionality for a shorter period of time: use fake now for start time and close time to be 1 min, etc.
        //AudioCoinSale audio_token = new AudioCoinSale(1, wallet, token, goal, fakenow, now + 5 minute);
        audio_token_address = address(audio_token);

        // make the AudioCoinSale contract a minter, then have the AudioCoinSaleDeployer renounce its minter role
        token.addMinter(audio_token_address);
        token.renounceMinter();
    }
}
