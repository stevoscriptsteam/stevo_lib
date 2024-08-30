local config = lib.require('config')
Businesses = {}
Registers = {}
lib.locale()

local createBusinessesTable = 'CREATE TABLE IF NOT EXISTS `stevo_businesses` (`businessId` VARCHAR(15) NOT NULL, `businessFunds` BIGINT NOT NULL, PRIMARY KEY (`businessId`))'
local createEmployeesTable = 'CREATE TABLE IF NOT EXISTS `stevo_businesses_employees` (`businessId` VARCHAR(15) NOT NULL, `identifier` VARCHAR(50) NOT NULL, `name` VARCHAR(100) NOT NULL, `dateEmployed` DATE NOT NULL, PRIMARY KEY (`identifier`))'

local function logBusinessAction(event, message)
    if config.businesses.logs == 'discord' then 
        local logWebhook = GetConvar("stevo_lib_businessLogs", "rabbit")
        if not logWebhook or logWebhook == "rabbit" then 
            return lib.print.error("log config set to discord but no webhook has been set, please read the documentation")
        end

        local embed = {
            {
                ["title"] = event,
                ["description"] = message,
                ["type"] = "rich",
                ["color"] = 0x156cbd,
                ["footer"] = {
                    ["text"] = 'Stevo Scripts - https://discord.gg/stevoscripts',
                },
            }
        }

        PerformHttpRequest(logWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Stevo Businesses", embeds = embed}), { ['Content-Type'] = 'application/json' })
    else 
        lib.logger('stevo_lib', event, message)
    end
end

---@param businessId string
function stevo_lib.GetBusinessFunds(businessId)
    if not businessId then 
        return lib.print.error('Tried to get Business Funds but no business id was received')
    end

    return Businesses[businessId].funds
end

---@param businessId string
function stevo_lib.GetBusinessEmployees(businessId)
    if not businessId then 
        return lib.print.error('Tried to get Business Employees but no business id was received')
    end

    local employees = Businesses[businessId].employees

    if next(employees) == nil then
        return false 
    else
        return employees
    end
end

---@param source number
---@param businessId string
---@param player number
---@return number
function stevo_lib.EmployPlayer(source, businessId, player)
    if not businessId then 
        return lib.print.error('Tried to Employ Player but no business id was received')
    end

    local business = Businesses[businessId]
    local employees = business.employees

    local playerIdentifier = stevo_lib.GetIdentifier(player)
    local playerName = stevo_lib.GetName(player)
    local playerDateEmployed = os.date('%Y-%m-%d %H:%M:%S', os.time())
    local employee = {
        name = playerName,
        dateEmplyed = playerDateEmployed
    }

    employees[playerIdentifier] = employee

    local id = exports.oxmysql.insert_async('INSERT INTO `stevo_businesses_employees` (businessId, identifier, name, dateEmployed) VALUES (?, ?, ?, ?)', {
        businessId, playerIdentifier, playerName, playerDateEmployed
    })

    if config.businesses.logs then 
        local employerName = stevo_lib.GetName(source)
        local log = ("New Employee: %s was hired at %s by %s"):format(employerName, employee.name, business.name)
        logBusinessAction('EmployPlayer', log)
    end

    return id
end

---@param source number
---@param businessId string
---@param player number
---@return number
function stevo_lib.FirePlayer(source, businessId, player)
    if not businessId then 
        return lib.print.error('Tried to Fire Player but no business id was received')
    end

    local business = Businesses[businessId]
    local employees = business.employees

    local playerIdentifier = stevo_lib.GetIdentifier(player)
    employees[playerIdentifier] = nil

    exports.oxmysql.update('DELETE FROM `stevo_businesses_employees` WHERE `identifier` = ? LIMIT 1', {
        playerIdentifier
    }, function(affectedRows)
        -- dont care how many rows were effected tbh
    end)

    if config.businesses.logs then 
        local employerName = stevo_lib.GetName(source)
        local playerName = stevo_lib.GetName(player)
        local log = ("Fired Employee: %s was fired at %s by %s"):format(employerName, playerName, business.name)
        logBusinessAction('Fire Player', log)
    end

    return employees
end

---@param businessId string
---@param amount number
---@return number
function stevo_lib.AddBusinessFunds(businessId, amount)
    if not businessId then 
        return lib.print.error('Tried to add Business Funds but no business id was received')
    end
    local newFunds = (Businesses[businessId].funds + amount)

    Businesses[businessId].funds = newFunds

    MySQl:update_async('UPDATE stevo_businesses SET funds = ? WHERE businessId = ?', {newFunds})
     
    if config.businesses.logs then 
        local businessName = Businesses[businessId].name
        local log = ("New Transaction: %s was added to %s business funds"):format(amount, businessName)
        logBusinessAction('AddBusinessFunds', log)
    end

    return newFunds
end

---@param businessId string
---@param amount number
---@return number
function stevo_lib.RemoveBusinessFunds(businessId, amount)
    if not businessId then 
        return lib.print.error('Tried to remove Business Funds but no business id was received')
    end
    local newFunds = (Businesses[businessId].funds - amount)

    Businesses[businessId].funds = newFunds

    MySQl:update_async('UPDATE stevo_businesses SET funds = ? WHERE businessId = ?', {newFunds})

    if config.businesses.logs then 
        local businessName = Businesses[businessId].name
        local log = ("New Transaction: %s was removed from %s business funds"):format(amount, businessName)
        logBusinessAction('AddBusinessFunds', log)
    end
     
    return newFunds
end

---@param data table
---@return function
function stevo_lib.RegisterBusiness(data)
    if not data then 
        return lib.print.error('Tried to register Business but no data was received!')
    end

    local businessId = data.id
    local businessName = data.name
    local businessFunds = 0
    local businessEmployees = {}

    local businessTable = MySQL.single.await('SELECT * FROM `stevo_businesses` WHERE `businessId` = ? LIMIT 1', {
        businessId
    })
    
    if not businessTable then 
        exports.oxmysql.insert.await('INSERT INTO `stevo_businesses` (businessId, businessFunds) VALUES (?, ?)', {
           businessId, 0
        }) 
    end
    

    if businessTable then 
        businessFunds = businessTable.businessFunds


        local response = MySQL.query.await('SELECT * FROM `stevo_businesses_employees` WHERE `businessId` = ?', {
            businessId
        })
        
        if response then
            for i = 1, #response do
                local row = response[i]

                businessEmployees[row.identifier] = {
                    name = row.name,
                    dateEmployed = row.dateEmployed
                }
            end
        end
    end

    Businesses[businessId] = {
        name = businessName,
        funds = businessFunds,
        employees = businessEmployees
    }

    if config.businesses.logs then 
        local log = ('Registered Business\nName: %s\nFunds: %s'):format(businessName, businessFunds)
        logBusinessAction('RegisterBusiness', log)
    end

    return lib.print.info((locale("registered_business")):format(businessId, businessName, businessFunds))
end

---@param registerId string 
---@param registerData table
---@param businessId string 
---@return function
function stevo_lib.CreateRegister(registerId, registerData, businessId, commissionAmount)
    if not registerId or not registerData or not businessId then 
        return lib.print.error('Tried to CreateRegister but didnt receive all required values')
    end
    local register = {
        name = registerData.name,
        coords = registerData.coords,
        radius = registerData.radius,
        business = businessId,
        ready = false,
        billAmount = false,
        billitem = false,
        commissionAmount = commissionAmount
    }
    Registers[registerId] = register

    
    return lib.print.info((locale("created_register")):format(registerData.name, businessId))
end

---@param source number 
---@return table
lib.callback.register('stevo_lib:GetRegisters', function(source)
    
    if next(Registers) == nil then
        return false 
    else
        return Registers
    end
end)

---@param source number 
---@param registerId string
---@return boolean
lib.callback.register('stevo_lib:GetRegisterData', function(source, registerId)
    return Registers[registerId]
end)

---@param source number 
---@param registerId string
---@param bill table
---@return boolean
lib.callback.register('stevo_lib:CreateRegisterBill', function(source, registerId, bill)
    local register = Registers[registerId]

    register.ready = true 
    register.billAmount = bill.amount 
    register.billItem = bill.item

    return true
end)

---@param source number 
---@param registerId string
---@return boolean
lib.callback.register('stevo_lib:clearRegister', function(source, registerId)
    local register = Registers[registerId]

    register.ready = false
    register.billAmount = false
    register.billItem = false

    return true
end)

---@param source number 
---@param registerId string
---@param withCash boolean
---@return boolean
lib.callback.register('stevo_lib:payBill', function(source, withCash, registerId)
    local register = Registers[registerId]
    local billAmount =  register.billAmount
    local billItem = register.billItem
    local commissionAmount = register.commissionAmount



    return true
end)

CreateThread(function()
    local businessesTable, result = pcall(MySQL.scalar_async, 'SELECT 1 FROM stevo_businesses')

    if not businessesTable then
        exports.oxmysql.query(createBusinessesTable)
        lib.print.info(('[Stevo Scripts] %s'):format(locale("deployed_business_database")))
    end

    local employeesTable, result = pcall(MySQL.scalar_async, 'SELECT 1 FROM stevo_businesses_employees')

    if not employeesTable then
        exports.oxmysql.query(createEmployeesTable)
        lib.print.info(('[Stevo Scripts] %s'):format(locale("deployed_employee_database")))
    end
end)

