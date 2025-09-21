import * as vscode from 'vscode';

export class GrillCheeseDefinitionProvider implements vscode.DefinitionProvider {
    provideDefinition(
        document: vscode.TextDocument,
        position: vscode.Position,
        token: vscode.CancellationToken
    ): vscode.ProviderResult<vscode.Definition | vscode.LocationLink[]> {
        const word = document.getWordRangeAtPosition(position);
        if (!word) {
            return undefined;
        }

        const wordText = document.getText(word);
        const lineText = document.lineAt(position).text;

        // Look for variable definitions in the current document
        const definitions = this.findVariableDefinitions(document, wordText);
        if (definitions.length > 0) {
            return definitions;
        }

        // Look for function definitions
        const functionDefinitions = this.findFunctionDefinitions(document, wordText);
        if (functionDefinitions.length > 0) {
            return functionDefinitions;
        }

        return undefined;
    }

    private findVariableDefinitions(
        document: vscode.TextDocument,
        variableName: string
    ): vscode.Location[] {
        const definitions: vscode.Location[] = [];
        const text = document.getText();

        // Look for variable declarations
        const variablePattern = new RegExp(`\\b(?:string\\[\\]|bool|int|float|array)\\s+${variableName}\\s*=`, 'g');
        let match;
        while ((match = variablePattern.exec(text)) !== null) {
            const position = document.positionAt(match.index);
            definitions.push(new vscode.Location(document.uri, position));
        }

        // Look for array declarations
        const arrayPattern = new RegExp(`\\barray\\s*=\\s*\\[`, 'g');
        while ((match = arrayPattern.exec(text)) !== null) {
            const position = document.positionAt(match.index);
            definitions.push(new vscode.Location(document.uri, position));
        }

        return definitions;
    }

    private findFunctionDefinitions(
        document: vscode.TextDocument,
        functionName: string
    ): vscode.Location[] {
        const definitions: vscode.Location[] = [];
        const text = document.getText();

        // Look for function declarations
        const functionPattern = new RegExp(`\\bfn\\s+${functionName}\\s*\\(`, 'g');
        let match;
        while ((match = functionPattern.exec(text)) !== null) {
            const position = document.positionAt(match.index);
            definitions.push(new vscode.Location(document.uri, position));
        }

        return definitions;
    }
}
