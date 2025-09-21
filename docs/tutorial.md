# GrillCheese Middleware Tutorial

Learn how to create pixel art games with GrillCheese Middleware step by step.

## Table of Contents

- [Getting Started](#getting-started)
- [Tutorial 1: Your First Sprite](#tutorial-1-your-first-sprite)
- [Tutorial 2: Simple Animation](#tutorial-2-simple-animation)
- [Tutorial 3: Player Movement](#tutorial-3-player-movement)
- [Tutorial 4: Collision Detection](#tutorial-4-collision-detection)
- [Tutorial 5: Game States](#tutorial-5-game-states)
- [Advanced Syntax Features](#advanced-syntax-features)
- [Advanced Topics](#advanced-topics)

## Getting Started

### Prerequisites

- Love2D installed and working
- Basic understanding of programming concepts
- Text editor (VS Code recommended with GrillCheese extension)

### Project Setup

1. Create a new directory for your game
2. Copy the GrillCheese middleware files:
   ```bash
   cp sprc /path/to/your/game/
   cp -r sprlib /path/to/your/game/
   cp gc /path/to/your/game/
   ```

3. Make tools executable:
   ```bash
   chmod +x sprc gc
   ```

## Tutorial 1: Your First Sprite

Let's create a simple game that displays a sprite.

### Step 1: Create a Sprite

1. Create a 16x16 pixel PNG image with your favorite image editor
2. Save it as `player.png`
3. Convert it to .spr format:
   ```bash
   ./sprc player.png player.spr
   ```

### Step 2: Create the Game

Create `main.gcs`:

```gcs
// main.gcs - Your first sprite game
import { load, render } from "sprlib"

local player = nil

// Use table declaration for player position
table playerPos = {
    x = 100,
    y = 100
}

priv fn love.load() {
    // Load the sprite
    player = load("player.spr")
    
    if (player) {
        print("Player sprite loaded successfully!")
        // Set pixel-perfect filtering for crisp scaling
        player:setFilter("nearest", "nearest")
    } else {
        print("Error: Could not load player.spr")
    }
}

priv fn love.draw() {
    // Clear screen with dark background
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    if (player) {
        // Draw the player sprite using sprlib.render
        love.graphics.setColor(1, 1, 1, 1)
        render(player, playerPos.x, playerPos.y, 4)  // 4x scaling
    }
}

priv fn love.keypressed(string key) {
    if (key == "escape") {
        love.event.quit()
    }
}
```

### Step 3: Compile and Run

1. Compile the game:
   ```bash
   ./gc main.gcs main.lua
   ```

2. Run with Love2D:
   ```bash
   love .
   ```

You should see your sprite displayed on screen!

## Tutorial 2: Simple Animation

Let's add animation to make the sprite move.

### Step 1: Update the Game Code

Modify `main.gcs`:

```gcs
// main.gcs - Animated sprite
import { load, render } from "sprlib"

local player = nil

// Use table declarations for better organization
table playerPos = {
    x = 100,
    y = 100
}

table playerVel = {
    x = 0,
    y = 0
}

local speed = 200

priv fn love.load() {
    player = load("player.spr")
    if (player) {
        player:setFilter("nearest", "nearest")
        print("Player sprite loaded successfully!")
    }
}

priv fn love.update(dt) {
    // Handle keyboard input
    playerVel.x = 0
    playerVel.y = 0
    
    if (love.keyboard.isDown("left")) {
        playerVel.x = -speed
    }
    if (love.keyboard.isDown("right")) {
        playerVel.x = speed
    }
    if (love.keyboard.isDown("up")) {
        playerVel.y = -speed
    }
    if (love.keyboard.isDown("down")) {
        playerVel.y = speed
    }
    
    // Update position
    playerPos.x = playerPos.x + playerVel.x * dt
    playerPos.y = playerPos.y + playerVel.y * dt
    
    // Keep sprite on screen
    if (playerPos.x < 0) { playerPos.x = 0 }
    if (playerPos.x > 800 - 64) { playerPos.x = 800 - 64 }  // 64 = 16 * 4 (sprite size * scale)
    if (playerPos.y < 0) { playerPos.y = 0 }
    if (playerPos.y > 600 - 64) { playerPos.y = 600 - 64 }
}

priv fn love.draw() {
    // Clear screen
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    if (player) {
        // Draw player using sprlib.render
        love.graphics.setColor(1, 1, 1, 1)
        render(player, playerPos.x, playerPos.y, 4)
        
        // Draw position info
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Position: " .. math.floor(playerPos.x) .. ", " .. math.floor(playerPos.y), 10, 10)
    }
}

priv fn love.keypressed(key) {
    if (key == "escape") {
        love.event.quit()
    }
}
```

### Step 2: Test the Movement

Compile and run:
```bash
./gc main.gcs main.lua
love .
```

Use arrow keys to move the sprite around!

## Tutorial 3: Player Movement

Let's add more realistic movement with acceleration and deceleration.

### Step 1: Enhanced Movement System

Create `player.gcs`:

```gcs
// player.gcs - Player movement system
local player = {
    x = 100,
    y = 100,
    velocityX = 0,
    velocityY = 0,
    speed = 300,
    friction = 0.8,
    acceleration = 500
}

fn updatePlayer(dt) {
    // Handle input
    local inputX = 0
    local inputY = 0
    
    if (love.keyboard.isDown("left")) {
        inputX = -1
    }
    if (love.keyboard.isDown("right")) {
        inputX = 1
    }
    if (love.keyboard.isDown("up")) {
        inputY = -1
    }
    if (love.keyboard.isDown("down")) {
        inputY = 1
    }
    
    // Apply acceleration
    player.velocityX = player.velocityX + inputX * player.acceleration * dt
    player.velocityY = player.velocityY + inputY * player.acceleration * dt
    
    // Apply friction
    player.velocityX = player.velocityX * player.friction
    player.velocityY = player.velocityY * player.friction
    
    // Limit maximum speed
    local maxSpeed = player.speed
    local currentSpeed = math.sqrt(player.velocityX^2 + player.velocityY^2)
    if (currentSpeed > maxSpeed) {
        player.velocityX = (player.velocityX / currentSpeed) * maxSpeed
        player.velocityY = (player.velocityY / currentSpeed) * maxSpeed
    }
    
    // Update position
    player.x = player.x + player.velocityX * dt
    player.y = player.y + player.velocityY * dt
    
    // Keep on screen
    if (player.x < 0) {
        player.x = 0
        player.velocityX = 0
    }
    if (player.x > 800 - 64) {
        player.x = 800 - 64
        player.velocityX = 0
    }
    if (player.y < 0) {
        player.y = 0
        player.velocityY = 0
    }
    if (player.y > 600 - 64) {
        player.y = 600 - 64
        player.velocityY = 0
    }
}

fn drawPlayer() {
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(player.sprite, player.x, player.y, 0, 4, 4)
}
```

### Step 2: Update Main Game

Modify `main.gcs`:

```gcs
// main.gcs - Enhanced movement
import { load, render } from "sprlib"
import player from "player"

priv fn love.load() {
    player.sprite = load("player.spr")
    if (player.sprite) {
        player.sprite:setFilter("nearest", "nearest")
        print("Player sprite loaded successfully!")
    }
}

priv fn love.update(dt) {
    updatePlayer(dt)
}

priv fn love.draw() {
    // Clear screen
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    // Draw player
    drawPlayer()
    
    // Draw debug info
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Position: " .. math.floor(player.x) .. ", " .. math.floor(player.y), 10, 10)
    love.graphics.print("Velocity: " .. math.floor(player.velocityX) .. ", " .. math.floor(player.velocityY), 10, 30)
end

priv fn love.keypressed(key) {
    if (key == "escape") {
        love.event.quit()
    }
}
```

## Tutorial 4: Collision Detection

Let's add collision detection with obstacles.

### Step 1: Create Obstacle System

Create `obstacles.gcs`:

```gcs
// obstacles.gcs - Obstacle system
local obstacles = {}

fn createObstacle(x, y, width, height) {
    local obstacle = {
        x = x,
        y = y,
        width = width,
        height = height
    }
    table.insert(obstacles, obstacle)
    return obstacle
}

fn checkCollision(rect1, rect2) {
    return rect1.x < rect2.x + rect2.width and
           rect1.x + rect1.width > rect2.x and
           rect1.y < rect2.y + rect2.height and
           rect1.y + rect1.height > rect2.y
}

fn checkPlayerCollision(player) {
    local playerRect = {
        x = player.x,
        y = player.y,
        width = 64,  // 16 * 4 (sprite size * scale)
        height = 64
    }
    
    for (i = 1, #obstacles) {
        if (checkCollision(playerRect, obstacles[i])) {
            return true
        }
    }
    
    return false
}

fn drawObstacles() {
    love.graphics.setColor(0.8, 0.2, 0.2, 1)  // Red obstacles
    for (i = 1, #obstacles) {
        local obs = obstacles[i]
        love.graphics.rectangle("fill", obs.x, obs.y, obs.width, obs.height)
    }
}

fn initObstacles() {
    // Create some obstacles
    createObstacle(200, 200, 100, 20)
    createObstacle(400, 300, 80, 20)
    createObstacle(100, 400, 60, 20)
    createObstacle(500, 150, 120, 20)
}
```

### Step 2: Update Player Movement

Modify `player.gcs` to handle collisions:

```gcs
// player.gcs - Player with collision detection
local player = {
    x = 100,
    y = 100,
    velocityX = 0,
    velocityY = 0,
    speed = 300,
    friction = 0.8,
    acceleration = 500,
    lastX = 100,
    lastY = 100
}

fn updatePlayer(dt) {
    // Store last position for collision response
    player.lastX = player.x
    player.lastY = player.y
    
    // Handle input (same as before)
    local inputX = 0
    local inputY = 0
    
    if (love.keyboard.isDown("left")) {
        inputX = -1
    }
    if (love.keyboard.isDown("right")) {
        inputX = 1
    }
    if (love.keyboard.isDown("up")) {
        inputY = -1
    }
    if (love.keyboard.isDown("down")) {
        inputY = 1
    }
    
    // Apply acceleration
    player.velocityX = player.velocityX + inputX * player.acceleration * dt
    player.velocityY = player.velocityY + inputY * player.acceleration * dt
    
    // Apply friction
    player.velocityX = player.velocityX * player.friction
    player.velocityY = player.velocityY * player.friction
    
    // Limit maximum speed
    local maxSpeed = player.speed
    local currentSpeed = math.sqrt(player.velocityX^2 + player.velocityY^2)
    if (currentSpeed > maxSpeed) {
        player.velocityX = (player.velocityX / currentSpeed) * maxSpeed
        player.velocityY = (player.velocityY / currentSpeed) * maxSpeed
    }
    
    // Update position
    player.x = player.x + player.velocityX * dt
    player.y = player.y + player.velocityY * dt
    
    // Check collisions
    if (checkPlayerCollision(player)) {
        // Revert to last position
        player.x = player.lastX
        player.y = player.lastY
        player.velocityX = 0
        player.velocityY = 0
    }
    
    // Keep on screen
    if (player.x < 0) {
        player.x = 0
        player.velocityX = 0
    }
    if (player.x > 800 - 64) {
        player.x = 800 - 64
        player.velocityX = 0
    }
    if (player.y < 0) {
        player.y = 0
        player.velocityY = 0
    }
    if (player.y > 600 - 64) {
        player.y = 600 - 64
        player.velocityY = 0
    }
}

fn drawPlayer() {
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(player.sprite, player.x, player.y, 0, 4, 4)
}
```

### Step 3: Update Main Game

Modify `main.gcs`:

```gcs
// main.gcs - Game with collision detection
import { load, render } from "sprlib"
import player from "player"
import obstacles from "obstacles"

priv fn love.load() {
    player.sprite = load("player.spr")
    if (player.sprite) {
        player.sprite:setFilter("nearest", "nearest")
        print("Player sprite loaded successfully!")
    }
    
    initObstacles()
}

priv fn love.update(dt) {
    updatePlayer(dt)
}

priv fn love.draw() {
    // Clear screen
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    // Draw obstacles
    drawObstacles()
    
    // Draw player
    drawPlayer()
    
    // Draw debug info
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Position: " .. math.floor(player.x) .. ", " .. math.floor(player.y), 10, 10)
    love.graphics.print("Use arrow keys to move", 10, 30)
}

priv fn love.keypressed(key) {
    if (key == "escape") {
        love.event.quit()
    }
}
```

## Tutorial 5: Game States

Let's add a menu system and game states.

### Step 1: Game State System

Create `gamestate.gcs`:

```gcs
// gamestate.gcs - Game state management
local currentState = "menu"
local states = {}

fn setState(newState) {
    currentState = newState
    if (states[currentState] and states[currentState].enter) {
        states[currentState].enter()
    }
}

fn updateState(dt) {
    if (states[currentState] and states[currentState].update) {
        states[currentState].update(dt)
    }
}

fn drawState() {
    if (states[currentState] and states[currentState].draw) {
        states[currentState].draw()
    }
}

fn keypressedState(key) {
    if (states[currentState] and states[currentState].keypressed) {
        states[currentState].keypressed(key)
    }
}

// Menu state
states.menu = {
    selectedOption = 1,
    options = {"Play", "Settings", "Quit"},
    
    enter = fn() {
        print("Entered menu state")
    },
    
    update = fn(dt) {
        // Menu doesn't need update
    },
    
    draw = fn() {
        love.graphics.setColor(0.1, 0.1, 0.3, 1)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("GAME MENU", 300, 100)
        
        for (i = 1, #states.menu.options) {
            local color = {1, 1, 1, 1}
            if (i == states.menu.selectedOption) {
                color = {1, 1, 0, 1}  // Yellow for selected
            }
            
            love.graphics.setColor(color)
            love.graphics.print(states.menu.options[i], 350, 200 + i * 50)
        }
    },
    
    keypressed = fn(key) {
        if (key == "up") {
            states.menu.selectedOption = states.menu.selectedOption - 1
            if (states.menu.selectedOption < 1) {
                states.menu.selectedOption = #states.menu.options
            }
        } else if (key == "down") {
            states.menu.selectedOption = states.menu.selectedOption + 1
            if (states.menu.selectedOption > #states.menu.options) {
                states.menu.selectedOption = 1
            }
        } else if (key == "return") {
            if (states.menu.selectedOption == 1) {
                setState("game")
            } else if (states.menu.selectedOption == 2) {
                setState("settings")
            } else if (states.menu.selectedOption == 3) {
                love.event.quit()
            }
        }
    }
}

// Game state
states.game = {
    enter = fn() {
        print("Entered game state")
    },
    
    update = fn(dt) {
        updatePlayer(dt)
    },
    
    draw = fn() {
        // Clear screen
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        
        // Draw obstacles
        drawObstacles()
        
        // Draw player
        drawPlayer()
        
        // Draw UI
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Position: " .. math.floor(player.x) .. ", " .. math.floor(player.y), 10, 10)
        love.graphics.print("Press ESC to return to menu", 10, 30)
    },
    
    keypressed = fn(key) {
        if (key == "escape") {
            setState("menu")
        }
    }
}

// Settings state
states.settings = {
    enter = fn() {
        print("Entered settings state")
    },
    
    update = fn(dt) {
        // Settings don't need update
    },
    
    draw = fn() {
        love.graphics.setColor(0.3, 0.1, 0.1, 1)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("SETTINGS", 300, 100)
        love.graphics.print("Press ESC to return to menu", 300, 200)
    },
    
    keypressed = fn(key) {
        if (key == "escape") {
            setState("menu")
        }
    }
}
```

### Step 2: Update Main Game

Modify `main.gcs`:

```gcs
// main.gcs - Game with state management
import { load, render } from "sprlib"
import player from "player"
import obstacles from "obstacles"
import gamestate from "gamestate"

priv fn love.load() {
    player.sprite = load("player.spr")
    if (player.sprite) {
        player.sprite:setFilter("nearest", "nearest")
        print("Player sprite loaded successfully!")
    }
    
    initObstacles()
    setState("menu")
}

priv fn love.update(dt) {
    updateState(dt)
}

priv fn love.draw() {
    drawState()
}

priv fn love.keypressed(key) {
    keypressedState(key)
}
```

## Advanced Topics

### Modular Development

GrillCheese Script supports modular development with imports and exports:

#### Creating Modules

Create `player.gcs`:
```gcs
// player.gcs - Player module
export { Player, createPlayer }

fn Player.new() {
    local player = {
        x = 0,
        y = 0,
        velocityX = 0,
        velocityY = 0,
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

fn updatePlayer(Player player, float dt) {
    player.x = player.x + player.velocityX * dt
    player.y = player.y + player.velocityY * dt
}

fn drawPlayer(Player player) {
    love.graphics.draw(player.sprite, player.x, player.y, 0, 4, 4)
}
```

Create `enemy.gcs`:
```gcs
// enemy.gcs - Enemy module
export { Enemy, createEnemy }

fn Enemy.new() {
    local enemy = {
        x = 0,
        y = 0,
        health = 50,
        speed = 100
    }
    return enemy
}

fn createEnemy(int x, int y) {
    local enemy = Enemy.new()
    enemy.x = x
    enemy.y = y
    return enemy
}
```

#### Using Modules

Update `main.gcs`:
```gcs
// main.gcs - Main game file
import { load } from "sprlib"
import { Player, createPlayer } from "player"
import { Enemy, createEnemy } from "enemy"

local player = nil
local enemies = {}

priv fn love.load() {
    player = createPlayer(100, 100)
    player.sprite = load("player.spr")
    
    // Create some enemies
    for (int i = 0; i < 3; i++) {
        local enemy = createEnemy(200 + i * 100, 200)
        enemy.sprite = load("enemy.spr")
        table.insert(enemies, enemy)
    }
}

priv fn love.update(float dt) {
    updatePlayer(player, dt)
    // Update enemies...
}

priv fn love.draw() {
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    
    drawPlayer(player)
    // Draw enemies...
}
```

### Sprite Animation

```gcs
// animation.gcs - Sprite animation system
local animation = {
    frames = {},
    currentFrame = 1,
    frameTime = 0,
    frameDuration = 0.1,
    playing = true
}

fn loadAnimation(baseName, frameCount) {
    animation.frames = {}
    for (i = 1, frameCount) do
        local frame = load(baseName .. i .. ".spr")
        if (frame) then
            frame:setFilter("nearest", "nearest")
            table.insert(animation.frames, frame)
        end
    end
}

fn updateAnimation(dt) {
    if (not animation.playing) then
        return
    end
    
    animation.frameTime = animation.frameTime + dt
    
    if (animation.frameTime >= animation.frameDuration) then
        animation.frameTime = 0
        animation.currentFrame = animation.currentFrame + 1
        
        if (animation.currentFrame > #animation.frames) then
            animation.currentFrame = 1
        end
    end
}

fn drawAnimation(x, y, scale) {
    if (#animation.frames > 0) then
        local frame = animation.frames[animation.currentFrame]
        love.graphics.draw(frame, x, y, 0, scale, scale)
    end
}
```

### Sound System

```gcs
// sound.gcs - Sound management
local sounds = {}
local music = nil

fn loadSound(name, path) {
    sounds[name] = love.audio.newSource(path, "static")
end

fn playSound(name) {
    if (sounds[name]) then
        love.audio.play(sounds[name])
    end
}

fn loadMusic(path) {
    music = love.audio.newSource(path, "stream")
    music:setLooping(true)
end

fn playMusic() {
    if (music) then
        music:play()
    end
}

fn stopMusic() {
    if (music) then
        music:stop()
    end
}
```

### Save System

```gcs
// save.gcs - Save/load system
fn saveGame(filename) {
    local saveData = {
        playerX = player.x,
        playerY = player.y,
        level = currentLevel,
        score = score
    }
    
    local data = love.data.encode("string", "json", saveData)
    love.filesystem.write(filename, data)
    print("Game saved to " .. filename)
}

fn loadGame(filename) {
    local data = love.filesystem.read(filename)
    if (data) then
        local saveData = love.data.decode("string", "json", data)
        player.x = saveData.playerX
        player.y = saveData.playerY
        currentLevel = saveData.level
        score = saveData.score
        print("Game loaded from " .. filename)
        return true
    else
        print("Could not load game from " .. filename)
        return false
    end
}
```

## Advanced Syntax Features

GrillCheese Script includes many modern programming features to make game development easier and more expressive.

### Typed Arrays

Use typed arrays for better code organization and type safety:

```gcs
// Typed arrays with 0-indexing
string[] messages = ["Welcome!", "Game Over", "Level Complete"]
int[] scores = [100, 250, 500, 1000]
float[] positions = [100.5, 200.3, 300.7]
bool[] flags = [true, false, true, true]

// Access elements (0-indexed)
print(messages[0])  // "Welcome!"
print(scores[2])    // 500
print(flags[1])     // false
```

### Table Declarations

Use the `table` keyword for explicit table typing:

```gcs
// Player data structure
table player = {
    x = 100,
    y = 200,
    health = 100,
    speed = 150
}

// Obstacle array
table obstacles = {
    {x = 200, y = 200, width = 100, height = 20},
    {x = 400, y = 300, width = 80, height = 20},
    {x = 100, y = 400, width = 60, height = 20}
}

// Access properties
player.x = player.x + 10
local obs = obstacles[0]  // First obstacle
print("Obstacle at: " .. obs.x .. ", " .. obs.y)
```

### Array Literals

Use square brackets for array literals:

```gcs
// Array literals
local colors = ["red", "green", "blue"]
local numbers = [1, 2, 3, 4, 5]
local mixed = ["text", 42, 3.14, true]

// Initialize empty arrays
string[] inventory = []
int[] highScores = []
```

### Logical Operators

Use modern logical operators for cleaner conditions:

```gcs
// Logical operators
if (player.x > 0 && player.x < 800) {
    // Player is on screen
}

if (player.health <= 0 || player.y > 600) {
    // Player is dead or fell off screen
}

if (key == "space" || key == "return") {
    // Space or Enter pressed
}

// Comparison operators
if (score >= 1000 && score < 2000) {
    print("Good score!")
}

if (player.x != lastX || player.y != lastY) {
    // Player moved
}
```

### Import System

Use ES6-style imports for better module organization:

```gcs
// Single imports
import load from "sprlib"
import render from "sprlib"

// Destructuring imports
import { load, render, setColor } from "sprlib"

// Use imported functions
local sprite = load("player.spr")
render(sprite, 100, 200)
setColor(1, 0, 0, 1)  // Red
```

### Complete Example

Here's a complete example using all the new features:

```gcs
// advanced_example.gcs - Showcasing new syntax features
import { load, render } from "sprlib"

// Typed arrays
string[] gameMessages = ["Welcome!", "Game Over", "Level Complete"]
int[] highScores = [1000, 2500, 5000]

// Table declarations
table player = {
    x = 100,
    y = 200,
    health = 100,
    speed = 150
}

table gameState = {
    currentLevel = 1,
    score = 0,
    isPaused = false
}

// Obstacle array
table obstacles = {
    {x = 200, y = 200, width = 100, height = 20},
    {x = 400, y = 300, width = 80, height = 20}
}

priv fn love.load() {
    local sprite = load("player.spr")
    if (sprite) {
        print(gameMessages[0])  // "Welcome!"
        print("High score: " .. highScores[0])
    }
}

priv fn love.update(dt) {
    if (!gameState.isPaused) {
        // Handle movement with logical operators
        if (love.keyboard.isDown("left") && player.x > 0) {
            player.x = player.x - (player.speed * dt)
        }
        if (love.keyboard.isDown("right") && player.x < 800) {
            player.x = player.x + (player.speed * dt)
        }
        
        // Check collisions
        local i = 0
        while (i < obstacles.length) {
            local obs = obstacles[i]
            if (player.x < (obs.x + obs.width) && 
                (player.x + 32) > obs.x && 
                player.y < (obs.y + obs.height) && 
                (player.y + 32) > obs.y) {
                // Collision detected
                player.health = player.health - 10
                if (player.health <= 0) {
                    print(gameMessages[1])  // "Game Over"
                }
                break
            }
            i = i + 1
        }
    }
}

priv fn love.draw() {
    // Draw obstacles
    local i = 0
    while (i < obstacles.length) {
        local obs = obstacles[i]
        love.graphics.rectangle("fill", obs.x, obs.y, obs.width, obs.height)
        i = i + 1
    }
    
    // Draw player
    local sprite = load("player.spr")
    if (sprite) {
        render(sprite, player.x, player.y)
    }
    
    // Draw UI
    love.graphics.print("Health: " .. player.health, 10, 10)
    love.graphics.print("Score: " .. gameState.score, 10, 30)
    love.graphics.print("Level: " .. gameState.currentLevel, 10, 50)
}
```

## Next Steps

Now that you've completed the tutorials, you can:

1. **Add more features** - Enemies, power-ups, multiple levels
2. **Improve graphics** - Better sprites, particle effects, backgrounds
3. **Add audio** - Sound effects and background music
4. **Create levels** - Level editor, multiple stages
5. **Polish the game** - UI improvements, better controls

## Resources

- [API Reference](api-reference.md) - Complete function reference
- [GrillCheese Script Guide](grillcheese-script.md) - Language documentation
- [SPRC Tool Guide](SPRC_README.md) - Sprite conversion
- [Alpha Support](ALPHA_SUPPORT.md) - Transparency features

Happy game development! 🎮
