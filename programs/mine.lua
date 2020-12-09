if not require("pathing") then
    return print("pathing.lua not found")
end
if not require("mining") then
    return print("mining.lua not found")
end

if table.getn(arg) < 6 then
    return print("mine <x0> <y0> <z0> <x1> <y1> <z1>")
end

local point0 = vector.new(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]))
local point1 = vector.new(tonumber(arg[4]),tonumber(arg[5]),tonumber(arg[6]))

local cube = point0 - point1
cube = vector.new(math.abs(cube.x)+1,math.abs(cube.y)+1,math.abs(cube.z)+1)

local start = vector.new(math.min(point0.x,point1.x),math.min(point0.y,point1.y),math.min(point0.z,point1.z))

Pathing.go_to(start)
print(Pathing.face)
Pathing.set_dir(0)
Mining.clear_cube(cube.x,cube.y,cube.z,false)
Pathing.return_home()
