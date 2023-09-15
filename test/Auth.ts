import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect, assert } from "chai";
import { ethers } from "hardhat";

describe("auth", function () {
  async function deployAuthFixure() {
    // Contracts are deployed using the first signer/account by default
    const [owner] = await ethers.getSigners();

    const Auth = await ethers.getContractFactory("Authentification");
    const auth = await Auth.deploy();

    const value = ethers.parseEther("20");
    // default local provider : // put your local default provider with npx hardhat node or add custom provider
    const url = "http://127.0.0.1:8545/";
    const Provider = new ethers.JsonRpcProvider(url);
    const balance = await Provider.getBalance(owner.address);

  
    return { auth, owner, balance, Provider };
  }

  describe("register new User", () => {
    
    
    it("should register new user", async () => {
      const { auth, owner, balance } = await loadFixture(deployAuthFixure);


      const name: string = "Safoan";
      const profilePic: string =
        "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";

      await auth.register(name, profilePic);
      const userData = await auth.users(owner.address);// passed
      expect(userData.name).to.equal(name);// passed
      expect(userData.profilePic).to.equal(profilePic);// passed
    });

    it("showld send the user based on address provided", async () => {
      const { auth, owner } = await loadFixture(deployAuthFixure);

      // reprendre la logique d'enregistrement avant :
      const Name: string = "Safoan";
      const ProfilePic: string =
        "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";

      await auth.register(Name, ProfilePic);
      const [name, wallet, pic] = await auth.getUser(owner.address);

      expect(name).to.equal(Name); // passed
      expect(wallet).to.equal(owner.address); // passed
      expect(pic).to.equal(ProfilePic); // passed
    });

    it("showld returnd true if user is registered", async() => {
      const { auth } = await loadFixture(deployAuthFixure);
      const Name: string = "Safoan";
      const ProfilePic: string = "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";
      await auth.register(Name, ProfilePic);
      
      const checkIfIsHere = await auth.getifUserIsRegistered()
      expect(checkIfIsHere).to.equal(true) // passed
    
    })

  });

  describe("update user details", () => {

    it("should updateUserInfos", async() => {
        const {auth, owner} = await loadFixture(deployAuthFixure);
        // verifier si on peut correctement modifier les informations utilisateurs une fois l'user enregistré
        // on registre a l'user avant pour garder l'etat
        const Name: string = "Safoan";
        const ProfilePic: string = "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";
        await auth.register(Name, ProfilePic);

        // ---------------------------------------------
        const newName : string = "Rayan"; 
        const newProfile : string = "https://i.guim.co.uk/img/media/ef8492feb3715ed4de705727d9f513c168a8b196/37_0_1125_675/master/1125.jpg?width=465&dpr=1&s=none"

        await auth.updateUserDetails(newName, newProfile);
        // check si le mapping a eté correctement mis a jour
        const [name, wallet, profilePic] = await auth.users(owner.address);
        
        expect(name).to.equal(newName); //passed
        expect(profilePic).to.equal(newProfile) //passed
      
    })

  })

  describe("delete user", () => {
      it("showld delete the selected user", async() => {
      const {auth, owner} = await loadFixture(deployAuthFixure);

      const Name: string = "Safoan";
      const ProfilePic: string = "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";
      await auth.register(Name, ProfilePic);
      
      const test = await auth.users(owner.address);
      await auth.deleteUser(owner.address); 
      
      const deleted = await auth.users(owner.address);
      expect(test).to.not.equal(deleted); // passed
      
    })  
  })

  describe("change user role", () => {
    it("showld change role to admin for an selected user", async() => {
      const {auth, owner, balance} = await loadFixture(deployAuthFixure);
      
      const Name: string = "Safoan";
      const ProfilePic: string = "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";
      await auth.register(Name, ProfilePic);

      const [,,,role] = await auth.users(owner.address)
      
      // proceder au changement des roles
      await auth.changeRoles(owner.address);
      const [,,,newRole] = await auth.users(owner.address)
      
       expect(role).to.not.equal(newRole); // passed

    } )
  })
});
