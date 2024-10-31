stevo_lib = {}
stevo_lib.keys = {}
stevo_lib.target = {}

exports("import", function()
    return stevo_lib
end)

-- Framework and dependency detection
local qb = GetResourceState('qb-core')
local qbx = GetResourceState('qbx_core')
local esx = GetResourceState('es_extended')
local ox = GetResourceState('ox_core')

if ox == 'started' then 
    return error('[Stevo Library] ox_core is not supported by stevo_lib currently.')
end

local framework = qbx == 'started' and 'qbx_core' or qb == 'started' and 'qb-core' or esx == 'started' and 'es_extended' or nil 
if not framework then 
    return error('[Stevo Library] Unable to find framework, This could be because you are using a modified framework name.') 
end

stevo_lib.framework = framework

local file_path = ('bridge/frameworks/%s/server.lua'):format(framework)

local resourceFile = LoadResourceFile(cache.resource, file_path)

if not resourceFile then
    return error(("Unable to find file at path '%s'"):format(file_path))
end

local ld, err = load(resourceFile, ('@@%s/%s'):format(cache.resource, file_path))

if not ld or err then
    return error(err)
end

ld()

-- Detect and load keys system
local qb_vehiclekeys = GetResourceState('qb-vehiclekeys')
local qbx_vehiclekeys = GetResourceState('qbx_vehiclekeys')
local renewed_vehiclekeys = GetResourceState('Renewed-VehicleKeys')
local wasabi_carlock = GetResourceState('wasabi_carlock')
local keys = qb_vehiclekeys == 'started' and 'qb-vehiclekeys' or qbx_vehiclekeys == 'started' and 'qbx_vehiclekeys' or renewed_vehiclekeys == 'started' and 'Renewed-VehicleKeys' or wasabi_carlock == 'started' and 'wasabi_carlock' or nil

if not keys then 
    print('[Stevo Library] Unable to find your keys system, defaulting to placeholder.')
    keys = 'placeholder' 
end

stevo_lib.keys = require(string.format('bridge.keys.%s.server', keys))



print('[Stevo Library] Loaded Modules')