# Changelog

All notable changes to the GrillCheese Middleware project.

## [1.1.0] - 2025-09-21

### Added
- **Typed Arrays** - Support for `string[]`, `int[]`, `float[]`, `bool[]` with 0-indexing
- **Table Declarations** - `table` keyword for explicit table typing
- **Array Literals** - Square bracket syntax `[1, 2, 3]` for array literals
- **Enhanced Logical Operators** - Full support for `&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`
- **Operator Precedence** - Proper precedence for all operators
- **Import System** - ES6-style imports with destructuring support
- **Mixed Type Arrays** - Support for arrays with different data types
- **Enhanced Table Literals** - Better support for key-value pair table literals

### Improved
- **GrillCheese Script Compiler** - Enhanced parser with typed array support
- **VS Code Extension** - 15+ new code snippets and improved syntax highlighting
- **Documentation** - Comprehensive examples and usage patterns
- **Error Handling** - Better error messages for type mismatches
- **Code Generation** - Improved generation for destructuring imports

### Technical
- **Parser Enhancements** - Added support for typed array declarations
- **Type System** - Enhanced type checking and validation
- **Array Handling** - Proper 0-indexed to 1-indexed conversion
- **Import Resolution** - Fixed destructuring import code generation

## [1.0.0] - 2025-09-20

### Added
- **Complete .spr sprite format** - Custom binary format optimized for pixel art
- **sprc converter tool** - PNG to .spr conversion with automatic color optimization
- **sprlib rendering library** - Love2D integration for sprite loading and display
- **Alpha transparency support** - Full PNG alpha channel preservation in .spr format
- **16-color palette system** - Predefined color palette for consistent pixel art
- **Variable BPP encoding** - 1-4 bits per pixel based on color count
- **Bit-packed storage** - Efficient binary data compression
- **GrillCheese Script compiler** - Custom scripting language for game development
- **VS Code extension** - Complete IDE support with syntax highlighting
- **Comprehensive documentation** - API reference, tutorials, and guides
- **Example projects** - Working demos and sample code

### Features

#### Sprite System
- Custom .spr binary format with 16-byte header
- Magic signature "KSPR" for format identification
- Width/height stored as 16-bit little-endian values
- Variable BPP (1-4 bits per pixel) based on color count
- Alpha flag for transparency support
- Bit-packed pixel data for minimal file sizes
- 4-bit alpha values (0-15 range) for transparency

#### Color Palette
- 16 predefined colors optimized for pixel art
- Automatic color mapping from PNG to palette
- Color distance calculation for best match
- Support for transparent pixels (index 0)

#### Tools
- **sprc** - Command-line PNG to .spr converter
  - Automatic color optimization
  - Alpha transparency support
  - Batch file processing
  - Color-coded output
  - Error handling and validation

- **gc** - GrillCheese Script compiler
  - .gcs to .lua conversion
  - Syntax validation
  - Error reporting
  - Multiple file support

#### Libraries
- **sprlib** - Sprite rendering library
  - `sprlib.load(path)` - Load .spr files
  - Automatic alpha handling
  - Love2D Image object return
  - Backward compatibility with legacy .spr files

#### Language Features
- **GrillCheese Script** - Custom game scripting language
  - Simplified syntax compared to pure Lua
  - `fn` and `priv fn` function declarations
  - `local` variable declarations
  - C-style comments (`//` and `/* */`)
  - Automatic Love2D integration
  - Type safety and error checking

#### Documentation
- **README.md** - Project overview and quick start
- **API Reference** - Complete function documentation
- **Tutorial Guide** - Step-by-step learning path
- **GrillCheese Script Guide** - Language documentation
- **SPRC Tool Guide** - Converter documentation
- **Alpha Support Guide** - Transparency features

### Technical Specifications

#### .spr File Format
```
Header (16 bytes):
- Magic: "KSPR" (4 bytes)
- Width: uint16 little-endian (2 bytes)
- Height: uint16 little-endian (2 bytes)
- BPP: uint8 (1 byte)
- Alpha Flag: uint8 (1 byte)
- Padding: 2 bytes

Data:
- Pixel Data: Bit-packed color indices
- Alpha Data: 4-bit alpha values (if alpha flag = 1)
```

#### Color Palette
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

### Performance
- **File Size**: ~50% increase for alpha support
- **Memory**: Efficient bit-packed storage
- **Rendering**: Optimized for Love2D integration
- **Compilation**: Fast .gcs to .lua conversion

### Compatibility
- **Love2D**: Full integration and support
- **Lua 5.1+**: Required for compilation
- **PNG**: Input format for sprite conversion
- **Cross-platform**: Works on Windows, macOS, Linux

### Examples
- Basic sprite loading and display
- Player movement with collision detection
- Sprite animation system
- Game state management
- Menu systems
- Save/load functionality

### Development Tools
- VS Code extension with syntax highlighting
- IntelliSense support for GrillCheese Script
- Error detection and reporting
- Code completion and snippets

---

## Future Releases

### Planned Features
- [ ] Sprite animation system
- [ ] Tilemap support
- [ ] Particle effects
- [ ] Audio integration
- [ ] Level editor
- [ ] Performance profiling tools
- [ ] Additional color palettes
- [ ] Sprite batching
- [ ] Shader support

### Known Issues
- None currently reported

### Breaking Changes
- None in this release

---

**GrillCheese Middleware v1.0.0** - Complete pixel art game development toolkit! 🎮✨
