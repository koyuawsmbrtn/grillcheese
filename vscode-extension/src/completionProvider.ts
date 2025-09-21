import * as vscode from 'vscode';

export class GrillCheeseCompletionProvider implements vscode.CompletionItemProvider {
    provideCompletionItems(
        document: vscode.TextDocument,
        position: vscode.Position,
        token: vscode.CancellationToken,
        context: vscode.CompletionContext
    ): vscode.ProviderResult<vscode.CompletionItem[] | vscode.CompletionList> {
        const linePrefix = document.lineAt(position).text.substr(0, position.character);
        const completions: vscode.CompletionItem[] = [];

        // Love2D API completions
        if (linePrefix.includes('love.')) {
            completions.push(...this.getLove2DCompletions());
        }
        // Array completions
        else if (linePrefix.includes('[')) {
            completions.push(...this.getArrayCompletions());
        }
        // Import/Export completions
        else if (linePrefix.includes('import') || linePrefix.includes('export')) {
            completions.push(...this.getImportExportCompletions());
        }
        // General completions
        else {
            completions.push(...this.getGeneralCompletions());
        }

        return completions;
    }

    private getLove2DCompletions(): vscode.CompletionItem[] {
        const love2dAPI = [
            // Graphics
            { name: 'love.graphics.print', detail: 'Print text to screen', insertText: 'love.graphics.print(${1:text}, ${2:x}, ${3:y})' },
            { name: 'love.graphics.rectangle', detail: 'Draw rectangle', insertText: 'love.graphics.rectangle("${1|fill,line|}", ${2:x}, ${3:y}, ${4:width}, ${5:height})' },
            { name: 'love.graphics.circle', detail: 'Draw circle', insertText: 'love.graphics.circle("${1|fill,line|}", ${2:x}, ${3:y}, ${4:radius})' },
            { name: 'love.graphics.setColor', detail: 'Set drawing color', insertText: 'love.graphics.setColor(${1:r}, ${2:g}, ${3:b}, ${4:a})' },
            { name: 'love.graphics.getColor', detail: 'Get current color', insertText: 'love.graphics.getColor()' },
            { name: 'love.graphics.clear', detail: 'Clear screen', insertText: 'love.graphics.clear(${1:r}, ${2:g}, ${3:b}, ${4:a})' },
            { name: 'love.graphics.present', detail: 'Present frame', insertText: 'love.graphics.present()' },
            
            // Keyboard
            { name: 'love.keyboard.isDown', detail: 'Check if key is pressed', insertText: 'love.keyboard.isDown("${1:key}")' },
            { name: 'love.keyboard.getScancodeFromKey', detail: 'Get scancode from key', insertText: 'love.keyboard.getScancodeFromKey("${1:key}")' },
            
            // Mouse
            { name: 'love.mouse.getPosition', detail: 'Get mouse position', insertText: 'love.mouse.getPosition()' },
            { name: 'love.mouse.isDown', detail: 'Check if mouse button is pressed', insertText: 'love.mouse.isDown(${1:button})' },
            { name: 'love.mouse.getX', detail: 'Get mouse X position', insertText: 'love.mouse.getX()' },
            { name: 'love.mouse.getY', detail: 'Get mouse Y position', insertText: 'love.mouse.getY()' },
            
            // Window
            { name: 'love.window.setTitle', detail: 'Set window title', insertText: 'love.window.setTitle("${1:title}")' },
            { name: 'love.window.getTitle', detail: 'Get window title', insertText: 'love.window.getTitle()' },
            { name: 'love.window.getWidth', detail: 'Get window width', insertText: 'love.window.getWidth()' },
            { name: 'love.window.getHeight', detail: 'Get window height', insertText: 'love.window.getHeight()' },
            
            // System
            { name: 'love.timer.getDelta', detail: 'Get frame delta time', insertText: 'love.timer.getDelta()' },
            { name: 'love.timer.getFPS', detail: 'Get current FPS', insertText: 'love.timer.getFPS()' },
            { name: 'love.timer.sleep', detail: 'Sleep for seconds', insertText: 'love.timer.sleep(${1:seconds})' },
            
            // Math
            { name: 'love.math.random', detail: 'Generate random number', insertText: 'love.math.random(${1:min}, ${2:max})' },
            { name: 'love.math.randomseed', detail: 'Set random seed', insertText: 'love.math.randomseed(${1:seed})' },
            
            // Audio
            { name: 'love.audio.newSource', detail: 'Create audio source', insertText: 'love.audio.newSource("${1:file}", "${2|static,stream|}")' },
            { name: 'love.audio.play', detail: 'Play audio source', insertText: 'love.audio.play(${1:source})' },
            { name: 'love.audio.stop', detail: 'Stop audio source', insertText: 'love.audio.stop(${1:source})' },
            
            // Events
            { name: 'love.event.quit', detail: 'Quit application', insertText: 'love.event.quit()' },
            { name: 'love.event.push', detail: 'Push event', insertText: 'love.event.push("${1:event}", ${2:data})' }
        ];

        return love2dAPI.map(api => {
            const item = new vscode.CompletionItem(api.name, vscode.CompletionItemKind.Function);
            item.detail = api.detail;
            item.insertText = new vscode.SnippetString(api.insertText);
            item.documentation = new vscode.MarkdownString(`**${api.name}**\n\n${api.detail}`);
            return item;
        });
    }

