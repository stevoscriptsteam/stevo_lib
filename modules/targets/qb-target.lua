local config = lib.require('config')
stevo_lib.target = {}
stevo_lib.target.active = {}

function stevo_lib.target.AddTargetEntity(entity, parameters)
    exports["qb-target"]:AddTargetEntity(entity, parameters)
    local resource = GetInvokingResource()
    stevo_lib.target.active[entity] = {}
    stevo_lib.target.active[entity].entity = entity
    stevo_lib.target.active[entity].type = 'entity'
    stevo_lib.target.active[entity].invokingResource = resource
end

if config.useInteract then 
    function stevo_lib.target.AddBoxZone(name, coords, size, parameters)

        exports.interact:AddInteraction({
            coords = coords,
            id = name, -- needed for removing interactions
            options = convert(parameters)
        })
        
        local resource = GetInvokingResource()
        stevo_lib.target.active[name] = {}
        stevo_lib.target.active[name].id = name
        stevo_lib.target.active[name].type = 'zone'
        stevo_lib.target.active[name].invokingResource = resource
    end
else
    function stevo_lib.target.AddBoxZone(name, coords, size, parameters)
        exports["qb-target"]:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            debugPoly = false,
            minZ = coords.z - 2,
            maxZ = coords.z + 2,
            heading = coords.w
        }, parameters)

        local resource = GetInvokingResource()
        stevo_lib.target.active[name] = {}
        stevo_lib.target.active[name].id = name
        stevo_lib.target.active[name].type = 'zone'
        stevo_lib.target.active[name].invokingResource = resource
    end
end

function stevo_lib.target.RemoveZone(zone)
    exports["qb-target"]:RemoveZone(zone)
    stevo_lib.target.active[zone] = {}
end

function stevo_lib.target.addGlobalPed(name, options)
    exports['qb-target']:AddGlobalPed(options)

    local resource = GetInvokingResource()
    stevo_lib.target.active[name] = {}
    stevo_lib.target.active[name].id = name
    stevo_lib.target.active[name].type = 'globalPed'
    stevo_lib.target.active[name].options = options
    stevo_lib.target.active[name].invokingResource = resource
end




if stevo_lib.target == 'qb' then 


    local function resourceStopped(resource)
        for _, target in pairs(stevo_lib.target.active) do
            if target.invokingResource == resource then 
                local optionNames = {}
                for _, option in ipairs(target.options.options) do
                    optionNames[#optionNames + 1] = option.label
                end
                if target.type == 'zone' then
                    if config.useInteract then
                        exports.interact:RemoveInteraction(target.id)
                    else
                        exports["qb-target"]:RemoveZone(target.id)
                    end
                    stevo_lib.target.active[_] = {}
                elseif target.type == 'entity' then
                    if DoesEntityExist(target.entity) then 
                        exports['qb-target']:RemoveTargetEntity(target.entity)
                    end
                    stevo_lib.target.active[_] = {}
                elseif target.type == 'globalPed' then
                    exports['qb-target']:RemoveGlobalType(1, optionNames)
                    stevo_lib.target.active[_] = {}
                elseif target.type == 'globalObject' then
                    exports['qb-target']:RemoveGlobalType(3, optionNames)
                    stevo_lib.target.active[_] = {}
                end
            end
        end
    end


    AddEventHandler('onResourceStop', function(resource) resourceStopped(resource) end)
end

