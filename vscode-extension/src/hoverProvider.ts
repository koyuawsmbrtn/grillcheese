import * as vscode from 'vscode';

export class GrillCheeseHoverProvider implements vscode.HoverProvider {
    provideHover(
        document: vscode.TextDocument,
        position: vscode.Position,
        token: vscode.CancellationToken
    ): vscode.ProviderResult<vscode.Hover> {
        const word = document.getWordRangeAtPosition(position);
        if (!word) {
            return undefined;
        }

        const wordText = document.getText(word);
        const lineText = document.lineAt(position).text;

        // Love2D API documentation
        if (lineText.includes('love.')) {
            return this.getLove2DHover(wordText);
        }

        // GrillCheese Script keywords
        return this.getKeywordHover(wordText);
    }

    private getLove2DHover(word: string): vscode.Hover | undefined {
        const love2dDocs: { [key: string]: string } = {
            'love.graphics.print': '**love.graphics.print(text, x, y)**\n\nPrints text to the screen at the specified position.\n\n- `text`: The text to print\n- `x`: X coordinate\n- `y`: Y coordinate',
            'love.graphics.rectangle': '**love.graphics.rectangle(mode, x, y, width, height)**\n\nDraws a rectangle.\n\n- `mode`: "fill" or "line"\n- `x`: X coordinate\n- `y`: Y coordinate\n- `width`: Rectangle width\n- `height`: Rectangle height',
            'love.graphics.circle': '**love.graphics.circle(mode, x, y, radius)**\n\nDraws a circle.\n\n- `mode`: "fill" or "line"\n- `x`: X coordinate\n- `y`: Y coordinate\n- `radius`: Circle radius',
            'love.graphics.setColor': '**love.graphics.setColor(r, g, b, a)**\n\nSets the current drawing color.\n\n- `r`: Red component (0-1)\n- `g`: Green component (0-1)\n- `b`: Blue component (0-1)\n- `a`: Alpha component (0-1)',
            'love.keyboard.isDown': '**love.keyboard.isDown(key)**\n\nChecks if a key is currently pressed.\n\n- `key`: Key name (e.g., "space", "left", "right")',
            'love.mouse.getPosition': '**love.mouse.getPosition()**\n\nGets the current mouse position.\n\nReturns: `x, y` coordinates',
            'love.timer.getDelta': '**love.timer.getDelta()**\n\nGets the time between the current frame and the last frame.\n\nReturns: Delta time in seconds',
            'love.window.getWidth': '**love.window.getWidth()**\n\nGets the width of the window.\n\nReturns: Window width in pixels',
            'love.window.getHeight': '**love.window.getHeight()**\n\nGets the height of the window.\n\nReturns: Window height in pixels'
        };

        const doc = love2dDocs[word];
        if (doc) {
            return new vscode.Hover(new vscode.MarkdownString(doc));
        }

        return undefined;
    }

    private getKeywordHover(word: string): vscode.Hover | undefined {
        const keywordDocs: { [key: string]: string } = {
            'fn': '**fn** - Function declaration keyword\n\nUsed to declare functions in GrillCheese Script.\n\nExample:\n```grillcheese\nfn myFunction(param) {\n    // function body\n}\n```',
            'array': '**array** - Array declaration\n\nCreates a new array with the specified elements.\n\nExample:\n```grillcheese\narray = [1, 2, 3]\n```',
            'string[]': '**string[]** - String array type\n\nDeclares an array of strings.\n\nExample:\n```grillcheese\nstring[] names = ["Alice", "Bob"]\n```',
            'bool': '**bool** - Boolean type\n\nDeclares a boolean variable.\n\nExample:\n```grillcheese\nbool isActive = true\n```',
            'int': '**int** - Integer type\n\nDeclares an integer variable.\n\nExample:\n```grillcheese\nint count = 42\n```',
            'float': '**float** - Float type\n\nDeclares a float variable.\n\nExample:\n```grillcheese\nfloat pi = 3.14159\n```',
            'if': '**if** - Conditional statement\n\nExecutes code if a condition is true.\n\nExample:\n```grillcheese\nif (condition) {\n    // code\n}\n```',
            'while': '**while** - While loop\n\nRepeats code while a condition is true.\n\nExample:\n```grillcheese\nwhile (condition) {\n    // code\n}\n```',
            'true': '**true** - Boolean true value',
            'false': '**false** - Boolean false value',
            'nil': '**nil** - Null value',
            'and': '**and** - Logical AND operator',
            'or': '**or** - Logical OR operator',
            'not': '**not** - Logical NOT operator'
        };

        const doc = keywordDocs[word];
        if (doc) {
            return new vscode.Hover(new vscode.MarkdownString(doc));
        }

        return undefined;
    }
}
