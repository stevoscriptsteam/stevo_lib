stevo_lib.target = {}
stevo_lib.target.active = {}

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
    stevo_lib.target.active[entity] = {}
    stevo_lib.target.active[entity].entity = entity
    stevo_lib.target.active[entity].type = 'entity'
    stevo_lib.target.active[entity].invokingResource = resource
end

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
    stevo_lib.target.active[name] = {}
    stevo_lib.target.active[name].id = id
    stevo_lib.target.active[name].type = 'zone'
    stevo_lib.target.active[name].invokingResource = resource
end

function stevo_lib.target.RemoveZone(zone)
    exports.ox_target:removeZone(stevo_lib.target.active[zone].id)
    stevo_lib.target.active[zone] = {}
end


function stevo_lib.target.addGlobalPed(name, options)

    exports.ox_target:addGlobalPed(convert(options))

    local resource = GetInvokingResource()
    stevo_lib.target.active[name] = {}
    stevo_lib.target.active[name].id = name
    stevo_lib.target.active[name].type = 'globalPed'
    stevo_lib.target.active[name].options = convert(options)
    stevo_lib.target.active[name].invokingResource = resource
end

local function resourceStopped(resource)
    for _, target in pairs(stevo_lib.target.active) do
        if target.invokingResource == resource then 
            local optionNames = {}
            for _, option in ipairs(target.options) do
                optionNames[#optionNames + 1] = option.name
            end
            if target.type == 'zone' then
                exports.ox_target:removeZone(target.id)
                stevo_lib.target.active[_] = {}
            elseif target.type == 'entity' then
                if DoesEntityExist(target.entity) then 
                    exports.ox_target:removeLocalEntity(target.entity)
                end
                stevo_lib.target.active[_] = {}
            elseif target.type == 'globalPed' then
                exports.ox_target:removeGlobalPed(optionNames)
                stevo_lib.target.active[_] = {}
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource) resourceStopped(resource) end)



