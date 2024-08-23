

---@param animDict string
---@return string animDict
local function requestAnimDict(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Wait(0) end
	return animDict
end

---@param modelHash string
---@return string modelHash
local function requestModel(modelHash)
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do Wait(0) end
	return modelHash
end


---@param ped integer
---@param clip string 
---@param anim string 
---@param time number
function stevo_lib.playAnim(ped, clip, anim, time)

	local dict = requestAnimDict(clip)

 	TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 49, 0, true, true, true)

	if time then 
		Wait(time)
		ClearPedTasks(ped)
	end

	RemoveAnimDict(dict)
end


---@param params table
function stevo_lib.playAudio(params) -- Native PlaySound logic from qbx_core
	local audioName = params.audioName
	local audioRef = params.audioRef
	local returnSoundId = params.returnSoundId or false
	local source = params.audioSource
	local range = params.range or 5.0

	local soundId = GetSoundId()

	local sourceType = type(source)
	if sourceType == 'vector3' then
		local coords = source
		PlaySoundFromCoord(soundId, audioName, coords.x, coords.y, coords.z, audioRef, false, range, false)
	elseif sourceType == 'number' then
		PlaySoundFromEntity(soundId, audioName, source, audioRef, false, false)
	else
		PlaySoundFrontend(soundId, audioName, audioRef, true)
	end

	if returnSoundId then
	   return soundId
	end

	ReleaseSoundId(soundId)
end

---@param modelHash string
---@param x integer 
---@param y integer
---@param z integer
---@param heading integer
---@param isNetwork boolean
---@param scriptHostPed boolean
---@return integer ped
function stevo_lib.createPed(modelHash, x, y, z, heading, isNetwork, scriptHostPed)
	requestModel(modelHash)

	local ped = CreatePed(0, modelHash, x, y, z, heading, isNetwork, scriptHostPed)

	SetModelAsNoLongerNeeded(modelHash)

	return ped
end

---@param label string
---@param pos vector3
---@param sprite number
---@param color number
---@param scale integer
function stevo_lib.createBlip(label,pos,sprite,color,scale)
	local blip =  AddBlipForCoord(pos.x, pos.y, pos.z)
	SetBlipSprite (blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, scale)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)
    return blip
end
