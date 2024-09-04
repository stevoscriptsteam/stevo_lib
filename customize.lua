local config = lib.require('config')



function stevo_lib.Notify(msg, type, duration)

	if not duration then duration = 3000 end
		
	if config.NotifyType == 'qb' or config.NotifyType == 'ESX' or config.NotifyType == 'QBOX' then
		if stevo_lib.framework == config.NotifyType then 
			stevo_lib.bridgeNotify(msg, type, duration) 
		else 
			return error('config.NotifyType = '..config.NotifyType..' but server is not '..config.NotifyType..'') 
		end 
	end



	if config.NotifyType == 'ox_lib' then
		lib.notify({
			title = msg,
			type = type,
			duration = duration
		})
		return true
	elseif config.NotifyType == 'okok' then
		exports['okokNotify']:Alert("🔔   Notification   🔔", msg, duration, type)
		return true
	elseif config.NotifyType == 'custom' then
		return error('config.NotifyType = custom but no custom Notify was added.') -- Remove me if using custom notify.
	end
end


