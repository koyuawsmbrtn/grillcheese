import * as vscode from 'vscode';
import { GrillCheeseCompletionProvider } from './completionProvider';
import { GrillCheeseHoverProvider } from './hoverProvider';
import { GrillCheeseDefinitionProvider } from './definitionProvider';

export function activate(context: vscode.ExtensionContext) {
    console.log('GrillCheese Script extension is now active!');

    // Register completion provider
    const completionProvider = new GrillCheeseCompletionProvider();
    context.subscriptions.push(
        vscode.languages.registerCompletionItemProvider(
            'grillcheese',
            completionProvider,
            '.', // trigger on dot
            '[' // trigger on bracket
        )
    );

    // Register hover provider
    const hoverProvider = new GrillCheeseHoverProvider();
    context.subscriptions.push(
        vscode.languages.registerHoverProvider('grillcheese', hoverProvider)
    );

    // Register definition provider
    const definitionProvider = new GrillCheeseDefinitionProvider();
    context.subscriptions.push(
        vscode.languages.registerDefinitionProvider('grillcheese', definitionProvider)
    );

    // Register commands
    context.subscriptions.push(
        vscode.commands.registerCommand('grillcheese.compile', () => {
            compileCurrentFile();
        })
    );

    context.subscriptions.push(
        vscode.commands.registerCommand('grillcheese.run', () => {
            runCurrentFile();
        })
    );
}

async function compileCurrentFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || editor.document.languageId !== 'grillcheese') {
        vscode.window.showWarningMessage('Please open a GrillCheese Script file (.gcs)');
        return;
    }

    const document = editor.document;
    const fileName = document.fileName;
    const baseName = fileName.replace(/\.gcs$/, '');
    const outputFile = baseName + '.lua';

    try {
        // This would integrate with the actual compiler
        vscode.window.showInformationMessage(`Compiling ${fileName} to ${outputFile}`);
        
        // TODO: Call the actual GrillCheese compiler here
        // const { exec } = require('child_process');
        // exec(`lua ../gcscript/init.lua compileFile "${fileName}" "${outputFile}"`);
        
    } catch (error) {
        vscode.window.showErrorMessage(`Compilation failed: ${error}`);
    }
}

async function runCurrentFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || editor.document.languageId !== 'grillcheese') {
        vscode.window.showWarningMessage('Please open a GrillCheese Script file (.gcs)');
        return;
    }

    try {
        // First compile, then run
        await compileCurrentFile();
        
        const fileName = editor.document.fileName;
        const baseName = fileName.replace(/\.gcs$/, '');
        const luaFile = baseName + '.lua';
        
        vscode.window.showInformationMessage(`Running ${luaFile} with Löve2D`);
        
        // TODO: Launch Löve2D with the compiled file
        // const { exec } = require('child_process');
        // exec(`love "${luaFile}"`);
        
    } catch (error) {
        vscode.window.showErrorMessage(`Run failed: ${error}`);
    }
}

export function deactivate() {
    console.log('GrillCheese Script extension is now deactivated');
}
