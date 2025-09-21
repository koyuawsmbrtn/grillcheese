# sprc - PNG to .spr Converter

`sprc` is a command-line tool that converts PNG images to the custom `.spr` format used by the GrillCheese middleware's sprlib.

## Features

- Converts PNG images to optimized .spr format
- Automatic color palette reduction (up to 16 colors)
- Variable bit-per-pixel encoding (1-4 BPP based on color count)
- Transparent pixel support
- Batch conversion support
- Color-coded output for better user experience

## Usage

### Basic Usage
```bash
./sprc input.png                    # Creates input.spr
./sprc input.png output.spr         # Creates output.spr
```

### Batch Conversion
```bash
./sprc *.png                        # Convert all PNG files in current directory
```

## Requirements

- Love2D installed and available in PATH
- PNG input files

## .spr File Format

The .spr format is a custom binary format optimized for pixel art:

- **Header**: 12 bytes
  - Magic: "KSPR" (4 bytes)
  - Width: 16-bit little-endian (2 bytes)
  - Height: 16-bit little-endian (2 bytes)
  - BPP: 8-bit (1 byte)
  - Padding: 3 bytes

- **Pixel Data**: Bit-packed pixel indices
  - 1 BPP: 2 colors (monochrome)
  - 2 BPP: 4 colors
  - 3 BPP: 8 colors
  - 4 BPP: 16 colors

## Color Palette

The converter automatically creates a color palette by sampling the input image and rounds colors to reduce the palette size. Colors are mapped to indices 0-15, with index 0 reserved for transparent pixels.

## Examples

```bash
# Convert a single sprite
./sprc character.png

# Convert with custom name
./sprc character.png player.spr

# Convert multiple files
./sprc sprites/*.png
```

## Integration with sprlib

The generated .spr files can be loaded and rendered using the sprlib library:

```lua
import { load, render } from "sprlib"
local sprite = load("my_sprite.spr")
-- Use sprite with Love2D graphics functions
```

## Troubleshooting

- **"Love2D not found"**: Install Love2D and ensure it's in your PATH
- **"Input file not found"**: Check the file path and permissions
- **"Conversion failed"**: Ensure the input is a valid PNG file
- **"More than 16 colors"**: The converter will warn but continue, some colors may be lost

## Technical Details

- Uses Love2D's image processing capabilities
- Automatically determines optimal BPP based on color count
- Implements bit-packing for efficient storage
- Handles transparency by mapping to color index 0
