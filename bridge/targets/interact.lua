local activeTargets = {}

local function convert(options)
    local distance = options.distance
    options = options.options
    for _, v in pairs(options) do
        v.action = v.onSelect
        v.name = v.name or v.label
        v.groups = v.groups or {}
    end

    return options
end

local function resourceStopped(resource)
    for _, target in pairs(activeTargets) do
        if target.invokingResource == resource then

            if target.type == 'zone' then
                exports.interact:RemoveInteraction(target.id)
                activeTargets[_] = {}

            elseif target.type == 'entity' then
                if DoesEntityExist(target.entity) then 
                    exports.interact:RemoveLocalEntityInteraction(target.entity, target.id)
                end
                activeTargets[_] = {}

            elseif target.type == 'globalPed' then
                exports.interact:RemoveGlobalPlayerInteraction(target.id)
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
        return error('We are not supporting AddTargetEntity for interact yet, we will as soon as possible.')
    end,

    AddBoxZone = function(name, coords, size, parameters)

        exports.interact:AddInteraction({
            coords = coords,
            distance = parameters.distance, 
            interactDst = parameters.distance,
            id = name, 
            options = parameters.options
        })
        
        local resource = GetInvokingResource()
        activeTargets[name] = {
            id = name,
            type = 'zone',
            invokingResource = resource
        }
    end,

    RemoveZone = function(zone)
        exports.interact:RemoveInteraction(activeTargets[zone].id)
        activeTargets[zone] = {}
    end,

    addGlobalPed = function(name, options)
        exports.interact:addGlobalPlayerInteraction({
            id = name,
            options = convert(options)
        })
        local resource = GetInvokingResource()
        activeTargets[name] = {
            id = name,
            type = 'globalPed',
            options = convert(options),
            invokingResource = resource
        }
    end
}
