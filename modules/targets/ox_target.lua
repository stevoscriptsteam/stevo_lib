local config = lib.require('config')
local activeTargets = {}
stevo_lib.target = {}


local function convert(options)
    local distance = options.distance
    options = options.options
    for _, v in pairs(options) do
        v.onSelect = v.action
        v.distance = v.distance or distance
        v.name = v.name or v.label
        v.groups = v.job or v.gang
        v.type = nil
        v.action = nil

        v.job = nil
        v.gang = nil
        v.qtarget = true
    end

    return options
end


function stevo_lib.target.AddTargetEntity(entity, parameters)
    exports.ox_target:addLocalEntity(entity, convert(parameters))
    local resource = GetInvokingResource()
    activeTargets[entity] = {}
    activeTargets[entity].entity = entity
    activeTargets[entity].type = 'entity'
    activeTargets[entity].invokingResource = resource
end

if config.useInteract then 
    function stevo_lib.target.AddBoxZone(name, coords, size, parameters)

        exports.interact:AddInteraction({
            coords = coords,
            id = name, 
            options = convert(parameters)
        })
        
        local resource = GetInvokingResource()
        activeTargets[name] = {}
        activeTargets[name].id = name
        activeTargets[name].type = 'zone'
        activeTargets[name].invokingResource = resource
    end
else
    function stevo_lib.target.AddBoxZone(name, coords, size, parameters)

        local rotation = parameters.rotation
        local id = exports.ox_target:addBoxZone({
            coords = coords,
            size = size,
            rotation = rotation,
            debug = false,
            options = convert(parameters)
        })
        local resource = GetInvokingResource()
        activeTargets[name] = {}
        activeTargets[name].id = id
        activeTargets[name].type = 'zone'
        activeTargets[name].invokingResource = resource

    end
end

function stevo_lib.target.RemoveZone(zone)
    exports.ox_target:removeZone(activeTargets[zone].id)
    activeTargets[zone] = {}
end


function stevo_lib.target.addGlobalPed(name, options)

    exports.ox_target:addGlobalPed(convert(options))

    local resource = GetInvokingResource()
    activeTargets[name] = {}
    activeTargets[name].id = name
    activeTargets[name].type = 'globalPed'
    activeTargets[name].options = convert(options)
    activeTargets[name].invokingResource = resource
end

local function resourceStopped(resource)
    for _, target in pairs(activeTargets) do
        if target.invokingResource == resource then

            if target.options then  
                local optionNames = {}
                for _, option in ipairs(target.options) do
                    optionNames[#optionNames + 1] = option.name
                end
            end

            if target.type == 'zone' then

                if config.useInteract then
                    exports.interact:RemoveInteraction(target.id)
                else
                    exports.ox_target:removeZone(target.id)
                end
                activeTargets[_] = {}
            elseif target.type == 'entity' then
                if DoesEntityExist(target.entity) then 
                    exports.ox_target:removeLocalEntity(target.entity)
                end
                activeTargets[_] = {}
            elseif target.type == 'globalPed' then
                exports.ox_target:removeGlobalPed(optionNames)
                activeTargets[_] = {}
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource) resourceStopped(resource) end)



