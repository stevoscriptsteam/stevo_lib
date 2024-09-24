lib.locale()
local config = lib.require('config')


function openSkillsMenu()
    local playerSkills = lib.callback.await('stevo_lib:skills:loadPlayerSkills', false) 
    local skillCount = 0
    local menuOptions = {}

    for skillName, skillData in pairs(playerSkills) do
        local option = {
            title = ('## %s\nLevel: *%s* \n%s *Exp*\n \n *%s%% of level complete*'):format(skillName, skillData.name, skillData.skillExp, skillData.progress),
            progress = skillData.progress,
            colorScheme = 'blue'
        }


        table.insert(menuOptions, option)

        skillCount = skillCount + 1
    end


    if skillCount == 0 then 
        table.insert(menuOptions, {
            title = locale("skills_no_skills")
        })
    end


    lib.registerContext({
        id = 'skills_menu',
        title = locale("skills_menu_title"),
        options = menuOptions
    })

    lib.showContext('skills_menu')
 
end

if config.skillsCommand then 
    RegisterCommand(locale('skills_command'), openSkillsMenu)
end

if config.skillsKeybind then 
    lib.addKeybind({
        name = 'respects',
        description = 'Open Skills Menu',
        defaultKey = 'F5',
        onPressed = function(self)
            openSkillsMenu()
        end
    })
end

