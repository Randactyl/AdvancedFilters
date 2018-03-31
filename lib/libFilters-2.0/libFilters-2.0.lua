local MAJOR, MINOR = "LibFilters-2.0", 3.5
local LibFilters, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibFilters then return end

--some constants for your filters
LF_INVENTORY             = 1
LF_BANK_WITHDRAW         = 2
LF_BANK_DEPOSIT          = 3
LF_GUILDBANK_WITHDRAW    = 4
LF_GUILDBANK_DEPOSIT     = 5
LF_VENDOR_BUY            = 6
LF_VENDOR_SELL           = 7
LF_VENDOR_BUYBACK        = 8
LF_VENDOR_REPAIR         = 9
LF_GUILDSTORE_BROWSE     = 10
LF_GUILDSTORE_SELL       = 11
LF_MAIL_SEND             = 12
LF_TRADE                 = 13
LF_SMITHING_REFINE       = 14
LF_SMITHING_CREATION     = 15
LF_SMITHING_DECONSTRUCT  = 16
LF_SMITHING_IMPROVEMENT  = 17
LF_SMITHING_RESEARCH     = 18
LF_ALCHEMY_CREATION      = 19
LF_ENCHANTING_CREATION   = 20
LF_ENCHANTING_EXTRACTION = 21
LF_PROVISIONING_COOK     = 22
LF_PROVISIONING_BREW     = 23
LF_FENCE_SELL            = 24
LF_FENCE_LAUNDER         = 25
LF_CRAFTBAG              = 26
LF_QUICKSLOT             = 27
LF_RETRAIT               = 28
LF_HOUSE_BANK_WITHDRAW   = 29
LF_HOUSE_BANK_DEPOSIT    = 30

LibFilters.isInitialized = false
LibFilters.filters = {
    [LF_INVENTORY] = {},
    [LF_BANK_WITHDRAW] = {},
    [LF_BANK_DEPOSIT] = {},
    [LF_GUILDBANK_WITHDRAW] = {},
    [LF_GUILDBANK_DEPOSIT] = {},
    [LF_VENDOR_BUY] = {},
    [LF_VENDOR_SELL] = {},
    [LF_VENDOR_BUYBACK] = {},
    [LF_VENDOR_REPAIR] = {},
    [LF_GUILDSTORE_BROWSE] = {},
    [LF_GUILDSTORE_SELL] = {},
    [LF_MAIL_SEND] = {},
    [LF_TRADE] = {},
    [LF_SMITHING_REFINE] = {},
    [LF_SMITHING_CREATION] = {},
    [LF_SMITHING_DECONSTRUCT] = {},
    [LF_SMITHING_IMPROVEMENT] = {},
    [LF_SMITHING_RESEARCH] = {},
    [LF_ALCHEMY_CREATION] = {},
    [LF_ENCHANTING_CREATION] = {},
    [LF_ENCHANTING_EXTRACTION] = {},
    [LF_PROVISIONING_COOK] = {},
    [LF_PROVISIONING_BREW] = {},
    [LF_FENCE_SELL] = {},
    [LF_FENCE_LAUNDER] = {},
    [LF_CRAFTBAG] = {},
    [LF_QUICKSLOT] = {},
    [LF_RETRAIT] = {},
    [LF_HOUSE_BANK_WITHDRAW] = {},
    [LF_HOUSE_BANK_DEPOSIT] = {},
}
local filters = LibFilters.filters

