local _random = Ext.Math.Random
local function _randomFloat(min, max) return _random(min ~= nil and min * 1000 or 0, max ~= nil and max * 1000 or 1000)/1000 end

---@class FCColor
Color = _Class:Create("FCColor")
Color.DefaultAngleAmount = 3

---@return vec3 [0;1][] hsl
function Color:CreateRandomColor()
    return {_randomFloat(), _randomFloat(.1, 1), _randomFloat(.15, .85)}
end

---@return vec3 [0;1][] hsl
function Color:CreateVividColor()
    return {_randomFloat(), _randomFloat(.9, 1), _randomFloat(.4, .6)}
end

---@return vec3 [0;1][] hsl
function Color:CreatePastelColor()
    return {_randomFloat(), _randomFloat(.8, 1), _randomFloat(.7, .85)}
end

---@return vec3 [0;1][] hsl
function Color:CreateDarkColor()
    return {_randomFloat(), _randomFloat(.3, .75), _randomFloat(0, 0.20)}
end

---@return vec3 [0;1][] hsl
function Color:CreateGrayScale()
    return {_randomFloat(), 0, _randomFloat()}
end

---@param value number
---@param jitter number
---@return number
function Color:ApplyJitter(value, jitter)
    return Ext.Math.Clamp(value + jitter * _randomFloat(-1, 1), 0, 1)
end

---@param rgb vec3 [0;1] values
---@return number h [0;1] hue,
---@return number s [0;1] saturation, 
---@return number v [0;1] value
---@return number min [0;1] min of r,g,b
function Color:RGB2HSVM(rgb)
    local r,g,b = table.unpack(rgb)
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max

    local c = max - min
    if max == 0 then
        s = 0
    else
        s = c / max
    end

    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / c
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = (b - r) / c + 2
        elseif max == b then
            h = (r - g) / c + 4
        end
        h = h / 6
    end

    return h,s,v,min
end

---@param rgb vec3 [0;1] values
---@return number h [0;1] hue,
---@return number s [0;1] saturation, 
---@return number l [0;1] value
function Color:RGB2HSL(rgb)
    local h,_,max,min = self:RGB2HSVM(rgb)
    local lightness = (max + min) / 2

    local sat = lightness == 0 and 0 
    or (max - min) / (1 - math.abs(max + min -1))

    return h, sat, lightness
end

---@return number [0;1] hue
function Color:Hue2RGB(p,q,t)
    if t < 0 then
        t = t + 1
    elseif t > 1 then
        t = t - 1
    end

    if t < 1/6 then
        return p + (q - p) * 6 * t
    elseif t < 1/2 then
        return q
    elseif t < 2/3 then
        return p + (q - p) * (2/3 - t) * 6
    end
    return p
end

---@param h number [0;1] hue
---@param s number [0;1] saturation
---@param l number [0;1] luminance
function Color:HSL2RGB(h,s,l)
    local r,g,b

    if s == 0 then
        r = l
        g = l
        b = l
    else
        local q
        if l < 0.5 then
            q = l * (1 + s)
        else
            q = l + s - l * s
        end

        local p = 2 * l - q
        r = self:Hue2RGB(p, q, h + 1/3)
        g = self:Hue2RGB(p, q, h)
        b = self:Hue2RGB(p, q, h - 1/3)
    end
    return {r,g,b}
end

-- Creates n number of colors that are evenly spaced from rgb
---@param hsl vec3 [0-1]
---@param n integer number of colors
---@param r? number space colors over r rotations
---@return FCColor[] colors table with n colors including self at index 1
function Color:GenerateEvenlySpacedColors(hsl, n, r)
    r = r or 1
    local h,s,l = table.unpack(hsl)
    local colors = {self:HSL2RGB(h,s,l)}

    local rot = r / n
    for i = 1, n - 1 do
        h = (h + rot) % 1
        table.insert(colors, self:HSL2RGB(h,s,l))
    end

    return colors
end

-- Generates colors in order that guarantees they are far apart from the previous entry
---@param hsl vec3
---@param amount integer 
---@return vec3[] rgbColors
function Color:GenerateGoldenRatioColors(hsl, amount)
    local h,s,l = table.unpack(hsl)
    local colors = {self:HSL2RGB(h,s,l)}
    for i = 1, amount-1 do
        h = (h + 0.618033988749895) % 1
        table.insert(colors, self:HSL2RGB(h,s,l))
    end

    return colors
end

