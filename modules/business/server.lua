Businesses = {}


---@param data table
function stevo_lib.RegisterBusiness(data)
    local skillName = data.name 
    local skillLevels = data.levels 

    Skills[skillName] = { levels = skillLevels }
    print(("Business Registered registered: %s"):format(skillName))
end

stevo_lib.RegisterSkill({
    name = 'Hacking', 
    levels = {
        ['Noob'] = 0, 
        ['Geek'] = 100, 
        ['Techie'] = 200, 
        ['Expert'] = 300
    }
})