if not require("pathing") then
    return print("pathing.lua not found")
end

if table.getn(arg) < 3 then
    return print("goto <x> <y> <z>")
end

Pathing.go_to(vector.new(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3])))