local filterTypeToUpdaterName = {
    [LF_INVENTORY] = "INVENTORY",
    [LF_BANK_WITHDRAW] = "BANK_WITHDRAW",
    [LF_BANK_DEPOSIT] = "INVENTORY",
    [LF_GUILDBANK_WITHDRAW] = "GUILDBANK_WITHDRAW",
    [LF_GUILDBANK_DEPOSIT] = "INVENTORY",
    [LF_VENDOR_BUY] = "VENDOR_BUY",
    [LF_VENDOR_SELL] = "INVENTORY",
    [LF_VENDOR_BUYBACK] = "VENDOR_BUYBACK",
    [LF_VENDOR_REPAIR] = "VENDOR_REPAIR",
    [LF_GUILDSTORE_BROWSE] = "GUILDSTORE_BROWSE",
    [LF_GUILDSTORE_SELL] = "INVENTORY",
    [LF_MAIL_SEND] = "INVENTORY",
    [LF_TRADE] = "INVENTORY",
    [LF_SMITHING_REFINE] = "SMITHING_REFINE",
    [LF_SMITHING_CREATION] = "SMITHING_CREATION",
    [LF_SMITHING_DECONSTRUCT] = "SMITHING_DECONSTRUCT",
    [LF_SMITHING_IMPROVEMENT] = "SMITHING_IMPROVEMENT",
    [LF_SMITHING_RESEARCH] = "SMITHING_RESEARCH",
    [LF_ALCHEMY_CREATION] = "ALCHEMY_CREATION",
    [LF_ENCHANTING_CREATION] = "ENCHANTING",
    [LF_ENCHANTING_EXTRACTION] = "ENCHANTING",
    [LF_PROVISIONING_COOK] = "PROVISIONING_COOK",
    [LF_PROVISIONING_BREW] = "PROVISIONING_BREW",
    [LF_FENCE_SELL] = "INVENTORY",
    [LF_FENCE_LAUNDER] = "INVENTORY",
    [LF_CRAFTBAG] = "CRAFTBAG",
    [LF_QUICKSLOT] = "QUICKSLOT",
    [LF_RETRAIT] = "RETRAIT",
    [LF_HOUSE_BANK_WITHDRAW] = "HOUSE_BANK_WITHDRAW",
    [LF_HOUSE_BANK_DEPOSIT] = "INVENTORY",
}

--if the mouse is enabled, cycle its state to refresh the integrity of the control beneath it
local function SafeUpdateList(object, ...)
    local isMouseVisible = SCENE_MANAGER:IsInUIMode()

    if isMouseVisible then HideMouse() end

    object:UpdateList(...)

    if isMouseVisible then ShowMouse() end
end

local inventoryUpdaters = {
    INVENTORY = function()
        SafeUpdateList(PLAYER_INVENTORY, INVENTORY_BACKPACK)
    end,
    BANK_WITHDRAW = function()
        SafeUpdateList(PLAYER_INVENTORY, INVENTORY_BANK)
    end,
    GUILDBANK_WITHDRAW = function()
        SafeUpdateList(PLAYER_INVENTORY, INVENTORY_GUILD_BANK)
    end,
    VENDOR_BUY = function()
        if BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.state ~= "shown" then
            STORE_WINDOW:GetStoreItems()
            SafeUpdateList(STORE_WINDOW)
        end
    end,
    VENDOR_BUYBACK = function()
        SafeUpdateList(BUY_BACK_WINDOW)
    end,
    VENDOR_REPAIR = function()
        SafeUpdateList(REPAIR_WINDOW)
    end,
    GUILDSTORE_BROWSE = function()
    end,
    SMITHING_REFINE = function()
        SMITHING.refinementPanel.inventory:HandleDirtyEvent()
    end,
    SMITHING_CREATION = function()
    end,
    SMITHING_DECONSTRUCT = function()
        SMITHING.deconstructionPanel.inventory:HandleDirtyEvent()
    end,
    SMITHING_IMPROVEMENT = function()
        SMITHING.improvementPanel.inventory:HandleDirtyEvent()
    end,
    SMITHING_RESEARCH = function()
        SMITHING.researchPanel:Refresh()
    end,
    ALCHEMY_CREATION = function()
        ALCHEMY.inventory:HandleDirtyEvent()
    end,
    ENCHANTING = function()
        ENCHANTING.inventory:HandleDirtyEvent()
    end,
    PROVISIONING_COOK = function()
    end,
    PROVISIONING_BREW = function()
    end,
    CRAFTBAG = function()
        SafeUpdateList(PLAYER_INVENTORY, INVENTORY_CRAFT_BAG)
    end,
    QUICKSLOT = function()
        SafeUpdateList(QUICKSLOT_WINDOW)
    end,
    RETRAIT = function()
        ZO_RETRAIT_STATION_KEYBOARD:HandleDirtyEvent()
    end,
    HOUSE_BANK_WITHDRAW = function()
        SafeUpdateList(PLAYER_INVENTORY, INVENTORY_HOUSE_BANK )
    end,
}

