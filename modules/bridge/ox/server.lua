if not lib.checkDependency('ox_core', '0.21.3', true) then return end

local Ox = require '@ox_core.lib.init'

function stevo_lib.GetPlayer(source)
    return Ox.GetPlayer(source)
end

function stevo_lib.GetIdentifier(source)
	local player = stevo_lib.GetPlayer(source)
    return player.charId
end

function stevo_lib.GetName(source)
    return GetPlayerName(source)
end
