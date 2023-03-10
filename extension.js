// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require('vscode');
const getxInstall = require('./src/get-install.js');
// This method is called when your extension is activated
// Your extension is activated the very first time the command is executed

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {

	let getxInstallCmd = vscode.commands.registerCommand('basem-pattern.getxInstall', getxInstall.getxInstall);

	context.subscriptions.push(getxInstallCmd);
	
}

// This method is called when your extension is deactivated
function deactivate() {}

module.exports = {
	activate,
	deactivate
}
