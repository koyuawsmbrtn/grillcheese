# GrillCheese Script VS Code Extension Package

## Package Information

- **File**: `grillcheese-script-1.1.0.vsix`
- **Size**: ~15 KB
- **Version**: 1.1.0
- **Publisher**: grillcheese
- **Created**: December 19, 2024

## Package Contents

The extension package includes:

### Core Files
- `package.json` - Extension manifest and metadata
- `extension.js` - Main extension code (compiled from TypeScript)
- `language-configuration.json` - Language settings and auto-closing pairs

### Language Support
- `syntaxes/grillcheese.tmLanguage.json` - Syntax highlighting grammar
- `snippets/grillcheese.json` - Code snippets for common patterns

### IntelliSense Providers
- `completionProvider.js` - Auto-completion for keywords and Love2D API
- `hoverProvider.js` - Hover documentation for functions and keywords
- `definitionProvider.js` - Go-to-definition support

### Documentation
- `README.md` - Extension documentation
- `CHANGELOG.md` - Version history
- `LICENSE` - MIT License
- `INSTALL.md` - Installation instructions

## Features Included

### ✅ Syntax Highlighting
- GrillCheese Script keywords (`fn`, `if`, `while`, `table`, etc.)
- Type declarations (`string[]`, `bool`, `int`, `float`, `table`)
- Typed arrays (`string[]`, `int[]`, `float[]`, `bool[]`)
- Table declarations (`table player = {x = 100, y = 200}`)
- Array syntax (`array = [1, 2, 3]`)
- Logical operators (`&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`)
- Import statements (`import { load, render } from "sprlib"`)
- C-style comments (`//`)
- JavaScript-style curly braces (`{}`)
- Love2D API functions

### ✅ IntelliSense
- Auto-completion for 50+ Love2D functions
- Type declarations and array syntax
- Function parameter hints
- Variable and function definitions

### ✅ Code Snippets
- Function declarations (`fn`)
- Control structures (`if`, `while`, `for`)
- Type declarations (`string[]`, `bool`, `int`, `float`, `table`)
- Typed arrays (`int[]`, `float[]`, `bool[]`)
- Table declarations (`table`)
- Array and table literals
- Logical operators (`&&`, `||`, `==`, `!=`)
- Import statements
- Love2D functions (`love.graphics.print`, etc.)

### ✅ Hover Documentation
- GrillCheese Script keywords with usage examples
- Love2D functions with parameter descriptions
- Type system documentation

### ✅ Commands
- `GrillCheese: Compile` - Compile current .gcs file to .lua
- `GrillCheese: Run` - Compile and run with Löve2D

## Installation

1. **From VS Code**:
   - Press `Ctrl+Shift+P`
   - Type "Extensions: Install from VSIX..."
   - Select `grillcheese-script-1.1.0.vsix`

2. **From command line**:
   ```bash
   code --install-extension grillcheese-script-1.1.0.vsix
   ```

3. **Manual installation**:
   - Extract the .vsix file (it's a zip file)
   - Copy to VS Code extensions folder
   - Restart VS Code

## Requirements

- VS Code 1.74.0 or higher
- Node.js (for compilation commands)

## Testing

After installation, create a `.gcs` file and test:
- Syntax highlighting
- Auto-completion (type `love.`)
- Code snippets (type `fn` and press Tab)
- Hover documentation (hover over `love.graphics.print`)

## File Structure

```
grillcheese-script-1.1.0.vsix
├── extension.js
├── package.json
├── language-configuration.json
├── syntaxes/
│   └── grillcheese.tmLanguage.json
├── snippets/
│   └── grillcheese.json
├── out/
│   ├── completionProvider.js
│   ├── hoverProvider.js
│   └── definitionProvider.js
└── README.md
```

## Support

For issues or questions:
1. Check the VS Code Output panel for errors
2. Verify VS Code version compatibility
3. Try reinstalling the extension
