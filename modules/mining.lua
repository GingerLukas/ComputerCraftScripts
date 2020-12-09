if not require("pathing") then
    return print("pathing.lua not found")
end
Mining = {
    home = nil,
    face = 0
}
function Mining.relative_position()
    if Mining.home == nil then
        return nil
    end
    return vector.new(gps.locate(2)) - Mining.home
end

function Mining.return_home()
    if Mining.home == nil then
        print("Mining: home is not set, return_home canceled")
        return nil
    end
    print("Relative position to hone:"..tostring(Mining.relative_position()))
    Pathing.turnLeft()
    local max0 = 0 
    local max1 = 0
    if Mining.face%2 == 0 then
        max0 = math.abs(Mining.relative_position().z)
        max1 = math.abs(Mining.relative_position().x)
    else
        max0 = math.abs(Mining.relative_position().x)
        max1 = math.abs(Mining.relative_position().z)
    end
    Pathing.forward(max0)
    Pathing.turnLeft()
    Pathing.forward(max1)
    Pathing.turnLeft()
    Pathing.turnLeft()
end

function Mining.clear_level(x, y)
    print("Mining: clear_level("..x..", "..y..")")
    if x<=0 then
        return false
    end
    if y<=0 then 
        return false
    end
    Pathing.forward(x-1)
    Pathing.turnRight()
    Pathing.forward(y-1)
    Pathing.turnRight()
    Pathing.forward(x-1)
    Pathing.turnRight()
    Pathing.forward(y-2)
    Pathing.turnRight()
    if x-2 > 0 and y-2 > 0 then
        Pathing.forward()
    end
    Mining.clear_level(x-2,y-2)
    return true
end

function Mining.clear_cube(x, y, z)
    Mining.face = Pathing.face
    if Mining.home == nil then
        Mining.home = vector.new(gps.locate(2))
    end
    for i=1,y,1 do
        Mining.clear_level(x,z)
        Mining.return_home()
        print("level "..i.." fully completed")
        if i >= y then
            Mining.home = nil
            return true
        end
        Pathing.up()
    end
end