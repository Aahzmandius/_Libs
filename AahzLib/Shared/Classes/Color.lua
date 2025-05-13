-- Override FocusCore to add alpha
---@param h number [0;1] hue
---@param s number [0;1] saturation
---@param l number [0;1] luminance
---@param a number? [0;1] alpha
---@diagnostic disable-next-line: duplicate-set-field
function Color:HSL2RGB(h,s,l,a)
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
    if a ~= nil then
        return {r,g,b,a}
    else
        return {r,g,b}
    end
end