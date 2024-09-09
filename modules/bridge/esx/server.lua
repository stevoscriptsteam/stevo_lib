local ESX = exports.es_extended:getSharedObject()
local ox_inventory = GetResourceState('ox_inventory') == 'started' and true or false

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

function stevo_lib.GetPlayerJobInfo(source)
    local player = stevo_lib.GetPlayer(source)
    local job = player.getJob()
    local jobInfo = {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.grade_label,
    }
    return jobInfo
end

function stevo_lib.GetPlayerGangInfo(source)
    return false    
end

function stevo_lib.GetPlayers()
    local players = ESX.GetExtendedPlayers()
    local formattedPlayers = {}
    for _, v in pairs(players) do
        local player = {
            job = v.getJob().name,
            gang = false,
            source = v.source
        }
        table.insert(formattedPlayers, player)
    end
    return formattedPlayers
end

function stevo_lib.GetDob(source)
    local player = stevo_lib.GetPlayer(source)
    return player.variables.dateofbirth
end

function stevo_lib.GetSex(source)
    local player = stevo_lib.GetPlayer(source)
    return player.variables.sex
end

function stevo_lib.RemoveItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.removeInventoryItem(item, count)
end

function stevo_lib.AddItem(source, item, count)
    local player = stevo_lib.GetPlayer(source)
    return player.addInventoryItem(item, count)
end

function stevo_lib.HasItem(source, _item)
    local player = stevo_lib.GetPlayer(source)
    local item = player.getInventoryItem(_item)
    return item?.amount or item?.count or 0
end

function stevo_lib.GetInventory(source)
    local player = stevo_lib.GetPlayer(source)
    local items = {}
    local data = ox_inventory and exports.ox_inventory:GetInventoryItems(source) or player.getInventory()
    for i=1, #data do 
        local item = data[i]
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
    ESX.RegisterUsableItem(item, cb)
end

