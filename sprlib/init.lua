-- Sprite library for loading custom sprite format

local colors = require("sprlib.colors")

local function read_bits(data, bpp)
    local byte_index = 1
    local bit_index = 0
    
    local function next()
        local val = 0
        local i = 1
        while i <= bpp do
            if byte_index > #data then
                return nil
            end
            local b = data:byte(byte_index)
            val = bit.bor(bit.lshift(val, 1), bit.band(bit.rshift(b, 7 - bit_index), 1))
            bit_index = bit_index + 1
            if bit_index == 8 then
                bit_index = 0
                byte_index = byte_index + 1
            end
            i = i + 1
        end
        return val
    end
    
    return next
end

local function load(path)
    local f = love.filesystem.newFile(path, "r")
    if not f then
        error("Failed to open file: " .. path)
    end
    
    local magic = f:read(4)
    if magic ~= "KSPR" then
        error("Invalid sprite data")
    end
    
    local data4 = f:read(4)
    local w = data4:byte(1) + (data4:byte(2) * 256)
    local h = data4:byte(3) + (data4:byte(4) * 256)
    local bpp = f:read(1):byte()
    local alpha_flag = f:read(1):byte()
    local _ = f:read(2)  -- Padding
    
    -- Read pixel data
    local pixel_data_size = math.ceil((w * h * bpp) / 8)
    local data = f:read(pixel_data_size)
    
    -- Read alpha data if present
    local alpha_data = nil
    if alpha_flag == 1 then
        local alpha_data_size = math.ceil((w * h) / 2)  -- 2 alpha values per byte (4 bits each)
        alpha_data = f:read(alpha_data_size)
    end
    
    f:close()
    
    local img = love.image.newImageData(w, h)
    local next_pixel = read_bits(data, bpp)
    
    -- Function to read alpha values
    local next_alpha = nil
    if alpha_data then
        local alpha_byte_index = 1
        local alpha_bit_index = 0
        next_alpha = function()
            if alpha_byte_index > #alpha_data then
                return 15  -- Default to fully opaque
            end
            local b = alpha_data:byte(alpha_byte_index)
            local alpha_val = 0
            if alpha_bit_index == 0 then
                alpha_val = bit.band(bit.rshift(b, 4), 15)  -- Upper 4 bits
            else
                alpha_val = bit.band(b, 15)  -- Lower 4 bits
                alpha_bit_index = 0
                alpha_byte_index = alpha_byte_index + 1
                return alpha_val
            end
            alpha_bit_index = 1
            return alpha_val
        end
    else
        next_alpha = function() return 15 end  -- Default to fully opaque
    end
    
    local colorTable = colors.colors()
    local y = 0
    while y < h do
        local x = 0
        while x < w do
            local idx = next_pixel()
            local col = colorTable[idx + 1]
            local alpha_val = next_alpha()
            local alpha_normalized = alpha_val / 15.0  -- Convert from 0-15 to 0-1 range
            img:setPixel(x, y, col.r, col.g, col.b, alpha_normalized)
            x = x + 1
        end
        y = y + 1
    end
    
    local sprite = love.graphics.newImage(img)
    -- Automatically set nearest filter for pixel-perfect rendering
    sprite:setFilter("nearest", "nearest")
    return sprite
end

local function render(sprite, x, y, scale)
    if not sprite then
        return
    end
    
    local currentScale = 1
    if scale then
        currentScale = scale
    end
    
    love.graphics.draw(sprite, x, y, 0, currentScale, currentScale)
end

return {
    load = load,
    render = render
}
