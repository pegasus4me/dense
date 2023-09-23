"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.urlencoded({ extended: false }));
dotenv_1.default.config();
const PORT = process.env.PORT;
// ------------------------------------------------------------------------------------------
//                          INITIALISE PROVIDER
// ----------------------------------------------------------------------------------------
// ABI
// SIGNER
// PROVIDER
// CONTRACT CALL
// CREATE REST API ROUTES CRUD
// ---------------------------------------
app.listen(PORT, () => {
    console.log(`running... 🪄 on port ${PORT}`);
});