local function df(...)
    d(string.format(...))
end

local function runFilters(filterType, ...)
    for tag, filter in pairs(filters[filterType]) do
        if not filter(...) then
            return false
        end
    end

    return true
end

function LibFilters:HookAdditionalFilter(filterType, inventory)
    local layoutData = inventory.layoutData or inventory
    local originalFilter = layoutData.additionalFilter

    layoutData.LibFilters2_filterType = filterType

    if type(originalFilter) == "function" then
        layoutData.additionalFilter = function(...)
            return originalFilter(...) and runFilters(filterType, ...)
        end
    else
        layoutData.additionalFilter = function(...)
            return runFilters(filterType, ...)
        end
    end
end

local function HookAdditionalFilters()
    LibFilters:HookAdditionalFilter(LF_INVENTORY, PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK])
    LibFilters:HookAdditionalFilter(LF_INVENTORY, BACKPACK_MENU_BAR_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_BANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_BANK])
    LibFilters:HookAdditionalFilter(LF_BANK_DEPOSIT, BACKPACK_BANK_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_GUILDBANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_GUILD_BANK])
    LibFilters:HookAdditionalFilter(LF_GUILDBANK_DEPOSIT, BACKPACK_GUILD_BANK_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_VENDOR_BUY, STORE_WINDOW)
    LibFilters:HookAdditionalFilter(LF_VENDOR_SELL, BACKPACK_STORE_LAYOUT_FRAGMENT)
    LibFilters:HookAdditionalFilter(LF_VENDOR_BUYBACK, BUY_BACK_WINDOW)
    LibFilters:HookAdditionalFilter(LF_VENDOR_REPAIR, REPAIR_WINDOW)

    --LibFilters:HookAdditionalFilter(LF_GUILDSTORE_BROWSE, )
    LibFilters:HookAdditionalFilter(LF_GUILDSTORE_SELL, BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_MAIL_SEND, BACKPACK_MAIL_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_TRADE, BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_SMITHING_REFINE, SMITHING.refinementPanel.inventory)
    --LibFilters:HookAdditionalFilter(LF_SMITHING_CREATION, )
    LibFilters:HookAdditionalFilter(LF_SMITHING_DECONSTRUCT, SMITHING.deconstructionPanel.inventory)
    LibFilters:HookAdditionalFilter(LF_SMITHING_IMPROVEMENT, SMITHING.improvementPanel.inventory)
    LibFilters:HookAdditionalFilter(LF_SMITHING_RESEARCH, SMITHING.researchPanel)

    LibFilters:HookAdditionalFilter(LF_ALCHEMY_CREATION, ALCHEMY.inventory)

    LibFilters:HookAdditionalFilter(LF_ENCHANTING_CREATION, ENCHANTING.inventory)
    LibFilters:HookAdditionalFilter(LF_ENCHANTING_EXTRACTION, ENCHANTING.inventory)

    --LibFilters:HookAdditionalFilter(LF_PROVISIONING_COOK, )
    --LibFilters:HookAdditionalFilter(LF_PROVISIONING_BREW, )

    LibFilters:HookAdditionalFilter(LF_FENCE_SELL, BACKPACK_FENCE_LAYOUT_FRAGMENT)
    LibFilters:HookAdditionalFilter(LF_FENCE_LAUNDER, BACKPACK_LAUNDER_LAYOUT_FRAGMENT)

    LibFilters:HookAdditionalFilter(LF_CRAFTBAG, PLAYER_INVENTORY.inventories[INVENTORY_CRAFT_BAG])

    LibFilters:HookAdditionalFilter(LF_QUICKSLOT, QUICKSLOT_WINDOW)

    LibFilters:HookAdditionalFilter(LF_RETRAIT, ZO_RETRAIT_STATION_KEYBOARD)

    LibFilters:HookAdditionalFilter(LF_HOUSE_BANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_HOUSE_BANK])
    LibFilters:HookAdditionalFilter(LF_HOUSE_BANK_DEPOSIT, BACKPACK_HOUSE_BANK_LAYOUT_FRAGMENT)
