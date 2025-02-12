---@diagnostic disable: duplicate-set-field
local Ox = require '@ox_core.lib.init'
local player = Ox.GetPlayer()
local isDead

function stevo_lib.bridgeNotify(msg, type, duration)
    -- ox_lib is a dependency of ox_core, `lib` will always be available
    lib.notify({
        description = msg,
        type = type,
        duration = duration
    })
end

function stevo_lib.GetPlayerGroups()
    return player.get('activeGroup'), false
end

function stevo_lib.GetPlayerGroupInfo()
    local activeGroup = player.get('activeGroup')
    local jobInfo = {
        name = activeGroup,
        grade = player.getGroup(activeGroup),
        label = Ox.GetGroup(activeGroup).label
    }

    return jobInfo
end

function stevo_lib.GetSex()
    -- ! ox_core has non_binary as a gender. for backwards compatibility non binary will return female
    return player.get('gender') == 'male' and 1 or 2
end

function stevo_lib.IsDead()
    return isDead
end

---@deprecated ox_core does not have built in support for outfits
function stevo_lib.SetOutfit() end

AddEventHandler('ox:playerRevived', function()
    isDead = nil
end)

AddEventHandler('ox:playerDeath', function()
    isDead = true
    TriggerEvent('stevo_lib:playerDied')
end)

AddEventHandler('ox:playerLoaded', function()
    player = Ox.GetPlayer()
    TriggerEvent('stevo_lib:playerLoaded')
end)
