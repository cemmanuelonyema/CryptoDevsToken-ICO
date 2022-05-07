 //SPDX-License-Identifier:MIT
 pragma solidity ^0.8.4;

 import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
 import '@openzeppelin/contracts/access/Ownable.sol';
 import './IntCryptoDevs.sol';

 contract CryptoDevToken is ERC20, Ownable{
     //Price of one crypto dev token
     uint256 public constant tokenPrice = 0.001 ether;
       // Each NFT would give the user 10 tokens
      // It needs to be represented as 10 * (10 ** 18) as ERC20 tokens are represented by the smallest denomination possible for the token
      // By default, ERC20 tokens have the smallest denomination of 10^(-18). This means, having a balance of (1)
      // is actually equal to (10 ^ -18) tokens.
      // Owning 1 full token is equivalent to owning (10^18) tokens when you account for the decimal places.
       uint256 public constant tokensPerNFT = 10 * 10 **18;
       //the max total supply is 10000 for crypto dev tokens
       uint256 public constant maxTotalSupply = 10000 * 10**18;
       //CryptoDevsNFT contract instance
       IntCryptoDevs CryptoDevsNFT;
       //Mapping to keep track of which tokenIds have been claimed
       mapping(uint256 => bool) public tokenIdsClaimed;

       constructor(address _cryptoDevsContract)  ERC20('Crypto Dev Token', 'CD'){
           CryptoDevsNFT = IntCryptoDevs(_cryptoDevsContract);
       }

  /**
       * @dev Mints tokens based on the number of NFT's held by the sender
       * Requirements:
       * balance of Crypto Dev NFT's owned by the sender should be greater than 0
       * Tokens should have not been claimed for all the NFTs owned by the sender
       */
       function claim() public {
           address sender = msg.sender;
           //get the  number of cryptoDev NFT's held by a given sender address
           uint256 balance = CryptoDevsNFT.balanceOf(sender);
           //if the balance is zero, revert the transaction
           require(balance > 0, 'You dont own any Crypto Dev NFTs');
           //amount keeps track of number of unclaimed tokenIds
           uint256 amount = 0;
           //loop over the balance and get the token ID owned by sender at a given 'index' of it's token list.
           for (uint256 i = 0; i < balance; i++){
               uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
                // if the tokenId has not been claimed, increase the amount
              if (!tokenIdsClaimed[tokenId]) {
                  amount += 1;
                  tokenIdsClaimed[tokenId] = true;
              }
           }
           //if all the token ids have been claimed, revert the transaction
           require(amount > 0, 'You have already claimed all the token');
           //call the internal function from openzeppelin's ERC20 contract
           //mint (amount * 10) tokens for each nft
           _mint(msg.sender, amount*tokensPerNFT);
       }

       //function to receive ether. msg.data must be empty
       receive() external payable{}

       //fallback function is called when msg.data is not empty
       fallback() external payable{}



      /**
       * @dev Mints `amount` number of CryptoDevTokens
       * Requirements:
       * - `msg.value` should be equal or greater than the tokenPrice * amount
       */

       function mint(uint256 amount) public payable {
           //value of ether sent should be equal or greeter than tokenPrice * amount
           uint256 _requiredAmount = tokenPrice * amount;
           require(msg.value >= _requiredAmount, 'Ether sent is insufficient');
           //total tokens + amount <= 10000, otherwise revert the transaction
           uint256 amountWithDecimals = amount * 10**18;
           require((totalSupply() + amountWithDecimals) <= maxTotalSupply);      
           //call the internal function from openzepplin's ERC20 contract
           _mint(msg.sender, amountWithDecimals);
       }
 }
