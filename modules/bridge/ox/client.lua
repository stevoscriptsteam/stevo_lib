if not lib.checkDependency('ox_core', '0.21.3', true) then return end

local Ox = require '@ox_core.lib.init'
local Config = lib.require('config')


function stevo_lib.Notify(msg, type)
	if Config.NotifyType == 'ox_lib' then
		lib.notify({
			title = msg,
			type = type
		})
	end
	if Config.NotifyType == 'okok' then
		exports['okokNotify']:Alert("🔔   Notification   🔔", msg, 3000, type)
	end
	if Config.NotifyType == 'custom' then
		-- Your notify script here
	end
end

RegisterNetEvent('ox:playerLoaded', function()
    TriggerEvent('stevo_lib:playerLoaded')
end)