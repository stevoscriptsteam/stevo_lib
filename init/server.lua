stevo_lib = {}

exports("import", function()
	return stevo_lib
end)

-- Framework
local qb = GetResourceState('qb-core')
local qbox = GetResourceState('qbx_core')
local esx = GetResourceState('es_extended')
local ox = GetResourceState('ox_core')
local framework = ox == 'started' and 'ox' or qbox == 'started' and 'qb' or qb == 'started' and 'qb' or esx == 'started' and 'esx' or nil 

if not framework then return error('Unable to find framework, This could be because you are using a modified framework name.') end

stevo_lib.framework = framework

local file_paths = {
    ('modules/bridge/%s/server.lua'):format(framework),
}

for _, file_path in ipairs(file_paths) do
    local resourceFile = LoadResourceFile(cache.resource, file_path)

    if not resourceFile then
        return error(("Unable to find script at path '%s'"):format(file_path))
    end

    local ld, err = load(resourceFile, ('@@%s/%s'):format(cache.resource, file_path))

    if not ld or err then
        return error(err)
    end

    ld()
end


