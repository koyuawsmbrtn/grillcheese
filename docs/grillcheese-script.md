# GrillCheese Script Language Guide

GrillCheese Script is a custom scripting language designed for game development with Love2D integration.

## Table of Contents

- [Language Overview](#language-overview)
- [Syntax](#syntax)
- [Data Types](#data-types)
- [Control Structures](#control-structures)
- [Functions](#functions)
- [Love2D Integration](#love2d-integration)
- [Examples](#examples)

## Language Overview

GrillCheese Script (`.gcs`) is a C-style scripting language with:

- **Type system** - Explicit type declarations (`int`, `float`, `string`, `bool`)
- **C-style syntax** - Curly brackets `{}` instead of `then/end`
- **Game-focused features** - Built for Love2D game development
- **Type safety** - Better error checking and debugging
- **Modern constructs** - Clean, readable code structure

### Key Features

- **Automatic Love2D integration** - All Love2D functions available
- **Function declarations** - Clear `fn` and `priv fn` syntax
- **Type declarations** - Explicit types for variables and parameters
- **Import system** - ES6-style imports for modular code
- **C-style syntax** - Curly brackets `{}` instead of `then/end`
- **Comments** - C-style `//` and `/* */` comments
- **No semicolons** - Clean syntax without statement terminators
- **Typed arrays** - `string[]`, `int[]`, `float[]`, `bool[]` with 0-indexing
- **Table declarations** - `table` keyword for explicit table typing
- **Array literals** - Square bracket syntax `[1, 2, 3]`
- **Logical operators** - `&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Operator precedence** - Proper precedence for all operators

## Syntax

### Comments

```gcs
// Single-line comment
/* Multi-line
   comment */

priv fn example() {
    // Function with comment
    int x = 10  // Variable with comment
}
```

### Imports

GrillCheese Script supports ES6-style imports for modular code:

```gcs
// Import specific functions
import { colors, loadSprite } from "sprlib"

// Import all exports from a module
import * as sprlib from "sprlib"

// Import with alias
import { colors as colorPalette } from "sprlib.colors"

// Import default export
import SpriteRenderer from "sprlib.renderer"
```

**Import Examples:**
```gcs
// Import from sprite library
import { colors } from "sprlib.colors"

// Import from game modules
import { Player } from "game.player"
import { Enemy } from "game.enemy"
import { Collision } from "game.collision"

// Use imported functions
priv fn love.load() {
    local colorTable = colors()
    local player = Player.new()
}
```

### Variables

```gcs
// Global variables (avoid when possible)
globalVar = "hello"

// Local variables (preferred)
local string localVar = "world"
int number = 42
float floatValue = 3.14
bool boolValue = true
local table = {key = "value"}

// Type declarations
int x = 10
float y = 3.14
string name = "Player"
bool isAlive = true
```

### Function Declarations

```gcs
// Public function (exported by default)
fn publicFunction() {
    return "accessible from outside"
}

// Private function (internal only)
priv fn privateFunction() {
    return "internal only"
}

// Function with parameters
fn add(int a, int b) {
    return a + b
}

// Function with typed parameters and variables
fn calculate(float x, float y) {
    float result = x * y + 10.0
    return result
}

// Function with mixed syntax
fn processPlayer(string name, int health) {
    local string status = "alive"
    if (health <= 0) {
        status = "dead"
    }
    return status
}
```

### Exports

Functions and variables can be exported for use in other modules:

```gcs
// Export specific functions
export { colors, loadSprite }

// Export with alias
export { colors as colorPalette }

// Export default
export default SpriteRenderer

// Export all public functions
export * from "sprlib.colors"
```

**Module Example:**
```gcs
// player.gcs - Player module
export { Player, createPlayer }

fn Player.new() {
    local player = {
        x = 0,
        y = 0,
        health = 100
    }
    return player
}

fn createPlayer(int x, int y) {
    local player = Player.new()
    player.x = x
    player.y = y
    return player
}

// Private function (not exported)
priv fn updatePlayerPosition(Player player) {
    // Internal logic
}
```

## Data Types

### Numbers

```gcs
local integer = 42
local float = 3.14159
local scientific = 1.23e4  // 12300
local negative = -100
```

### Strings

```gcs
local single = 'single quotes'
local double = "double quotes"
local multiline = [[
    Multi-line
    string
]]

// String concatenation
local combined = "Hello" .. " " .. "World"
```

### Booleans

```gcs
local trueValue = true
local falseValue = false
local nilValue = nil
```

### Tables

```gcs
// Array-style table
local array = {1, 2, 3, 4, 5}

// Object-style table
local player = {
    name = "Player",
    health = 100,
    position = {x = 0, y = 0}
}

// Mixed table
local mixed = {
    "first",           // index 1
    "second",          // index 2
    name = "third",    // key "name"
    [10] = "tenth"     // index 10
}
```

## Advanced Features

### Typed Arrays

GrillCheese Script supports typed arrays with 0-indexing:

```gcs
// Typed array declarations
string[] names = ["Alice", "Bob", "Charlie"]
int[] scores = [100, 200, 300, 400]
float[] values = [1.5, 2.7, 3.14, 4.2]
bool[] flags = [true, false, true, false]

// Mixed type arrays
local mixed = ["text", 42, 3.14, true]

// Array access (0-indexed)
print(names[0])  // "Alice"
print(scores[1]) // 200
print(values[2]) // 3.14

// Array length
local i = 0
while (i < names.length) {
    print(names[i])
    i = i + 1
}
```

### Table Declarations

Use the `table` keyword for explicit table typing:

```gcs
// Table declarations
table player = {
    x = 100,
    y = 200,
    health = 100,
    name = "Player"
}

table obstacles = {
    {x = 200, y = 200, width = 100, height = 20},
    {x = 400, y = 300, width = 80, height = 20}
}

// Table access
print(player.x)        // 100
print(player.name)     // "Player"
print(obstacles[0].x)  // 200
```

### Array Literals

Use square brackets for array literals:

```gcs
// Array literals with square brackets
local numbers = [1, 2, 3, 4, 5]
local strings = ["hello", "world", "test"]
local mixed = ["text", 42, 3.14, true]

// Traditional table syntax still works
local traditional = {1, 2, 3, 4, 5}
```

### Logical Operators

Full support for logical and comparison operators:

```gcs
local a = 10
local b = 20
local c = 30

// Logical operators
if (a < b && b < c) {
    print("a < b < c")
}

if (a > 5 || b < 10) {
    print("At least one condition is true")
}

// Comparison operators
if (a == 10) {
    print("a equals 10")
}

if (b != 15) {
    print("b does not equal 15")
}

if (c >= 30 && c <= 40) {
    print("c is between 30 and 40")
}
```

### Operator Precedence

Operators are evaluated with proper precedence:

```gcs
// Precedence: && > || > == > < > + > *
local result = a + b * c && x == y || z < w

// Equivalent to:
local result = ((a + (b * c)) && (x == y)) || (z < w)
```

### Import System

ES6-style imports with destructuring support:

```gcs
// Destructuring imports
import { load, render } from "sprlib"
import { colors } from "sprlib.colors"

// Single imports
import SpriteRenderer from "sprlib.renderer"
import utils from "game.utils"

// Usage
local sprite = load("player.spr")
render(sprite, 100, 100, 2)
local color = colors.red
```

## Control Structures

### If Statements

```gcs
int x = 10

if (x > 5) {
    print("x is greater than 5")
} else if (x > 0) {
    print("x is positive")
} else {
    print("x is zero or negative")
}
```

### While Loops

```gcs
int i = 1
while (i <= 10) {
    print("Count: " .. i)
    i = i + 1
}
```

### For Loops

```gcs
// Numeric for loop
for (int i = 1; i <= 10; i++) {
    print("Number: " .. i)
}

// For loop with step
for (int i = 10; i >= 1; i--) {
    print("Countdown: " .. i)
}

// Generic for loop
local items = {"apple", "banana", "cherry"}
for (int index, string item in ipairs(items)) {
    print(index .. ": " .. item)
}
```

### Break and Continue

```gcs
for (int i = 1; i <= 100; i++) {
    if (i == 50) {
        break  // Exit loop
    }
    
    if (i % 2 == 0) {
        continue  // Skip to next iteration
    }
    
    print("Odd number: " .. i)
}
```

## Functions

### Function Calls

```gcs
// Simple function call
local result = add(5, 3)

// Function call with multiple arguments
love.graphics.draw(sprite, x, y, rotation, scaleX, scaleY)

// Method call
local length = string.len("hello")
```

### Return Values

```gcs
fn getPlayerHealth() {
    return player.health
}

fn calculateDistance(x1, y1, x2, y2) {
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
}
```

### Variable Arguments

```gcs
fn printAll(...) {
    local args = {...}
    for (i = 1, #args) {
        print("Argument " .. i .. ": " .. args[i])
    }
}

// Usage
printAll("hello", "world", 42)
```

## Love2D Integration

### Callback Functions

GrillCheese Script automatically provides Love2D callback functions:

```gcs
// Game initialization
priv fn love.load() {
    local sprite = load("player.spr")
    int x = 100, y = 100
}

// Game update loop
priv fn love.update(float dt) {
    // dt = delta time in seconds
    x = x + velocity * dt
}

// Rendering
priv fn love.draw() {
    love.graphics.draw(sprite, x, y)
}

// Input handling
priv fn love.keypressed(string key) {
    if (key == "space") {
        jump()
    }
}

priv fn love.mousepressed(int x, int y, int button) {
    if (button == 1) {  // Left mouse button
        shoot(x, y)
    }
}
```

### Graphics Functions

```gcs
priv fn love.draw() {
    // Set color (RGBA)
    love.graphics.setColor(1, 0, 0, 1)  // Red
    
    // Draw shapes
    love.graphics.rectangle("fill", 100, 100, 50, 50)
    love.graphics.circle("line", 200, 200, 25)
    
    // Draw text
    love.graphics.print("Hello World", 10, 10)
    
    // Draw images
    love.graphics.draw(sprite, 300, 300, 0, 2, 2)  // 2x scaling
}
```

### Input Functions

```gcs
priv fn love.update(dt) {
    // Keyboard input
    if (love.keyboard.isDown("left")) {
        x = x - speed * dt
    }
    if (love.keyboard.isDown("right")) {
        x = x + speed * dt
    }
    
    // Mouse input
    local mouseX, mouseY = love.mouse.getPosition()
    local mousePressed = love.mouse.isDown(1)
}
```

### Audio Functions

```gcs
local sound = nil
local music = nil

priv fn love.load() {
    sound = love.audio.newSource("jump.wav", "static")
    music = love.audio.newSource("background.ogg", "stream")
    music:setLooping(true)
    music:play()
}

priv fn jump() {
    love.audio.play(sound)
}
```

## Examples

### Complete Game Example

```gcs
// main.gcs - Simple platformer
import { load, render } from "sprlib"

// Game state
local player = nil
float x = 100, y = 100
float velocityX = 0, velocityY = 0
float gravity = 500
float jumpPower = 300
bool onGround = false

priv fn love.load() {
    player = load("player.spr")
    player:setFilter("nearest", "nearest")
}

priv fn love.update(float dt) {
    // Handle input
    if (love.keyboard.isDown("left")) {
        velocityX = -200
    } else if (love.keyboard.isDown("right")) {
        velocityX = 200
    } else {
        velocityX = 0
    }
    
    // Jump
    if (love.keyboard.isDown("space") && onGround) {
        velocityY = -jumpPower
        onGround = false
    }
    
    // Apply gravity
    velocityY = velocityY + gravity * dt
    
    // Update position
    x = x + velocityX * dt
    y = y + velocityY * dt
    
    // Ground collision (simple)
    if (y > 400) {
        y = 400
        velocityY = 0
        onGround = true
    }
}

priv fn love.draw() {
    // Clear screen
    love.graphics.setColor(0.2, 0.3, 0.5, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    // Draw ground
    love.graphics.setColor(0.4, 0.3, 0.2, 1)
    love.graphics.rectangle("fill", 0, 400, 800, 200)
    
    // Draw player
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(player, x, y, 0, 4, 4)
    
    // Draw UI
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Use arrow keys to move, space to jump", 10, 10)
}

priv fn love.keypressed(string key) {
    if (key == "escape") {
        love.event.quit()
    }
}
```

### Sprite Animation Example

```gcs
// animation.gcs - Sprite animation system
import { load, render } from "sprlib"

local sprites = {}
local currentFrame = 1
local frameTime = 0
local frameDuration = 0.1
local totalFrames = 4

priv fn love.load() {
    // Load animation frames
    for (i = 1, totalFrames) {
        sprites[i] = load("frame" .. i .. ".spr")
        sprites[i]:setFilter("nearest", "nearest")
    }
}

priv fn love.update(dt) {
    frameTime = frameTime + dt
    
    if (frameTime >= frameDuration) {
        frameTime = 0
        currentFrame = currentFrame + 1
        
        if (currentFrame > totalFrames) {
            currentFrame = 1
        }
    }
}

priv fn love.draw() {
    love.graphics.draw(sprites[currentFrame], 100, 100, 0, 4, 4)
}
```

### Menu System Example

```gcs
// menu.gcs - Simple menu system
local currentMenu = "main"
local selectedOption = 1
local menuOptions = {"Play", "Settings", "Quit"}

priv fn love.load() {
    // Load menu assets
}

priv fn love.update(dt) {
    // Menu logic
}

priv fn love.draw() {
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("GAME MENU", 300, 100)
    
    for (i = 1, #menuOptions) {
        local color = {1, 1, 1, 1}
        if (i == selectedOption) {
            color = {1, 1, 0, 1}  // Yellow for selected
        }
        
        love.graphics.setColor(color)
        love.graphics.print(menuOptions[i], 350, 200 + i * 50)
    }
}

priv fn love.keypressed(key) {
    if (currentMenu == "main") {
        if (key == "up") {
            selectedOption = selectedOption - 1
            if (selectedOption < 1) {
                selectedOption = #menuOptions
            }
        } else if (key == "down") {
            selectedOption = selectedOption + 1
            if (selectedOption > #menuOptions) {
                selectedOption = 1
            }
        } else if (key == "return") {
            if (selectedOption == 1) {
                startGame()
            } else if (selectedOption == 2) {
                showSettings()
            } else if (selectedOption == 3) {
                love.event.quit()
            }
        }
    }
}

fn startGame() {
    currentMenu = "game"
    // Initialize game state
}

fn showSettings() {
    currentMenu = "settings"
    // Show settings menu
}
```

## Compilation

### Using the Compiler

```bash
# Compile single file
gc main.gcs main.lua

# Compile multiple files
gc *.gcs

# Compile with output directory
gc src/ output/
```

### Compilation Process

1. **Parse** - Convert .gcs syntax to internal representation
2. **Validate** - Check for syntax and type errors
3. **Transform** - Convert to Lua syntax
4. **Generate** - Output .lua file

### Error Messages

The compiler provides helpful error messages:

```
Error: main.gcs:15: Expected '{' after 'if'
    if (x > 5) then
        ^
```

```
Error: main.gcs:23: Undefined variable 'player'
    player.x = 100
    ^
```

## Best Practices

### Code Organization

```gcs
// Group related functions
fn playerMovement() {
    // Player movement logic
}

fn playerAnimation() {
    // Animation logic
}

fn playerCollision() {
    // Collision detection
}
```

### Variable Naming

```gcs
// Use descriptive names
local playerHealth = 100
local enemyCount = 5
local gameState = "playing"

// Use camelCase for variables
local currentFrame = 1
local frameDuration = 0.1

// Use UPPER_CASE for constants
local MAX_HEALTH = 100
local GRAVITY = 500
```

### Error Handling

```gcs
fn loadSprite(path) {
    local sprite = load(path)
    if (sprite) {
        return sprite
    } else {
        print("Error: Could not load sprite: " .. path)
        return nil
    }
}
```

### Performance Tips

```gcs
// Use local variables
priv fn love.update(dt) {
    local speed = 200  // Local is faster than global
    x = x + speed * dt
}

// Avoid repeated calculations
priv fn love.draw() {
    local scale = 4  // Calculate once
    love.graphics.draw(sprite, x, y, 0, scale, scale)
}
```

## Debugging

### Print Statements

```gcs
priv fn love.update(dt) {
    print("Player position: " .. x .. ", " .. y)
    print("Velocity: " .. velocityX .. ", " .. velocityY)
}
```

### Error Checking

```gcs
fn safeLoadSprite(path) {
    local success, sprite = pcall(load, path)
    if (success) {
        return sprite
    } else {
        print("Error loading sprite: " .. tostring(sprite))
        return nil
    }
}
```

### Debug Mode

```gcs
local DEBUG = true

fn debugPrint(message) {
    if (DEBUG) {
        print("[DEBUG] " .. message)
    }
}

priv fn love.update(dt) {
    debugPrint("Frame time: " .. dt)
}
```
