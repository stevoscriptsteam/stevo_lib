local activeTargets = {}

local function resourceStopped(resource)
    for _, target in pairs(activeTargets) do
        if target.invokingResource == resource then 
            local optionNames = {}
            if target.options and target.options.options then
                for _, option in ipairs(target.options.options) do
                    optionNames[#optionNames + 1] = option.label
                end
            end
            
            if target.type == 'zone' then
                exports["qb-target"]:RemoveZone(target.id)
                activeTargets[_] = {}
                
            elseif target.type == 'entity' then
                if DoesEntityExist(target.entity) then 
                    exports['qb-target']:RemoveTargetEntity(target.entity)
                end
                activeTargets[_] = {}

            elseif target.type == 'globalPed' then
                exports['qb-target']:RemoveGlobalType(1, optionNames)
                activeTargets[_] = {}

            elseif target.type == 'globalObject' then
                exports['qb-target']:RemoveGlobalType(3, optionNames)
                activeTargets[_] = {}
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    resourceStopped(resource)
end)

return {
    AddTargetEntity = function(entity, parameters)
        exports["qb-target"]:AddTargetEntity(entity, parameters)
        local resource = GetInvokingResource()
        activeTargets[entity] = {
            entity = entity,
            type = 'entity',
            invokingResource = resource
        }
    end,

    AddBoxZone = function(name, coords, size, parameters)
        exports["qb-target"]:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            debugPoly = false,
            minZ = coords.z - 2,
            maxZ = coords.z + 2,
            heading = coords.w
        }, parameters)
        
        local resource = GetInvokingResource()
        activeTargets[name] = {
            id = name,
            type = 'zone',
            invokingResource = resource
        }
    end,

    RemoveZone = function(zone)
        exports["qb-target"]:RemoveZone(zone)
        activeTargets[zone] = {}
    end,

    addGlobalPed = function(name, options)
        exports['qb-target']:AddGlobalPed(options)
        
        local resource = GetInvokingResource()
        activeTargets[name] = {
            id = name,
            type = 'globalPed',
            options = options,
            invokingResource = resource
        }
    end
}
