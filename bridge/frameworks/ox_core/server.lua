---@diagnostic disable: duplicate-set-field
local Ox = require '@ox_core.lib.init'
local ox_inventory = GetResourceState('ox_inventory') == 'started' and true or false


function stevo_lib.GetIdentifier(source)
    local player = Ox.GetPlayer(source)
    return player.getIdentifier()
end

function stevo_lib.GetName(source)
    local player = Ox.GetPlayer(source)
    return player.get('firstName') .. ' ' .. player.get('lastName')
end

function stevo_lib.GetJobCount(source, job)
    return GlobalState[job .. ':activeCount']
end

function stevo_lib.GetPlayerGroups(source)
    local player = Ox.GetPlayer(source)
    local job = player.get('activeGroup')
    return job, false
end

function stevo_lib.GetPlayerJobInfo(source)
    local player = Ox.GetPlayer(source)
    local activeGroup = player.get('activeGroup')
    local groupInfo = Ox.GetGroup(activeGroup)
    local grade = player.getGroup(activeGroup)

    local jobInfo = {
        name = groupInfo.name,
        label = groupInfo.label,
        grade = grade,
        gradeName = groupInfo.grades[grade],
    }
    return jobInfo
end

function stevo_lib.GetPlayerGangInfo(source) end -- * Not supported in ox_core natively - would require gangs to be set up with a specific type in DB

function stevo_lib.GetPlayers()
    local players = Ox.GetPlayers()
    local formattedPlayers = {}
    for _, v in pairs(players) do
        local player = {
            job = v.get('activeGroup'),
            gang = false,
            source = v.source
        }
        table.insert(formattedPlayers, player)
    end
    return formattedPlayers
end

function stevo_lib.GetDob(source)
    local player = Ox.GetPlayer(source)
    return player.get('dateOfBirth')
end

function stevo_lib.GetSex(source)
    local player = ESX.GetPlayerFromId(source)
    -- ! ox_core has non_binary as a gender. for backwards compatibility non binary will return female
    return player.get('gender') == 'male' and 1 or 2
end

---@param source number
---@param item string
---@param count number
function stevo_lib.RemoveItem(source, item, count)
    if not ox_inventory then return false end
    return exports.ox_inventory:RemoveItem(source, item, count)
end

---@param source number
---@param item string
---@param count number
---@param metadata? table | string
function stevo_lib.AddItem(source, item, count, metadata)
    if not ox_inventory then return false end
    return exports.ox_inventory:AddItem(source, item, count, metadata)
end

function stevo_lib.HasItem(source, item)
    if not ox_inventory then return false end
    local itemCount = exports.ox_inventory:GetItemCount(source, item)
    return itemCount
end

function stevo_lib.GetInventory(source)
    if not ox_inventory then return false end
    local items = {}
    local data = ox_inventory and exports.ox_inventory:GetInventoryItems(source)
    for i = 1, #data do
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

function stevo_lib.SetJob(source, jobName, jobGrade)
    local player = Ox.GetPlayer(source)
    local job = tostring(jobName)
    local grade = tonumber(jobGrade)
    player.setGroup(job, grade)
    return player.setActiveGroup(job) -- * ox_core requires setting the active group separately
end

-- * Extra usable varibales for the cb in RegisterUsableItem
function stevo_lib.RegisterUsableItem(_item, cb)
    if not ox_inventory then return false end
    exports(_item, function(event, item, inventory, slot, data)
        cb(inventory.source, event, item, inventory, slot, data)
    end)
end
