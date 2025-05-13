Helpers = Helpers or {}
Helpers.Math = Helpers.Math or {}

--- Converts a quaternion [x,y,z,w] to Euler angles [x,y,z] (roll, pitch, yaw).
---@param quat vec4
---@return vec3
function Helpers.Math.QuatToEuler(quat)
    local x, y, z, w = quat[1], quat[2], quat[3], quat[4]

    -- Roll (X)
    local t0 = 2.0 * (w * x + y * z)
    local t1 = 1.0 - 2.0 * (x * x + y * y)
    local roll = math.deg(math.atan(t0, t1))

    -- Pitch (Y)
    local t2 = 2.0 * (w * y - z * x)
    t2 = t2 > 1.0 and 1.0 or t2
    t2 = t2 < -1.0 and -1.0 or t2
    local pitch = math.deg(math.asin(t2))

    -- Yaw (Z)
    local t3 = 2.0 * (w * z + x * y)
    local t4 = 1.0 - 2.0 * (y * y + z * z)
    local yaw = math.deg(math.atan(t3, t4))

    return {roll, pitch, yaw}
end