# GrillCheese Script VS Code Extension

A comprehensive VS Code extension for GrillCheese Script with syntax highlighting, IntelliSense, and Löve2D support.

## Features

### 🎨 Syntax Highlighting
- Full syntax highlighting for GrillCheese Script (.gcs files)
- Support for C-style comments (`//`)
- JavaScript-style curly braces (`{}`)
- Type declarations (`string[]`, `bool`, `int`, `float`, `table`)
- Array syntax (`array = [1, 2, 3]`)
- Typed arrays (`string[]`, `int[]`, `float[]`, `bool[]`)
- Table declarations (`table player = {x = 100, y = 200}`)
- Logical operators (`&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`)
- Import statements (`import { load, render } from "sprlib"`)

### 🧠 IntelliSense
- Auto-completion for GrillCheese Script keywords
- Type declarations and array syntax
- Function parameter hints
- Variable and function definitions

### 🎮 Löve2D Integration
- Complete Löve2D API IntelliSense
- Hover documentation for Löve2D functions
- Snippets for common Löve2D patterns
- Support for Love2D callbacks (`love.draw`, `love.update`, etc.)

### 📝 Code Snippets
- Function declarations (`fn`)
- Control structures (`if`, `while`, `for`)
- Type declarations (`string[]`, `bool`, `int`, `float`, `table`)
- Typed arrays (`int[]`, `float[]`, `bool[]`)
- Table declarations (`table`)
- Array and table literals
- Logical operators (`&&`, `||`, `==`, `!=`)
- Import statements
- Löve2D functions (`love.graphics.print`, `love.graphics.rectangle`, etc.)

## Installation

1. Copy the extension folder to your VS Code extensions directory
2. Reload VS Code
3. Open a `.gcs` file to activate the extension

## Usage

### Creating a GrillCheese Script file
1. Create a new file with `.gcs` extension
2. Start typing GrillCheese Script code
3. Enjoy syntax highlighting and IntelliSense!

### Example GrillCheese Script
```grillcheese
fn love.draw() {
    // This is a comment
    string[] testArray = ["1", "2", "3"]
    love.graphics.print(testArray[0] + "concat", 400, 300)
    bool testBool = true
    if (!testBool) {
        love.graphics.print("False", 100, 200)
    } else {
        love.graphics.print("True", 100, 200)
    }
}
```

### Available Commands
- `GrillCheese: Compile` - Compile current .gcs file to .lua
- `GrillCheese: Run` - Compile and run with Löve2D

## Language Features

### Type System
- `string[]` - Array of strings
- `bool` - Boolean values
- `int` - Integer values
- `float` - Floating point values
- `array` - Generic array declaration

### Syntax
- `fn` keyword for function declarations
- C-style comments (`//`)
- JavaScript-style curly braces (`{}`)
- 0-indexed arrays that compile to 1-indexed Lua
- String concatenation with `+` operator

### Löve2D Support
- Complete API reference
- Hover documentation
- Auto-completion for all Love2D functions
- Snippets for common patterns

## Development

### Building the Extension
```bash
npm install
npm run compile
```

### Testing
```bash
npm run watch
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details