end
LibFilters.helpers = {}
local helpers = LibFilters.helpers
local function InstallHelpers()
    for _, package in pairs(helpers) do
        local funcName = package.helper.funcName
        local func = package.helper.func

        for _, location in pairs(package.locations) do
            location[funcName] = func
        end
    end
end
function LibFilters:InitializeLibFilters()
    if self.isInitialized then return end
    self.isInitialized = true

    InstallHelpers()
    HookAdditionalFilters()
end

function LibFilters:GetCurrentFilterTypeForInventory(inventoryType)
    local inventory = PLAYER_INVENTORY.inventories[inventoryType]
    local layoutData = PLAYER_INVENTORY.appliedLayout

    if inventoryType == INVENTORY_BACKPACK then
        if layoutData and layoutData.LibFilters2_filterType then
            return layoutData.LibFilters2_filterType
        end
    end

    return inventory.LibFilters2_filterType
end

function LibFilters:GetFilterCallback(filterTag, filterType)
    if not self:IsFilterRegistered(filterTag, filterType) then return end

    return filters[filterType][filterTag]
end

function LibFilters:IsFilterRegistered(filterTag, filterType)
    if filterType == nil then
        --check whether there's any filter with this tag
        for filterType, callbacks in pairs(filters) do
            if callbacks[filterTag] ~= nil then
                return true
            end
        end

        return false
    else
        --check only the specified filter type
        local callbacks = filters[filterType]

        return callbacks[filterTag] ~= nil
    end
end

function LibFilters:RegisterFilter(filterTag, filterType, filterCallback)
    local callbacks = filters[filterType]

    if not filterTag or not callbacks or type(filterCallback) ~= "function" then
        df("LibFilters: invalid arguments to RegisterFilter (%q, %s, %s)",
            tostring(filterTag), tostring(filterType), tostring(filterCallback))
        return
    end

    if callbacks[filterTag] ~= nil then
        df("LibFilters: %q filterType %s is already in use",
            tostring(filterTag), tostring(filterType))
        return
    end

    callbacks[filterTag] = filterCallback
end

function LibFilters:RequestUpdate(filterType)
    local updaterName = filterTypeToUpdaterName[filterType]
    local callbackName = "LibFilters_updateInventory_" .. updaterName
    local function Update()
        EVENT_MANAGER:UnregisterForUpdate(callbackName)
        inventoryUpdaters[updaterName]()
    end

    --cancel previously scheduled update if any
    EVENT_MANAGER:UnregisterForUpdate(callbackName)
    --register a new one
    EVENT_MANAGER:RegisterForUpdate(callbackName, 10, Update)
end

function LibFilters:UnregisterFilter(filterTag, filterType)
    if filterType == nil then
        --unregister all filters with this tag
        for filterType, callbacks in pairs(filters) do
            if callbacks[filterTag] ~= nil then
                callbacks[filterTag] = nil
            end
        end
    else
        --unregister only the specified filter type
        local callbacks = filters[filterType]

        if callbacks[filterTag] ~= nil then
            callbacks[filterTag] = nil
        end
    end
end
