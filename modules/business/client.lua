lib.locale()
local config = lib.require('config')
local createdBill = {}

---@param menuId string
---@param type string
---@param registerId string
---@param register table
local function createBillInput(menuId, type, registerId, register)

    if type == 'amount' then 
        local input = lib.inputDialog(locale("bill_create_input_amount"), {
            { type = 'number', placeholder = 50, min = 1, required = true },
        })
        if not input then stevo_lib.Notify(locale("cancelled_input"), 'info', 3000) lib.showContext(menuId) return end

        createdBill.amount = input[1]
        stevo_lib.Notify((locale("bill_create_amount_set")):format(input[1]), 'info', 3000)

        createBillMenu(registerId, register)
    end

    if type == 'item' then 
        local input = lib.inputDialog(locale("bill_create_input_item"), {
            { type = 'input', placeholder = 'Burger, Drink', required = true },
        })
        if not input then stevo_lib.Notify(locale("cancelled_input"), 'info', 3000) lib.showContext(menuId) return end

        createdBill.item = input[1]
        stevo_lib.Notify((locale("bill_create_item_set")):format(input[1]), 'info', 3000)

        createBillMenu(registerId, register)
    end  
end

---@param registerId string
---@param register table
function createBillMenu(registerId, register)

    local billAmount = createdBill.amount and createdBill.amount
    local billItem = createdBill.item and createdBill.item or locale("bill_not_set")

    local canCreate = createdBill.item and createdBill.amount

    local options = {
        {
            title = createdBill.amount and (locale("bill_amount")):format(billAmount) or locale("bill_amount_empty"),
            icon = 'money-bill',
            arrow = true,
            iconColor = createdBill.amount and "#228be6" or "#e03131",
            onSelect = function()
                createBillInput(registerId..'-billing', 'amount', registerId, register)
            end
        },
        {
            title = (locale("bill_item")):format(billItem),
            icon = 'receipt',
            arrow = true,
            iconColor = createdBill.item and "#228be6" or "#e03131",
            onSelect = function()
                createBillInput(registerId..'-billing', 'item', registerId, register)
            end
        },
        {
            title = locale("bill_create"),
            icon = canCreate and 'plus' or 'x',
            iconColor = canCreate and "#228be6" or "#e03131",
            disabled = not canCreate,
            arrow = true,
            onSelect = function()
                local createBill = lib.callback.await('stevo_lib:CreateRegisterBill', false, registerId, createdBill)
                
                if createBill then 
                    stevo_lib.Notify((locale("created_bill")):format(createdBill.amount, createdBill.item), 'success', 3000)
                    createdBill = {}
                end
            end
        },
    }

    lib.registerContext({
        id = registerId..'-billing',
        title = register.name,
        menu = registerId, 
        options = options
    })
     
    lib.showContext(registerId..'-billing')
end

---@param registerId string
---@param register table
local function useRegister(registerId, register)
    createdBill = {
        amount = false,
        item = false,
    }
    createBillMenu(registerId, register)
end 

---@param registerId string
---@param register table
local function manageRegister(registerId, register)
    local registerData = lib.callback.await('stevo_lib:GetRegisterData', false, registerId)

    local options = {
        {
            title = registerData.ready and locale("register_in_use") or locale("register_availible"),
            icon = 'cash-register',
            iconColor = registerData.ready and "#f03e3e" or "#1c7ed6"
        },
        {
            title = locale("use_register"),
            icon = 'receipt',
            iconColor = registerData.ready and "#f03e3e" or "#1c7ed6",
            disabled = registerData.ready,
            onSelect = function()
                useRegister(registerId, register)
            end,
        },
        {
            title = locale("clear_register"),
            icon = 'trash',
            iconColor = registerData.ready and "#1c7ed6" or "#f03e3e",
            disabled = not registerData.ready,
            onSelect = function()
                local clearRegister = lib.callback.await('stevo_lib:clearRegister', false, registerId)

                if clearRegister then 
                    stevo_lib.Notify((locale("cleared_register")):format(register.name), 'success', 3000)
                end
            end,
        }
    }

    lib.registerContext({
        id = registerId,
        title = register.name,
        options = options
    })

    lib.showContext(registerId)
