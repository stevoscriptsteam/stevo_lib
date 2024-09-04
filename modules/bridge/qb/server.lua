local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = GetResourceState('ox_inventory') == 'started' and true or false

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

function stevo_lib.GetPlayers()
    local players = QBCore.Functions.GetQBPlayers()
    local formattedPlayers = {}
    for _, v in pairs(players) do
        local player = {
            job = v.PlayerData.job.name,
            gang = v.PlayerData.gang.name,
            source = v.PlayerData.source
        }
        table.insert(formattedPlayers, player)
    end
    return formattedPlayers
end

function stevo_lib.GetPlayerGroups(source)
    local player = stevo_lib.GetPlayer(source)
    return player.PlayerData.job, player.PlayerData.gang
end

function stevo_lib.GetDob(source)
    local player = stevo_lib.GetPlayer(source)
    return player.PlayerData.charinfo.birthdate
end

function stevo_lib.GetSex(source)
    local player = stevo_lib.GetPlayer(source)
    return player.PlayerData.charinfo.gender
end

function stevo_lib.RemoveItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.Functions.RemoveItem(item, count)
end

function stevo_lib.AddItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.Functions.AddItem(item, count)
end

function stevo_lib.HasItem(source, _item)
    local player = stevo_lib.GetPlayer(source)
    local item = player.Functions.GetItemByName(_item)
    return item?.count or item?.amount or 0
end

function stevo_lib.GetInventory(source)
    local player = stevo_lib.GetPlayer(source)
    local items = {}
    local data = ox_inventory and exports.ox_inventory:GetInventoryItems(source) or player.PlayerData.items

    for slot, item in pairs(data) do 

        items[#items + 1] = {
            name = item.name,
            label = item.label,
            count = ox_inventory and item.count or item.amount,
            weight = item.weight,
            metadata = ox_inventory and item.metadata or item.info
        }

    end


    return items
end

function stevo_lib.RegisterUsableItem(item, cb)
    QBCore.Functions.CreateUseableItem(item, cb)
end





