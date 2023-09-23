import express, { Request, Response } from "express";
import cors from "cors";
import { ethers } from "ethers";
import dotenv from "dotenv";
import ABI from "../artifacts/contracts/CrowdFunding.sol/CrowdFunding.json";
dotenv.config();

const app = express();

app.use(cors());
app.use(express.urlencoded({ extended: false }));
app.use(express.json());
const PORT = process.env.PORT;
const contractAddress = process.env.CONTRACT_ADDRESS;

async function createGate() {
  const Provider = new ethers.JsonRpcProvider(process.env.PROVIDER_KEY_URL);
  const signer = new ethers.Wallet(process.env.PRIVATE_KEY as string, Provider);
  const Contract = new ethers.Contract(
    contractAddress as string,
    ABI.abi,
    signer
  );
  return Contract;
}

// ================================================================
// ++++++++++++++++++++ API REST ROUTES +++++++++++++++++++++++++++
// ================================================================

app.post("/api/v3/user/register", async (req: Request, res: Response) => {
  try {
    const Contract = await createGate();

    const {
      _name,
      _profilePic,
    }: {
      _name: string;
      _profilePic: string;
    } = req.body;
    const action = await Contract.registerUser(_name, _profilePic);

    return res.json({ code: 200, msg: action });
  } catch (error: any) {
    return res.json({ msg: error });
  }
});

app.listen(PORT, () => {
  console.log(`listening port ${PORT}...🌪️`);
});
