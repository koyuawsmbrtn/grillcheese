# API Reference

Complete reference for all GrillCheese Middleware components.

## Table of Contents

- [sprc Tool](#sprc-tool)
- [sprlib Library](#sprlib-library)
- [GrillCheese Script](#grillcheese-script)
- [File Formats](#file-formats)

## sprc Tool

Command-line PNG to .spr converter.

### Usage
```bash
sprc [options] input.png [output.spr]
```

### Options
- `--help` - Show help message
- `--version` - Show version information

### Examples
```bash
# Convert single file
sprc sprite.png

# Convert with custom output name
sprc sprite.png my_sprite.spr

# Convert multiple files
sprc *.png
```

### Features
- **Automatic color optimization** - Maps PNG colors to sprlib palette
- **Alpha transparency** - Preserves PNG alpha channels
- **Variable BPP** - Optimizes bit depth based on color count
- **Batch processing** - Convert multiple files at once

## sprlib Library

Sprite rendering library for Love2D.

### Functions

#### `load(path)`
Loads a .spr file and returns a Love2D Image object.

**Parameters:**
- `path` (string) - Path to .spr file

**Returns:**
- `Image` - Love2D Image object ready for rendering

**Example:**
```lua
local sprite = load("character.spr")
love.graphics.draw(sprite, 100, 100)
```

**Errors:**
- Throws error if file not found
- Throws error if invalid .spr format

### Color Palette

sprlib uses a predefined 16-color palette:

| Index | Color | RGB | Description |
|-------|-------|-----|-------------|
| 0 | Black | (0, 0, 0) | Transparent/Black |
| 1 | White | (1, 1, 1) | White |
| 2 | Red | (1, 0, 0) | Red |
| 3 | Green | (0, 1, 0) | Green |
| 4 | Blue | (0, 0, 1) | Blue |
| 5 | Yellow | (1, 1, 0) | Yellow |
| 6 | Magenta | (1, 0, 1) | Magenta |
| 7 | Cyan | (0, 1, 1) | Cyan |
| 8 | Gray | (0.5, 0.5, 0.5) | Gray |
| 9 | Orange | (0.9, 0.4, 0.1) | Orange |
| 10 | Light Green | (0.4, 0.9, 0.1) | Light Green |
| 11 | Light Blue | (0.1, 0.4, 0.9) | Light Blue |
| 12 | Pink | (0.8, 0.2, 0.6) | Pink |
| 13 | Purple | (0.6, 0.2, 0.8) | Purple |
| 14 | Teal | (0.2, 0.8, 0.6) | Teal |
| 15 | Light Yellow | (0.95, 0.95, 0.5) | Light Yellow |

## GrillCheese Script

Custom scripting language for game development.

### Language Features

#### Keywords
- `priv` - Private function declaration
- `fn` - Function declaration
- `local` - Local variable declaration
- `int` - Integer type
- `float` - Floating-point type
- `string` - String type
- `bool` - Boolean type
- `import` - Import from modules
- `export` - Export functions/variables
- `if` / `else` - Conditional statements
- `while` - Loop statements
- `for` - For loops
- `return` - Return statement

#### Data Types
- **Numbers** - `123`, `45.67`
- **Strings** - `"hello world"`
- **Booleans** - `true`, `false`
- **Tables** - `{}`, `{key = value}`
- **Functions** - `fn name() end`

#### Operators
- **Arithmetic**: `+`, `-`, `*`, `/`, `%`, `^`
- **Comparison**: `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Logical**: `&&`, `||`, `!`
- **Assignment**: `=`
- **Increment/Decrement**: `++`, `--`

#### Modules and Imports
- **Import specific**: `import { function } from "module"`
- **Import all**: `import * as alias from "module"`
- **Import with alias**: `import { function as alias } from "module"`
- **Import default**: `import DefaultExport from "module"`
- **Export specific**: `export { function, variable }`
- **Export default**: `export default value`
- **Re-export**: `export * from "module"`

### Love2D Integration

GrillCheese Script automatically provides Love2D functions:

#### Callbacks
```gcs
priv fn love.load() {
    // Game initialization
}

priv fn love.update(float dt) {
    // Game logic
}

priv fn love.draw() {
    // Rendering
}

priv fn love.keypressed(string key) {
    // Input handling
}
```

#### Graphics Functions
```gcs
// Drawing
love.graphics.draw(image, x, y, rotation, scaleX, scaleY)
love.graphics.rectangle(mode, x, y, width, height)
love.graphics.circle(mode, x, y, radius)
love.graphics.print(text, x, y)

// Color
love.graphics.setColor(r, g, b, a)
love.graphics.getColor()

// Transform
love.graphics.push()
love.graphics.pop()
love.graphics.translate(x, y)
love.graphics.rotate(angle)
love.graphics.scale(sx, sy)
```

### Compilation

Use the `gc` compiler to convert .gcs files to .lua:

```bash
gc input.gcs output.lua
```

## File Formats

### .spr Format

Binary sprite format optimized for pixel art.

#### Header (16 bytes)
| Offset | Size | Type | Description |
|--------|------|------|-------------|
| 0 | 4 | char[] | Magic: "KSPR" |
| 4 | 2 | uint16 | Width (little-endian) |
| 6 | 2 | uint16 | Height (little-endian) |
| 8 | 1 | uint8 | Bits per pixel (1-4) |
| 9 | 1 | uint8 | Alpha flag (0=no alpha, 1=alpha) |
| 10 | 2 | uint8[] | Padding (reserved) |

#### Data Sections
1. **Pixel Data** - Bit-packed color indices
2. **Alpha Data** - 4-bit alpha values (if alpha flag = 1)

#### Alpha Data Format
- 4 bits per alpha value (0-15 range)
- 2 alpha values per byte
- 0 = fully transparent, 15 = fully opaque

### .gcs Format

GrillCheese Script source files.

#### Syntax
- C-style comments: `// comment`
- Block comments: `/* comment */`
- Semicolon optional for statements
- Indentation-based scoping

#### Example
```gcs
// Simple game
local sprite = nil

priv fn love.load() {
    sprite = load("player.spr")
}

priv fn love.draw() {
    love.graphics.draw(sprite, 100, 100)
}
```

## Error Handling

### Common Errors

#### sprc Errors
- **"Input file not found"** - Check file path
- **"Input file must be a PNG"** - Use PNG format
- **"Love2D not found"** - Install Love2D

#### sprlib Errors
- **"Failed to open file"** - Check .spr file path
- **"Invalid sprite data"** - Corrupted .spr file

#### Compilation Errors
- **Syntax errors** - Check GrillCheese Script syntax
- **Type errors** - Verify variable types
- **Undefined variables** - Declare variables before use

### Debugging Tips

1. **Check file paths** - Ensure all files exist
2. **Verify formats** - Use correct file extensions
3. **Test incrementally** - Start with simple examples
4. **Check console output** - Look for error messages
5. **Validate .spr files** - Use hex editor to check format

## Performance

### Optimization Tips

#### Sprite Optimization
- Use appropriate BPP for color count
- Minimize sprite dimensions
- Reuse sprites when possible
- Use nearest-neighbor filtering

#### Code Optimization
- Declare variables as `local`
- Avoid global variables
- Use tables efficiently
- Minimize function calls in loops

#### Memory Management
- Unload unused sprites
- Use object pooling
- Monitor memory usage
- Clean up resources

## Examples

### Complete Game Template
```gcs
// main.gcs
import { load, render } from "sprlib"

local player = nil
local x, y = 100, 100

priv fn love.load() {
    player = load("player.spr")
    player:setFilter("nearest", "nearest")
}

priv fn love.update(dt) {
    if (love.keyboard.isDown("left")) then
        x = x - 100 * dt
    end
    if (love.keyboard.isDown("right")) then
        x = x + 100 * dt
    end
end

priv fn love.draw() {
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(player, x, y, 0, 4, 4)
end
```

### Sprite Animation
```gcs
local sprites = {}
local currentFrame = 1
local frameTime = 0

priv fn love.load() {
    for (i = 1, 4) do
        sprites[i] = load("frame" .. i .. ".spr")
        sprites[i]:setFilter("nearest", "nearest")
    end
end

priv fn love.update(dt) {
    frameTime = frameTime + dt
    if (frameTime >= 0.1) then
        frameTime = 0
        currentFrame = currentFrame + 1
        if (currentFrame > 4) then
            currentFrame = 1
        end
    end
end

priv fn love.draw() {
    love.graphics.draw(sprites[currentFrame], 100, 100, 0, 4, 4)
end
```
