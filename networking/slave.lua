if not require("pathing") then
    return print("pathing.lua not found")
end
if not require("mining") then
    return print("mining.lua not found")
end
if not require("networking") then
    return print("networking.lua not found")
end

Slave = {
    Location = gps.locate()
}

function Slave.update()
    Slave.Location = gps.locate()
end

function SendInfo(id, protocol)
    Slave.update()
    rednet.send(id,Slave,protocol)
    return true
end

function Mine(start,cube)
    Pathing.go_to(start)
    Pathing.set_dir(0)
    Mining.clear_cube(cube.x,cube.y,cube.z)
    return true
end

function ProcessMessage()
    local id,payload,protocol = rednet.receive(Protocols.SlaveProvider)
    if payload.action == Actions.Request then
        if payload.request == Requests.Mine then
            Networking.ConfirmWork(id,protocol)
            return Mine(payload.start,payload.cube)
        elseif payload.request == Requests.Info then
            return SendInfo(id,protocol)
        end
    end
end

Networking.Init(Roles.Slave)

while true do
    ProcessMessage()
end