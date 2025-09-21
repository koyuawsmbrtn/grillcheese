# GrillCheese Middleware

A complete toolkit for making game development easier with Love2D, featuring a custom sprite format, compiler, and rendering library.

## Overview

GrillCheese Middleware provides everything you need to streamline your game development workflow:

- **Custom .spr sprite format** - Efficient binary format with alpha transparency
- **sprc converter** - Convert PNG images to .spr format
- **sprlib rendering library** - Load and display .spr sprites in Love2D
- **GrillCheese Script compiler** - Modern scripting language with typed arrays, table declarations, and logical operators
- **VS Code extension** - Full IDE support with syntax highlighting, IntelliSense, and 15+ code snippets

## Quick Start

### 1. Convert PNG to .spr
```bash
./sprc my_sprite.png my_sprite.spr
```

### 2. Use in Love2D
```lua
import { load, render } from "sprlib"
local sprite = load("my_sprite.spr")
love.graphics.draw(sprite, x, y)
```

### 3. Compile GrillCheese Script
```bash
./gc main.gcs main.lua
```

## Features

### 🎨 Sprite System
- **Custom .spr format** - Efficient binary format for game assets
- **Alpha transparency** - Full support for PNG alpha channels
- **16-color palette** - Optimized color mapping system
- **Variable BPP** - 1-4 bits per pixel based on color count
- **Bit-packed storage** - Minimal file sizes

### 🛠️ Development Tools
- **sprc converter** - PNG to .spr conversion with color optimization
- **GrillCheese compiler** - Custom scripting language
- **VS Code extension** - Complete IDE integration
- **Comprehensive documentation** - Complete guides and references

### 📚 Documentation
- **Complete API reference** - All functions and formats documented
- **Tutorials** - Step-by-step guides
- **Examples** - Working code samples
- **Format specifications** - Detailed technical documentation

### 🚀 GrillCheese Script Features
- **Typed Arrays** - `string[]`, `int[]`, `float[]`, `bool[]` with 0-indexing
- **Table Declarations** - `table player = {x = 100, y = 200}`
- **Array Literals** - Square bracket syntax `[1, 2, 3]`
- **Logical Operators** - `&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Import System** - ES6-style imports with destructuring
- **Operator Precedence** - Proper precedence for all operators
- **Mixed Type Arrays** - `["text", 42, 3.14, true]`

## Installation

### Prerequisites
- Love2D (for sprite rendering)
- Lua 5.1+ (for compilation)
- Node.js (for VS Code extension)

### Setup
1. Clone the repository
2. Make tools executable: `chmod +x sprc gc`
3. Install VS Code extension from `vscode-extension/`

## File Structure

```
grillcheese-middleware/
├── sprc                    # PNG to .spr converter
├── gc                      # GrillCheese script compiler
├── sprlib/                 # Sprite rendering library
│   ├── init.lua           # Main library
│   └── colors.lua         # Color palette
├── gcscript/              # Compiler source
├── vscode-extension/      # VS Code extension
└── docs/                  # Documentation
```

## Documentation

- [SPRC Tool Guide](SPRC_README.md) - PNG to .spr conversion
- [Alpha Support](ALPHA_SUPPORT.md) - Transparency features
- [GrillCheese Script](docs/grillcheese-script.md) - Language reference
- [API Reference](docs/api-reference.md) - Complete API docs

## Examples

### Basic Sprite Loading
```lua
import { load, render } from "sprlib"
local sprite = load("character.spr")
sprite:setFilter("nearest", "nearest")  -- Pixel-perfect scaling
love.graphics.draw(sprite, 100, 100, 0, 4, 4)  -- 4x scaling
```

### GrillCheese Script
```gcs
// Simple game loop
priv fn love.load() {
    local sprite = load("player.spr")
}

priv fn love.draw() {
    love.graphics.draw(sprite, 0, 0)
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

- **Issues**: Report bugs and request features
- **Discussions**: Ask questions and share projects
- **Wiki**: Community documentation and tutorials

---

**GrillCheese Middleware** - Making game development simple and fun! 🎮✨