end

---@param registerId string
---@param register table
local function openRegister(registerId, register)
    local registerData = lib.callback.await('stevo_lib:GetRegisterData', false, registerId)

    if not registerData.ready then return stevo_lib.Notify(locale("register_not_open"), 'error', 3000) end

    local registerData = lib.callback.await('stevo_lib:GetRegisterData', false, registerId)

    local options = {
        {
            title = ('Items: %s'):format(registerData.billItem),
            icon = 'receipt',
            iconColor = "#1c7ed6"
        },
        {
            title = ('Total: $%s'):format(registerData.billAmount),
            icon = 'money-bill',
            iconColor = "#1c7ed6",
        },
        {
            title = locale("pay_bill"),
            icon = 'play',
            iconColor = "#1c7ed6",
            onSelect = function()
                lib.showContext(registerId..'-paySelect')
            end,
        }
    }

    lib.registerContext({
        id = registerId,
        title = register.name,
        options = options
    })

    lib.showContext(registerId)

    local options = {
        {
            title = ('Pay %s with cash'):format(registerData.billItem),
            arrow = true,
            icon = 'money-bill',
            iconColor = "#1c7ed6",
            onSelect = function()
                local paidBill = lib.callback.await('stevo_lib:payBill', false, true, registerId)

                if paidBill then 
                    stevo_lib.Notify((locale("paid_bill")):format(paidBill), 'success', 3000)
                end
            end,
        },
        {
            title = ('Pay $%s with card'):format(registerData.billAmount),
            arrow = true,
            icon = 'credit-card',
            iconColor = "#1c7ed6",
            onSelect = function()
                local paidBill = lib.callback.await('stevo_lib:payBill', false, false, registerId)

                if paidBill then 
                    stevo_lib.Notify((locale("paid_bill")):format(paidBill), 'success', 3000)
                end
            end,
        },
    }

    lib.registerContext({
        id = registerId..'-paySelect',
        title = locale("select_pay_method"),
        options = options
    })
end

AddEventHandler('stevo_lib:playerLoaded', function()
    local registers = lib.callback.await('stevo_lib:GetRegisters', false)

    if not registers then return end

    for i, register in pairs(registers) do 
        local options = {
            options = {
                {
                    name = i,
                    type = "client",
                    icon =  'fas fa-cash-register',
                    action = function()
                        openRegister(i, register)
                    end,
                    label = locale('register_label'),
                },
                {
                    name = i,
                    type = "client",
                    action = function()
                        manageRegister(i, register)
                    end,
                    icon =  'fas fa-cash-register',
                    job = {register.business},
                    label = locale('staff_register_label'),
                }
            },
            distance = 3,
            rotation = 45
        }
        
        stevo_lib.target.AddBoxZone(i, register.coords, register.radius, options)
    
    end
end)

RegisterCommand('simulateLoad', function()
    local registers = lib.callback.await('stevo_lib:GetRegisters', false)

    if not registers then return end

    for i, register in pairs(registers) do 
        local options = {
            options = {
                {
                    name = i,
                    type = "client",
                    icon =  'fas fa-cash-register',
                    action = function()
                        openRegister(i, register)
                    end,
                    label = locale('register_label'),
                },
                {
                    name = i,
                    type = "client",
                    action = function()
                        manageRegister(i, register)
                    end,
                    icon =  'fas fa-cash-register',
                    job = {register.business},
                    label = locale('staff_register_label'),
                }
            },
            distance = 3,
            rotation = 45
        }
        
        stevo_lib.target.AddBoxZone(i, register.coords, register.radius, options)
    
    end
end)

