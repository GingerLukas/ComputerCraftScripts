if gps.locate(2) == nil then
    return print("Pathing: GPS failed")
end
Pathing = {
    home = vector.new(gps.locate(2)),
    face = -1,
    TRAVELING_Y = 128
}

function Pathing.set_dir(dir)
    local turns = ((dir - Pathing.face)+4)%4
    for i = 1, turns,1 do
        Pathing.turnRight();
    end
end

function Pathing.go_to(goal)
    print("Pathing: go_to("..tostring(goal)..")")

    if Pathing.face == -1 then
        Pathing.get_face()
    end

    local c = vector.new(gps.locate(2))
    local plan = c - goal
    print("Plan: "..tostring(plan))

    Pathing.up(Pathing.TRAVELING_Y-c.y)

    if plan.x < 0 then
        Pathing.set_dir(0)
    else
        Pathing.set_dir(2)
    end
    Pathing.forward(math.abs(plan.x))

    if plan.z < 0 then
        Pathing.set_dir(1)
    else
        Pathing.set_dir(3)
    end
    Pathing.forward(math.abs(plan.z))

    c = vector.new(gps.locate(2))
    Pathing.down(c.y-goal.y)
end

function Pathing.return_home()
    return Pathing.go_to(Pathing.home)
end

function Pathing.up(len)
    len = len or 1
    if len < 0 then
        return Pathing.down(-len)
    end
    for i = 1, len,1 do
        while not turtle.up() do
            turtle.digUp()
        end
    end
end

function Pathing.down(len)
    len = len or 1
    if len < 0 then
        return Pathing.up(-len)
    end
    for i = 1, len,1 do
        while not turtle.down() do
            turtle.digDown()
        end
    end
end

function Pathing.forward(len)
    len = len or 1
    for i = 1, len,1 do
        while not turtle.forward() do
            turtle.dig()
        end
    end
end

function Pathing.turnLeft()
    Pathing.face = math.abs((Pathing.face - 1 + 4)%4)
    return turtle.turnLeft()
end

function Pathing.turnRight()
    Pathing.face = (Pathing.face + 1) % 4
    return turtle.turnRight()
end

function Pathing.get_face()
    local p = vector.new(gps.locate(2))
    Pathing.forward()
    local c = vector.new(gps.locate(2))
    if c.x > p.x then
        Pathing.face = 0
    elseif c.z>p.z then
        Pathing.face = 1
    elseif c.x<p.x then
        Pathing.face = 2
    else
        Pathing.face = 3
    end
    return Pathing.face
end