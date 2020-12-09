Modem = peripheral.find("modem")
if not Modem then
    return print("modem not found")
end

Channels = {
    User = 71,
    Admin = 70,

    ProviderFront = 69,
    ProviderBack = 68,
    FreeSlaves = 67,
}

Roles = {
    User = 1,
    Admin = 2,
    Provider = 3,
    Slave = 4
}

Actions = {
    Info = 1,
    Request = 2,
}

Requests = {
    Info = 1,
    Mine = 2
}

Responses = {
    OK = 1
}

Protocols = {
    SlaveProvider = "slave_master",
    ProviderAdmin = "provider_admin",
    AdminUser = "admin_user"
}

Networking = {
    ResponsePatern = "(%d+);",
    Modem = Modem,
    Role = 0,
    Gateway = nil,
    DefaultTimeout = 2
}

function Networking.Init(role)
    rednet.open(Networking.Modem.getName())
    if role == Roles.User then
        Networking.Gateway = Networking.HostsIds(Protocols.AdminUser)[1]
        if not Networking.Gateway then
           print("no hosts found")
           os.exit(1)
        end
    elseif role == Roles.Admin then
        rednet.host(Protocols.AdminUser,read())
    elseif role == Roles.Provider then
        rednet.host(Protocols.ProviderAdmin,read())
    elseif role == Roles.Slave then
        rednet.host(Protocols.SlaveProvider,read())
    end
    Networking.Role = role
end

function Networking.ConfirmWork(id,protocol)
    rednet.send(id,Responses.OK,protocol)
end

function Networking.WaitForConfirm(id,protocol,timeout)
    timeout = timeout or Networking.DefaultTimeout
    local rId, response, prot = rednet.receive(protocol,timeout)
    while rId ~= id do
        rId, response, prot = rednet.receive(protocol,timeout)
    end
    return response == Responses.OK
end

function Networking.RequestWorkById(id,message,protocol,timeout)
    timeout = timeout or Networking.DefaultTimeout
    rednet.send(id,message,protocol)
    Networking.WaitForConfirm(id,protocol,timeout)
end

function Networking.HostsIds(protocol)
    return rednet.lookup(protocol) or {}
end


