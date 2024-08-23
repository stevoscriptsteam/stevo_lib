Skills = {}

---@param playerId number
---@return table
function stevo_lib.LoadPlayerSkills(playerId)
    local playerSkills = {}
    local identifier = stevo_lib.GetIdentifier(playerId)

    for skillName, skillData in pairs(Skills) do 
        local key = ('stevo_skill_%s_%s'):format(identifier, skillName)
        local skillExp = GetResourceKvpInt(key) or 0 
        local levels = skillData.levels
        local playerLevel = { name = 'Starter', exp = 0, progress = 0, skillExp = skillExp } 

        if skillExp ~= 0 then 
            local previousLevelExp = 0

            for levelName, levelExp in pairs(levels) do
                if skillExp >= levelExp then 
                    playerLevel.name = levelName
                    playerLevel.exp = levelExp
                    previousLevelExp = levelExp
                else
                    local progress = (skillExp - previousLevelExp) / (levelExp - previousLevelExp) * 100
                    playerLevel.progress = math.floor(progress)
                    break
                end
            end
        end

        -- If you dont do this, it just breaks?
        playerLevel.name = playerLevel.name

        playerSkills[skillName] = playerLevel
    end

    return playerSkills
end

---@param playerId number
---@return table
function stevo_lib.LoadPlayerSkill(playerId, skill)
    local identifier = stevo_lib.GetIdentifier(playerId)
    local key = ('stevo_skill_%s_%s'):format(identifier, skill)
    local skillExp = GetResourceKvpInt(key) or 0 
    local levels = Skills[skill].levels
    local playerLevel = { name = 'Starter', exp = 0, progress = 0, skillExp = skillExp } 

    if skillExp ~= 0 then 
        local previousLevelExp = 0

        for levelName, levelExp in pairs(levels) do
            if skillExp >= levelExp then 
                playerLevel.name = levelName
                playerLevel.exp = levelExp
                previousLevelExp = levelExp
            else
                local progress = (skillExp - previousLevelExp) / (levelExp - previousLevelExp) * 100
                playerLevel.progress = math.floor(progress)
                break
            end
        end
    end

    -- If you dont do this, it just breaks?
    playerLevel.name = playerLevel.name

    return playerLevel
end


---@param playerId number
---@param skill string
---@param exp number
function stevo_lib.UpdatePlayerSkills(playerId, skill, exp)
    local identifier = stevo_lib.GetIdentifier(playerId)
    local key = ('stevo_skill_%s_%s'):format(identifier, skill)
    local currentSkill = GetResourceKvpInt(key) or 0 

    local updatedSkill = currentSkill + exp
    SetResourceKvpInt(key, updatedSkill)
end

---@param data table
function stevo_lib.RegisterSkill(data)
    local skillName = data.name 
    local skillLevels = data.levels 

    Skills[skillName] = { levels = skillLevels }
    print(("Skill registered: %s"):format(skillName))
end

lib.callback.register('stevo_lib:skills:loadPlayerSkills', function(source)
    return stevo_lib.LoadPlayerSkills(source)
end)

lib.callback.register('stevo_lib:skills:loadPlayerSkill', function(source, skill)
    return stevo_lib.LoadPlayerSkill(source, skill)
end)

lib.callback.register('stevo_lib:skills:updatePlayerSkills', function(source, skill, exp)
    return stevo_lib.UpdatePlayerSkills(source, skill, exp)
end)


-- stevo_lib.RegisterSkill({
--     name = 'Cooking', 
--     levels = {
--         ['Line Cook'] = 0, 
--         ['Cook'] = 100, 
--         ['Chef'] = 200, 
--         ['Executive Chef'] = 300
--     }
-- })

-- stevo_lib.RegisterSkill({
--     name = 'Hacking', 
--     levels = {
--         ['Noob'] = 0, 
--         ['Geek'] = 100, 
--         ['Techie'] = 200, 
--         ['Expert'] = 300
--     }
-- })