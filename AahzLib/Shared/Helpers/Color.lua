---@class HelperColor: Helper
Helpers.Color = Helpers.Color or _Class:Create("HelperColor", Helper)
Helpers.ConsoleColorCodes = {
    -- Attributes
    Reset           = "\x1b[0m",
    Bright          = "\x1b[1m",
    Dim             = "\x1b[2m",
    Italic          = "\x1b[3m",  -- non-standard feature
    Underscore      = "\x1b[4m",
    BlinkOn         = "\x1b[5m",
    Reverse         = "\x1b[7m",
    Hidden          = "\x1b[8m",
    BrightOff       = "\x1b[21m",
    UnderscoreOff   = "\x1b[24m",
    BlinkOff        = "\x1b[25m",

    Black   = "\x1b[30m",
    Red     = "\x1b[31m",
    Green   = "\x1b[32m",
    Yellow  = "\x1b[33m",
    Blue    = "\x1b[34m",
    Magenta = "\x1b[35m",
    Cyan    = "\x1b[36m",
    White   = "\x1b[37m",
    Default = "\x1b[39m",

    LightGray   = "\x1b[90m",
    LightRed    = "\x1b[91m",
    LightGreen  = "\x1b[92m",
    LightYellow = "\x1b[93m",
    LightBlue   = "\x1b[94m",
    LightMagenta= "\x1b[95m",
    LightCyan   = "\x1b[96m",
    LightWhite  = "\x1b[97m",

    BGBlack     = "\x1b[40m",
    BGRed       = "\x1b[41m",
    BGGreen     = "\x1b[42m",
    BGYellow    = "\x1b[43m",
    BGBlue      = "\x1b[44m",
    BGMagenta   = "\x1b[45m",
    BGCyan      = "\x1b[46m",
    BGWhite     = "\x1b[47m",
    BGDefault   = "\x1b[49m"
}

---@param hex string
---@return vec3
function Helpers.Color.HexToRGB(hex)
    hex = hex:gsub('#','')
    local r,g,b

	if hex:len() == 3 then
		r = tonumber('0x'..hex:sub(1,1)) * 17
        g = tonumber('0x'..hex:sub(2,2)) * 17
        b = tonumber('0x'..hex:sub(3,3)) * 17
	elseif hex:len() == 6 then
		r = tonumber('0x'..hex:sub(1,2))
        g = tonumber('0x'..hex:sub(3,4))
        b = tonumber('0x'..hex:sub(5,6))
    end

    r = r or 0
    g = g or 0
    b = b or 0

    return {r,g,b}
end

---@param hex string
---@param alpha number? 0.0-1.0
---@return vec4
function Helpers.Color.HexToRGBA(hex, alpha)
    hex = hex:gsub("#", "")
    local r,g,b
    alpha = alpha or 1.0

	if hex:len() == 3 then
		r = tonumber('0x'..hex:sub(1,1)) * 17
        g = tonumber('0x'..hex:sub(2,2)) * 17
        b = tonumber('0x'..hex:sub(3,3)) * 17
	elseif hex:len() == 6 then
		r = tonumber('0x'..hex:sub(1,2))
        g = tonumber('0x'..hex:sub(3,4))
        b = tonumber('0x'..hex:sub(5,6))
    end

    r = r or 0
    g = g or 0
    b = b or 0

    return {r,g,b,alpha}
end

---Returns a linearly interpolated color between two hex colors
---@param hex1 string
---@param hex2 string
---@param percent number 0-100
---@return string hex value between "000000" and "FFFFFF"
function Helpers.Color.LerpHex(hex1, hex2, percent)
    percent = Ext.Math.Clamp(percent, 0, 100)
    local rgb = Helpers.Color.HexToRGB(hex1)
    local rgb2 = Helpers.Color.HexToRGB(hex2)
    local rgb3 = {
        math.floor((rgb[1]*(100-percent)/100) + (rgb2[1]*percent/100)),
        math.floor((rgb[2]*(100-percent)/100) + (rgb2[2]*percent/100)),
        math.floor((rgb[3]*(100-percent)/100) + (rgb2[3]*percent/100)),
    }
    return Helpers.Color.RGBToHex(rgb3)
