if not require("networking") then
    return print("networking.lua not found")
end

Provider = {
    Location = gps.locate()
}

function Mine(start,cube)
    local slaves = Networking.HostsIds(Protocols.SlaveProvider)
    if not slaves then
        return false
    end
    local slave = slaves[1]
    if not slave then
        return false
    end
    return Networking.RequestWorkById(slave,{action=Actions.Request,request = Requests.Mine,start = start,cube = cube},Protocols.SlaveProvider,5)
end

function SendInfo(id,protocol)
    rednet.send(id,Provider,protocol)
    return true;
end

function ProcessMessage()
    local id, payload, protocol = rednet.receive(Protocols.ProviderAdmin)
    if payload.action == Actions.Request then
        if payload.request == Requests.Mine then
            return Mine(payload.start,payload.cube)
        elseif payload.request == Requests.Info then
            return SendInfo(id,protocol)
        end
    end
    return true
end



Networking.Init(Roles.Provider)

while true do
    ProcessMessage()
end