local ESX = exports.es_extended:getSharedObject()

function stevo_lib.GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function stevo_lib.GetIdentifier(source)
    local player = stevo_lib.GetPlayer(source)
    return player.getIdentifier()
end

function stevo_lib.GetName(source)
    local player = stevo_lib.GetPlayer(source)
    return player.getName()
end

function stevo_lib.GetJobCount(source, job)
    return ESX.GetExtendedPlayers('job', job)
end

function stevo_lib.GetPlayerGroups(source)
    local player = stevo_lib.GetPlayer(source)
    local job = player.getJob()
    return job.name, false
end


