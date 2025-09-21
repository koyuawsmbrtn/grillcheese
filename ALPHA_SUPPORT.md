# Alpha Channel Support in .spr Format

The GrillCheese middleware now supports alpha transparency in .spr files!

## New .spr Format

The .spr file format has been extended to support alpha channels:

### Header (16 bytes)
- **Magic**: "KSPR" (4 bytes)
- **Width**: 16-bit little-endian (2 bytes)  
- **Height**: 16-bit little-endian (2 bytes)
- **BPP**: Bits per pixel (1 byte)
- **Alpha Flag**: 1 = alpha supported, 0 = no alpha (1 byte)
- **Padding**: 2 bytes

### Data Sections
1. **Pixel Data**: Bit-packed color indices (same as before)
2. **Alpha Data**: 4-bit alpha values, 2 per byte (new!)

## Alpha Data Format

- Each alpha value is stored as 4 bits (0-15 range)
- 2 alpha values are packed per byte
- Alpha values are quantized from 0-1 range to 0-15 range
- 0 = fully transparent, 15 = fully opaque

## Usage

### Converting PNG with Alpha
```bash
./sprc image_with_alpha.png output.spr
```

The sprc script will automatically:
- Detect alpha values in the PNG
- Quantize alpha to 4-bit precision
- Pack alpha data efficiently
- Set the alpha flag in the header

### Loading Alpha Sprites
```lua
import { load, render } from "sprlib"
local sprite = load("my_sprite.spr")
-- Alpha is automatically handled by sprlib
```

## Backward Compatibility

- Old .spr files (without alpha) still work
- Alpha flag = 0 means no alpha data
- Default alpha = 15 (fully opaque) for old files

## Examples

### Creating Alpha Test Image
```lua
-- Create a 32x32 image with alpha gradient
local img = love.image.newImageData(32, 32)
for y = 0, 31 do
    for x = 0, 31 do
        local alpha = y / 31  -- Gradient from 0 to 1
        img:setPixel(x, y, 1, 0, 0, alpha)  -- Red with varying alpha
    end
end
img:encode("png", "alpha_test.png")
```

### Converting and Using
```bash
./sprc alpha_test.png alpha_test.spr
```

The resulting .spr file will preserve the alpha gradient and display correctly in Love2D games.

## Technical Details

- **Alpha Precision**: 4-bit (16 levels of transparency)
- **Storage**: 2 alpha values per byte
- **Performance**: Minimal overhead, alpha data is read efficiently
- **Quality**: Good balance between file size and transparency quality

## File Size Impact

For a 16x16 sprite:
- **Without alpha**: 128 bytes (pixel data only)
- **With alpha**: 192 bytes (pixel data + alpha data)
- **Increase**: ~50% file size increase for alpha support

This is reasonable given the added transparency functionality.
