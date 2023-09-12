import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
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

      const userData = await auth.users(owner.address);
      expect(userData.name).to.equal(name);
      expect(userData.profilePic).to.equal(profilePic);
    });

    it("showld send the user based on address provided", async () => {
      const { auth, owner, balance } = await loadFixture(deployAuthFixure);

      // reprendre la logique d'enregistrement avant :
      const Name: string = "Safoan";
      const ProfilePic: string =
        "https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?&w=128&h=128&dpr=2&q=80";

      await auth.register(Name, ProfilePic);
      const [name, wallet, pic] = await auth.getUser(owner.address);

      expect(name).to.equal(Name);
      expect(wallet).to.equal(owner.address);
      expect(pic).to.equal(ProfilePic);
    });
  });
});