--Forces at least 1 selection from each angle so long as harmonyAmount permits. After 1 color from each angle is made, the remaining entries are weighted by angle ranges (random)
---@param hsl vec3
---@param harmonyAmount integer
---@param angleRefRange number [0-360]
---@param angles {Offset:number, Range:number}[] {Offset:[0-360], Range:[0-360]}
---@param saturationJitter? number [0-1]
---@param luminanceJitter? number [0-1]
---@return vec3[] rgbArray
function Color:GenerateHueHarmony(hsl, harmonyAmount, angleRefRange, angles, saturationJitter, luminanceJitter)
    local h,s,l = table.unpack(hsl)
    local colors = {self:HSL2RGB(h,s,l)}
    local refAngle = h * 360

    -- Generate a color from each angle
    for i = 1, math.min(harmonyAmount-1, #angles) do
        local randomAngle = angles[i].Offset + angles[i].Range * (_randomFloat() - 0.5)

        local randomH = ((refAngle + randomAngle) / 360) % 1
        if saturationJitter then
            s = self:ApplyJitter(s, saturationJitter)
        end
        if luminanceJitter then
            l = self:ApplyJitter(l, luminanceJitter)
        end

        table.insert(colors, self:HSL2RGB(randomH,s,l))
    end

    -- Generate the rest of the colors from weighted range
    local remainingAmount = (harmonyAmount-1) - math.min(harmonyAmount-1, #angles)
    if remainingAmount > 0 then
        local totalAngleRange = angleRefRange
        for i = 1, #angles do
            totalAngleRange = totalAngleRange + angles[i].Range
        end

        for j = 1, remainingAmount do
            local randomAngle = _randomFloat() * totalAngleRange

            if randomAngle <= angleRefRange then
                randomAngle = randomAngle - angleRefRange/2
            else
                local angleIndex = 0
                local subTotalAngleRange = angleRefRange
                while randomAngle > subTotalAngleRange do
                    angleIndex = angleIndex + 1
                    subTotalAngleRange = subTotalAngleRange + angles[angleIndex].Range
                end

                randomAngle = randomAngle + angles[angleIndex].Offset - subTotalAngleRange + angles[angleIndex].Range/2
            end

            local randomH = ((refAngle + randomAngle) / 360) % 1
            if saturationJitter then
                s = self:ApplyJitter(s, saturationJitter)
            end
            if luminanceJitter then
                l = self:ApplyJitter(l, luminanceJitter)
            end

            table.insert(colors, self:HSL2RGB(randomH,s,l))
        end
    end

    return colors
end

---@param hsl vec3
---@param harmonyAmount integer
---@param angleAmount? integer
---@param angleRange? number [0-360]
---@param saturationJitter? number [0-1]
---@param luminanceJitter? number [0-1]
---@return vec3[] rgbArray
function Color:GenerateAnalogousHarmony(hsl, harmonyAmount, angleAmount, angleRange, saturationJitter, luminanceJitter)
    local angles = {}
    angleRange = angleRange or 5
    angleAmount = angleAmount or self.DefaultAngleAmount

    for i = 1, angleAmount do
        angles[i] = {Offset = i * 30, Range = angleRange}
    end
    local harmonyColors = self:GenerateHueHarmony(hsl, harmonyAmount, angleRange, angles, saturationJitter, luminanceJitter)
    return harmonyColors
end

---@param hsl vec3
---@param harmonyAmount integer
---@param angleRange number [0-360]
---@param saturationJitter? number [0-1]
---@param luminanceJitter? number [0-1]
---@return vec3[] rgbArray
function Color:GenerateComplementaryHarmony(hsl, harmonyAmount, angleRange, saturationJitter, luminanceJitter)
    local angles = {{Offset = 180, Range = angleRange}}

    return self:GenerateHueHarmony(hsl, harmonyAmount, angleRange, angles, saturationJitter, luminanceJitter)
end

---@param hsl vec3
---@param harmonyAmount integer
---@param splitAnglesOffset? number [0-360]
---@param angleRefRange? number [0-360]
---@param splitAnglesRange? number [0-360]
---@param saturationJitter? number [0-1]
---@param luminanceJitter? number [0-1]
---@return vec3[] rgbArray
function Color:GenerateSplitComplementaryHarmony(hsl, harmonyAmount, splitAnglesOffset, angleRefRange, splitAnglesRange, saturationJitter, luminanceJitter)
    splitAnglesOffset = splitAnglesOffset or 30
    splitAnglesRange = splitAnglesRange or 30
    angleRefRange = Ext.Math.Clamp(angleRefRange or 30, 0, (180 - splitAnglesOffset - splitAnglesRange/2)*2)
    
    local angles = {
        {Offset = 180 - splitAnglesOffset, Range = splitAnglesRange},
        {Offset = 180 + splitAnglesOffset, Range = splitAnglesRange}
    }

    return self:GenerateHueHarmony(hsl, harmonyAmount, angleRefRange, angles, saturationJitter, luminanceJitter)
end

---@param hsl vec3
---@param harmonyAmount integer
---@param anglesRange? number [0-360]
---@param saturationJitter? number [0-1]
---@param luminanceJitter? number [0-1]
---@return vec3[] rgbArray
function Color:GenerateTriadHarmony(hsl, harmonyAmount, anglesRange, saturationJitter, luminanceJitter)
    return self:GenerateSplitComplementaryHarmony(hsl, harmonyAmount, 60, anglesRange, anglesRange, saturationJitter, luminanceJitter)
end

---@param hsl vec3
---@param harmonyAmount integer
---@param saturationJitter? number
---@param luminanceJitter? number
function Color:GenerateMonoColorHarmony(hsl, harmonyAmount, saturationJitter, luminanceJitter)
    local h,s,l = table.unpack(hsl)
    local colors = {self:HSL2RGB(h,s,l)}

    local step = 1/harmonyAmount

    local lowLight = l - step
    while lowLight > 0 do
        local tempS = s
        local tempL = lowLight
        if saturationJitter then
            tempS = self:ApplyJitter(tempS, saturationJitter)
        end
        if luminanceJitter then
            tempL = self:ApplyJitter(tempL, luminanceJitter)
        end
        table.insert(colors, self:HSL2RGB(h, tempS, tempL))
        lowLight = lowLight - step
    end

    local highLight = l + step
    while highLight <= 1 do
        local tempS = s
        local tempL = highLight
        if saturationJitter then
            tempS = self:ApplyJitter(tempS, saturationJitter)
        end
        if luminanceJitter then
            tempL = self:ApplyJitter(tempL, luminanceJitter)
        end
        table.insert(colors, self:HSL2RGB(h, tempS, tempL))
        highLight = highLight + step
    end

    return colors
end

---@param color1 vec3
---@param color2 vec3
---@param strength? number how much the 2nd color to add. 0 = first color only, 1 = second color only
function Color:DualMix(color1, color2, strength)
    strength = strength or 0.5
    local newColor = {}
    for i = 1, 3 do
        newColor[i] = color1[i] * (1 - strength) + color2[i] * strength
    end
    return newColor
end

---@param color1 vec3 rgba
---@param color2 vec3 rgba
---@param color3 vec3 rgba
---@param gray number [0-1] limits the contribution of a random color as a preventative measure towards the tendency to create grays. 0 mixes only 2 colors. 1 mixes all colors evenly (no prevention).
function  Color:TriadMix(color1, color2, color3, gray)
    local mixLimited = _random(1,3)

    local mixRatio1 = mixLimited == 1 and _randomFloat() * gray or _randomFloat()
    local mixRatio2 = mixLimited == 2 and _randomFloat() * gray or _randomFloat()
    local mixRatio3 = mixLimited == 3 and _randomFloat() * gray or _randomFloat()

    local mixSum = mixRatio1 + mixRatio2 + mixRatio3
    mixRatio1 = mixRatio1/mixSum
    mixRatio2 = mixRatio2/mixSum
    mixRatio3 = mixRatio3/mixSum

    local newColor = {}
    for i = 1,3 do
        newColor[i] = mixRatio1 * color1[i] + mixRatio2 * color2[i] + mixRatio3 * color3[i]
    end

    return newColor
end

---@param baseColor vec3 HSL
---@param colorAmount integer
---@return vec3[] RGB[]
function Color:GenerateRandomPalette(baseColor, colorAmount)
    local angleRange = _random(10,30)
    local selection = _random(1,6)

    if selection == 1 then
        return Color:GenerateGoldenRatioColors(baseColor, colorAmount)
    elseif selection == 2 then
        return Color:GenerateAnalogousHarmony(baseColor, colorAmount, colorAmount, angleRange, .1, .2)
    elseif selection == 3 then
        return Color:GenerateComplementaryHarmony(baseColor, colorAmount, angleRange, .1, .2)
    elseif selection == 4 then
        return Color:GenerateSplitComplementaryHarmony(baseColor, colorAmount, angleRange, angleRange, angleRange, .1, .2)
    elseif selection == 5 then
        return Color:GenerateTriadHarmony(baseColor, colorAmount, angleRange, .1, .2)
    elseif selection == 6 then
        return Color:GenerateMonoColorHarmony(baseColor, colorAmount, 0, 0)
    end
end




