const { spawn } = require("child_process");
const path = require("path");
const env = { ...process.env };

const psPath = process.platform === "win32"
  ? "C:\\Program Files\\PowerShell\\7\\pwsh.exe"
  : "pwsh";

const scriptPath = path.join(__dirname, "collect-variables.ps1");

const stringVar = process.env.INPUT_STRINGVAR;
const boolVar = process.env['INPUT_BOOLVAR']?.toLowerCase() === 'true';

const args = [
  "-NoProfile",
  "-ExecutionPolicy", "Bypass",
  "-File", scriptPath,
  "-StringVar", stringVar || 'tweeter',
  "-BoolVar", boolVar ? 'true' : 'false'
];

const child = spawn(psPath, args, {
  stdio: "inherit",
  env: process.env
});

child.on("exit", process.exit);