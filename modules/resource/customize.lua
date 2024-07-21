local Config = lib.require('config')



function stevo_lib.Notify(msg, type, duration)

	if not duration then duration = 3000 end
		
	if Config.NotifyType == 'qb' or Config.NotifyType == 'ESX' or Config.NotifyType == 'QBOX' then
		if stevo_lib.framework == Config.NotifyType then 
			stevo_lib.bridgeNotify(msg, type, duration) 
		else 
			return error('Config.NotifyType = '..Config.NotifyType..' but server is not '..Config.NotifyType..'') 
		end 
	end



	if Config.NotifyType == 'ox_lib' then
		lib.notify({
			title = msg,
			type = type,
			duration = duration
		})
		return true
	elseif Config.NotifyType == 'okok' then
		exports['okokNotify']:Alert("🔔   Notification   🔔", msg, duration, type)
		return true
	elseif Config.NotifyType == 'custom' then
		return error('Config.NotifyType = custom but no custom Notify was added.') -- Remove me if using custom notify.
	end
end

function stevo_lib.playAnim(ped, clip, anim, time)

	lib.requestAnimDict(clip)
 	TaskPlayAnim(ped, clip, anim, 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
 	RemoveAnimDict(clip)
	if time then 
		Wait(time)
		ClearPedTasks(ped)
	end

end
