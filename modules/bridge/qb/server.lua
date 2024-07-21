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

