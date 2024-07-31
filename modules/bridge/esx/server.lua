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


function stevo_lib.HasItem(source, _item)
    local player = stevo_lib.GetPlayer(source)
    local item = player.getInventoryItem(_item)
    return item?.amount or item?.count or 0
end

function stevo_lib.RemoveItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.removeInventoryItem(item, count)
end

function stevo_lib.AddItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.addInventoryItem(item, count)
end

