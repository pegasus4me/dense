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
  
      // default local provider : // put your local default provider with npx hardhat node or add custom provider
      const url = "http://127.0.0.1:8545/";
      const Provider = new ethers.JsonRpcProvider(url);
      const balance = await Provider.getBalance(owner.address);
    
      return { auth, owner, balance, Provider, };
    }
    
    async function createSafe() {
      const {auth} = await loadFixture(loadVaultFixure);
        const amount = ethers.parseEther("1")
        await auth.createNewSafe( "demo", "the best safe", amount, "cars");
        await auth.createNewSafe("bobo", "rest", amount, 'charity');
        await auth.createNewSafe("bodemoo", "dddddd", amount, 'charity');
      const after = await auth.vaultcreatedbyuser();
      
      return after
    }

    describe("create a new Safe", () => {

      beforeEach(() => {
          console.log("initialisation... 🪄")   
      })
        
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

       it('should delete safe', async() => {
          const {auth} = await loadFixture(loadVaultFixure);
          const res = await createSafe();
          const id = res[0].id;
          const check = await auth.vaultcreatedbyuser();
          await auth.closeSafe(id);
          const secondCheck = await auth.vaultcreatedbyuser();

          expect(secondCheck[0].safeName).to.be.equal(""); //passed
          expect(check[0].safeName).to.not.equal(secondCheck[0].safeName); //passed
        })
        

        // ------------------------------------------------------
        //                   contribution TEST
        // ______________________________________________________

        it("contribute on a Specific Safe" , async() => {
          const {auth, owner, balance} = await loadFixture(loadVaultFixure);
          const res = await createSafe();
          await auth.deposit();

          const value = ethers.parseEther("0.5");
          const id = res[0].id;
          
          
          const update = await auth.userBalance(owner.address);
          console.log("dodod", update)
          console.log(balance)
          // const before = await auth.vaultcreatedbyuser();
          
          // console.log("before balance ===", before[0].currentBalance)
          // await auth.contribute(id, value);
          // console.log("after balance ===", before[0].currentBalance)
          
         
        })
    })

  });
  