local config = lib.require('config')
local displayedTextUI = {}

function stevo_lib.Notify(msg, type, duration)

	if not duration then duration = 3000 end
		
	if config.NotifyType == 'qb' or config.NotifyType == 'ESX' or config.NotifyType == 'QBOX' then
		if stevo_lib.framework == config.NotifyType then 
			stevo_lib.bridgeNotify(msg, type, duration) 
		else 
			return error('[Stevo Library] config.NotifyType = '..config.NotifyType..' but server is not '..config.NotifyType..'') 
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

---@param text string
---@param key string
---@return number
function stevo_lib.displayTextUI(text, key)
	local invokingResource = GetInvokingResource()
	local displayedTextUIs = #displayedTextUI
	local id = displayedTextUIs+1
	if displayedTextUIs == 1 and config.TextUIType ~= 'ls_textui' then return error('Cannot display TextUI > TextUI already displaying!! InvokingResource: '..invokingResource) end


	if config.TextUIType == 'ox_lib' then
		lib.showTextUI(text)
	end


	if config.TextUIType == 'ls_textui' then
		exports.ls_textui:showTextUI(id, key, text)
	end

	if config.TextUIType == 'custom' then
		return error('config.TextUIType = custom but no custom TextUI was added.') -- Remove me if using custom textui.
	end

	displayedTextUI[id] = true

	return id
end

---@param id number
function stevo_lib.hideTextUI(id)
	local invokingResource = GetInvokingResource()
	local displayedTextUIs = #displayedTextUI
	if displayedTextUIs == 0 then return error('Cannot hide TextUI > TextUI not displaying!! InvokingResource: '..invokingResource) end


	if config.TextUIType == 'ox_lib' then
		lib.hideTextUI()
	end

	if config.TextUIType == 'ls_textui' then
		exports.ls_textui:hideTextUI(id)
	end

	if config.TextUIType == 'custom' then
		return error('config.TextUIType = custom but no custom TextUI was added.') -- Remove me if using custom textui.
	end

	displayedTextUI[id] = nil
end