    private getArrayCompletions(): vscode.CompletionItem[] {
        return [
            {
                name: 'Array access',
                detail: 'Access array element (0-indexed)',
                insertText: '${1:index}]'
            }
        ].map(item => {
            const completion = new vscode.CompletionItem(item.name, vscode.CompletionItemKind.Snippet);
            completion.detail = item.detail;
            completion.insertText = new vscode.SnippetString(item.insertText);
            return completion;
        });
    }

    private getImportExportCompletions(): vscode.CompletionItem[] {
        const importExportCompletions = [
            // Import statements
            { name: 'import named', detail: 'Import named exports', insertText: 'import { ${1:function1}, ${2:function2} } from "${3:module}"' },
            { name: 'import default', detail: 'Import default export', insertText: 'import ${1:name} from "${2:module}"' },
            { name: 'import all', detail: 'Import all exports as namespace', insertText: 'import * as ${1:namespace} from "${2:module}"' },
            { name: 'import with alias', detail: 'Import with alias', insertText: 'import { ${1:original} as ${2:alias} } from "${3:module}"' },
            
            // Export statements
            { name: 'export named', detail: 'Export named items', insertText: 'export { ${1:function1}, ${2:function2} }' },
            { name: 'export default', detail: 'Export default item', insertText: 'export default ${1:item}' },
            { name: 'export from', detail: 'Re-export from module', insertText: 'export * from "${1:module}"' },
            
            // Common modules
            { name: 'sprlib', detail: 'Import sprlib functions', insertText: 'import { load, render } from "sprlib"' },
            { name: 'sprlib colors', detail: 'Import sprlib colors', insertText: 'import { colors } from "sprlib.colors"' }
        ];

        return importExportCompletions.map(item => {
            const completion = new vscode.CompletionItem(item.name, vscode.CompletionItemKind.Snippet);
            completion.detail = item.detail;
            completion.insertText = new vscode.SnippetString(item.insertText);
            return completion;
        });
    }

    private getGeneralCompletions(): vscode.CompletionItem[] {
        const generalCompletions = [
            // Keywords
            { name: 'fn', detail: 'Function declaration', insertText: 'fn ${1:name}(${2:params}) {\n\t${3:// body}\n}' },
            { name: 'pub fn', detail: 'Public function declaration', insertText: 'pub fn ${1:name}(${2:params}) {\n\t${3:// body}\n}' },
            { name: 'priv fn', detail: 'Private function declaration', insertText: 'priv fn ${1:name}(${2:params}) {\n\t${3:// body}\n}' },
            { name: 'if', detail: 'If statement', insertText: 'if (${1:condition}) {\n\t${2:// code}\n}' },
            { name: 'if else', detail: 'If-else statement', insertText: 'if (${1:condition}) {\n\t${2:// code}\n} else {\n\t${3:// code}\n}' },
            { name: 'while', detail: 'While loop', insertText: 'while (${1:condition}) {\n\t${2:// code}\n}' },
            { name: 'for', detail: 'For loop (C-style)', insertText: 'for (${1:int} ${2:i} = ${3:0}; ${2:i} < ${4:10}; ${2:i}++) {\n\t${5:// code}\n}' },
            { name: 'for in', detail: 'For-in loop', insertText: 'for (${1:int} ${2:i}, ${3:string} ${4:item} in ipairs(${5:array})) {\n\t${6:// code}\n}' },
            { name: 'return', detail: 'Return statement', insertText: 'return ${1:value}' },
            { name: 'true', detail: 'Boolean true', insertText: 'true' },
            { name: 'false', detail: 'Boolean false', insertText: 'false' },
            { name: 'nil', detail: 'Nil value', insertText: 'nil' },
            
            // Type declarations
            { name: 'string[]', detail: 'String array declaration', insertText: 'string[] ${1:name} = [${2:"item1", "item2"}]' },
            { name: 'bool', detail: 'Boolean declaration', insertText: 'bool ${1:name} = ${2:true}' },
            { name: 'int', detail: 'Integer declaration', insertText: 'int ${1:name} = ${2:0}' },
            { name: 'float', detail: 'Float declaration', insertText: 'float ${1:name} = ${2:0.0}' },
            { name: 'string', detail: 'String declaration', insertText: 'string ${1:name} = "${2:value}"' },
            
            // Love2D callbacks
            { name: 'love.draw', detail: 'Love2D draw callback', insertText: 'priv fn love.draw() {\n\t${1:// drawing code}\n}' },
            { name: 'love.update', detail: 'Love2D update callback', insertText: 'priv fn love.update(float dt) {\n\t${1:// update code}\n}' },
            { name: 'love.load', detail: 'Love2D load callback', insertText: 'priv fn love.load() {\n\t${1:// initialization code}\n}' },
            { name: 'love.keypressed', detail: 'Love2D key pressed callback', insertText: 'priv fn love.keypressed(string key) {\n\t${1:// key handling}\n}' },
            { name: 'love.mousepressed', detail: 'Love2D mouse pressed callback', insertText: 'priv fn love.mousepressed(int x, int y, int button) {\n\t${1:// mouse handling}\n}' }
        ];

        return generalCompletions.map(item => {
            const completion = new vscode.CompletionItem(item.name, vscode.CompletionItemKind.Keyword);
            completion.detail = item.detail;
            completion.insertText = new vscode.SnippetString(item.insertText);
            return completion;
        });
    }
}
