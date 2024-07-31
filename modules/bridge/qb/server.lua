local QBCore = exports['qb-core']:GetCoreObject()

function stevo_lib.GetPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function stevo_lib.GetIdentifier(source)
    local player = stevo_lib.GetPlayer(source)
    return player.PlayerData.citizenid
end

function stevo_lib.GetName(source)
    local player = stevo_lib.GetPlayer(source)
    return player.PlayerData.charinfo.firstname..' '..player.PlayerData.charinfo.lastname
end

function stevo_lib.GetJobCount(source, job)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.name == job then
            amount = amount + 1
        end
    end
    return amount
end

function stevo_lib.GetPlayerGroups(source)
    local player = stevo_lib.GetPlayer(source)
    return player.PlayerData.job, player.PlayerData.gang
end

function stevo_lib.HasItem(source, _item)
    local player = stevo_lib.GetPlayer(source)
    local item = player.Functions.GetItemByName(_item)
    return item?.count or item?.amount or 0
end

function stevo_lib.RemoveItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.Functions.RemoveItem(item, count)
end

function stevo_lib.AddItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.Functions.AddItem(item, count)
end




