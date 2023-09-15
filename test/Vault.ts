import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect, assert } from "chai";
  import { ethers } from "hardhat";


  // type newSafe ={

  //   safeName : string,
  //   description : string,
  //   amount : number,
  //   category : string,
  
  // }

  describe("aut", async function () {

    async function loadVaultFixure(){
      const [owner] = await ethers.getSigners();

      const Auth = await ethers.getContractFactory("Vault");
      const auth = await Auth.deploy();
  
      const value = ethers.parseEther("20");
      // default local provider : // put your local default provider with npx hardhat node or add custom provider
      const url = "http://127.0.0.1:8545/";
      const Provider = new ethers.JsonRpcProvider(url);
      const balance = await Provider.getBalance(owner.address);
    
      return { auth, owner, balance, Provider };
    }
    
    async function createSafe() {
      const {auth} = await loadFixture(loadVaultFixure);
        await auth.createNewSafe( "demo", "the best safe", 10000000000000, "cars");
        await auth.createNewSafe("bobo", "rest", 1000000000, 'charity');
        await auth.createNewSafe("bodemoo", "dddddd", 8000000000, 'charity');
      const after = await auth.vaultcreatedbyuser();
      
      return after
    }

    describe("create a new Safe", () => {
        
      it("should create a new Safe", async() => {
        const {auth} = await loadFixture(loadVaultFixure);
        const before = await auth.vaultcreatedbyuser();
        const res = await createSafe()        
        expect(before.length).to.not.equal(res.length);
       
      })


       it("should update specific Safe ",async() => {
          const {auth} = await loadFixture(loadVaultFixure);
          const res = await createSafe();
          const name = res[2].safeName
          const id = res[2].id

          await auth.updateSafe(id,"nouveau Safe", "decription mise a jour", 5040300000, "dessins");
          const check = await auth.vaultcreatedbyuser(); // after safe update
          const updatedName = check[2].safeName

          expect(name).to.not.equal(updatedName)

       })
    })

  });
  