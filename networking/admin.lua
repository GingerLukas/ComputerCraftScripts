if not require("networking") then
    return print("networking.lua not found")
end

Networking.Init(Roles.Admin)

Admin = {
    Location = gps.locate()
}

function SendInfo(id,protocol)
    rednet.send(id,Admin,protocol)
    return true
end

function Mine(payload)
    local function magnitude(v)
        return math.pow(v.x,2)+math.pow(v.y,2)+math.pow(v.z,2)
    end
    local providers = Networking.HostsIds(Protocols.ProviderAdmin)
    if table.getn(providers) == 0 then
        return false
    end
    local bestMag = magnitude(providers[1]-payload.start)
    local bestIndex = 1
    for i = 2, table.getn(providers) do
        local mag = magnitude(providers[i]-payload.start)
        if mag < bestMag then
            bestMag = mag
            bestIndex = i
        end
    end
    return Networking.RequestWorkById(providers[bestIndex],payload,Protocols.ProviderAdmin)
end

function ProcessMessage()
    local id, payload, protocol = rednet.receive(Protocols.AdminUser)
    if payload.action == Actions.Request then
        if payload.request == Requests.Mine then
            return Mine(payload)
        elseif payload.request == Requests.Info then
            return SendInfo(id,protocol)
        end
    end
end

while true do
    ProcessMessage()
end