import express from 'express'
import cors from 'cors'
import ethers from 'ethers'
import dotenv from "dotenv"


const app = express()
app.use(cors());
app.use(express.urlencoded({extended : false}))
dotenv.config()

const PORT : string | undefined = process.env.PORT
// ------------------------------------------------------------------------------------------
//                          INITIALISE PROVIDER
// ----------------------------------------------------------------------------------------

// ABI
// SIGNER
// PROVIDER

// CONTRACT CALL
    // CREATE REST API ROUTES CRUD
// ---------------------------------------



app.listen(PORT,() => {
    console.log(`running... 🪄 on port ${PORT}`)
})