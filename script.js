const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545'); // Use the appropriate provider

// Initialize Web3.js with your Ethereum provider
const providerUrl = "YOUR_PROVIDER_URL";
const web3 = new Web3(new Web3.providers.HttpProvider(providerUrl));

// Replace with your actual smart contract address and ABI
const contractAddress = "YOUR_CONTRACT_ADDRESS";
const contractABI = [...]; // Replace with your smart contract's ABI

// Initialize the smart contract instance
const contractInstance = new web3.eth.Contract(contractABI, contractAddress);

// Function to handle the staking process
async function stakeTokens(amount) {
  const accounts = await web3.eth.getAccounts();

  // Call the staking function on the smart contract
  await contractInstance.methods.stakeTokens(amount).send({
    from: accounts[0],
    gas: 500000, // Adjust the gas limit as needed
  });
}

// Connect the button with the staking process
const stakeButton = document.querySelector("#stake-button");
stakeButton.addEventListener("click", async () => {
  const amount = parseFloat(document.querySelector("#amount").value);
  
  if (!isNaN(amount) && amount > 0) {
    try {
      await stakeTokens(amount);
      alert("Staking successful!");
    } catch (error) {
      alert("Error occurred while staking: " + error.message);
    }
  } else {
    alert("Please enter a valid amount.");
  }
});

// Add these scripts to a separate script.js file

const connectWalletButton = document.getElementById("connect-wallet-button");

// Connect to wallet when the button is clicked
connectWalletButton.addEventListener("click", async () => {
  // Check if the user's browser has an Ethereum provider (like MetaMask)
  if (typeof window.ethereum !== "undefined") {
    try {
      // Request access to the user's Ethereum wallet
      await ethereum.request({ method: "eth_requestAccounts" });
      alert("Wallet connected successfully!");
    } catch (error) {
      alert("Wallet connection failed: " + error.message);
    }
  } else {
    alert("Ethereum provider (like MetaMask) not detected in your browser.");
  }
});