end
---Returns a linearly interpolated color between two RGB/RGBA colors
---@param color1 vec3|vec4
---@param color2 vec3|vec4
---@param percent number 0-100
---@return vec3|vec4 color lerped rgb vec3 or rgba vec4
function Helpers.Color.NormalizedLerp(color1, color2, percent)
    if #color1 == 3 then
        -- assume rgb
        percent = Ext.Math.Clamp(percent, 0, 100)
        local rgb3 = {
            (color1[1]*(100-percent)/100) + (color2[1]*percent/100),
            (color1[2]*(100-percent)/100) + (color2[2]*percent/100),
            (color1[3]*(100-percent)/100) + (color2[3]*percent/100),
        }
        return rgb3
    else
        -- assume rgba
        percent = Ext.Math.Clamp(percent, 0, 100)
        local rgba4 = {
            (color1[1]*(100-percent)/100) + (color2[1]*percent/100),
            (color1[2]*(100-percent)/100) + (color2[2]*percent/100),
            (color1[3]*(100-percent)/100) + (color2[3]*percent/100),
            (color1[4]*(100-percent)/100) + (color2[4]*percent/100),
        }
        return rgba4
    end
end

---normalized version of HexToRGBA
---@param hex string
---@param alpha number
function Helpers.Color.HexToNormalizedRGBA(hex, alpha)
    local h = Helpers.Color.HexToRGBA(hex, alpha)
    return Helpers.Color.NormalizedRGBA(h[1], h[2], h[3], h[4])
end

--- Converts a normalized (0~1) RGBA value to a hex color string without the alpha component
---@param r number 0~1
---@param g number 0~1
---@param b number 0~1
---@return string
function Helpers.Color.NormalizedRGBToHex(r, g, b)
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    return string.format("#%02x%02x%02x", r, g, b)
end

---@param hex string
---@return vec3
function Helpers.Color.HexToEffectRGB(hex)
    local rgb = Helpers.Color.HexToRGB(hex)
    rgb = Ext.Math.Div(rgb, 255)
    return rgb
end

---@param rgb vec3
---@return string
function Helpers.Color.RGBToHex(rgb)
    return string.format('%.2x%.2x%.2x', rgb[1], rgb[2], rgb[3])
end

---@param rgb vec3
---@return string
function Helpers.Color.EffectRGBToHex(rgb)
    return string.format('%.2x%.2x%.2x', Ext.Math.Round(rgb[1] * 255), Ext.Math.Round(rgb[2] * 255), Ext.Math.Round(rgb[3] *255))
end

--- Create a table for the RGBA values
--- This is useful because of syntax highlighting that is not present when typing a table directly
---@param r number
---@param g number
---@param b number
---@param a number
---@return table<number>
function Helpers.Color.RGBA(r, g, b, a)
    return { r, g, b, a }
end

--- Create a table for the RGBA values, normalized to 0-1
--- This is useful because of syntax highlighting that is not present when typing a table directly
---@param r number
---@param g number
---@param b number
---@param a number
---@return table<number>
function Helpers.Color.NormalizedRGBA(r, g, b, a)
    return { r / 255, g / 255, b / 255, a }
end
-- function Helpers.Color.fromfloat(r, g, b, a)
--     return {
--         r = math.max(0, math.min(255, math.tointeger(math.floor(r * 256.0)))),
--         g = math.max(0, math.min(255, math.tointeger(math.floor(g * 256.0)))),
--         b = math.max(0, math.min(255, math.tointeger(math.floor(b * 256.0)))),
--         a = math.max(0, math.min(255, math.tointeger(math.floor(a * 256.0))))
--     }
-- end
---vec4 float to rgba
---@param vec4 vec4 { 0-1f, 0-1f, 0-1f, 0-1f }
---@return table rgba { 0-255, 0-255, 0-255, 0-255 }
function Helpers.Color.fromfloat(vec4)
    return {
        r = math.max(0, math.min(255, math.tointeger(math.floor(vec4[1] * 256.0)))),
        g = math.max(0, math.min(255, math.tointeger(math.floor(vec4[2] * 256.0)))),
        b = math.max(0, math.min(255, math.tointeger(math.floor(vec4[3] * 256.0)))),
        a = math.max(0, math.min(255, math.tointeger(math.floor(vec4[4] * 256.0))))
    }
end