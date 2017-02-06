local AF = AdvancedFilters
AF.util = {}
AF.util.LibFilters = LibStub("LibFilters-2.0")
AF.util.LibMotifCategories = LibStub("LibMotifCategories-1.0")

function AF.util.ApplyFilter(button, filterTag, requestUpdate)
    local LibFilters = AF.util.LibFilters
    local callback = button.filterCallback
    local filterType

    if AF.currentInventoryType == 6 then
        filterType = LF_VENDOR_BUY
    else
        filterType = LibFilters:GetCurrentFilterTypeForInventory(AF.currentInventoryType)
    end

    --d("Apply " .. button.name .. " from " .. filterTag .. " for filterType " .. filterType .. " and inventoryType " .. AF.currentInventoryType)

    --if something isn't right, abort
    if callback == nil then
        d("callback was nil for " .. filterTag)
        return
    end
    if filterType == nil then
        d("filterType was nil for " .. filterTag)
        return
    end

    --first, clear current filters without an update
    LibFilters:UnregisterFilter(filterTag)
    --then register new one and hand off update parameter
    LibFilters:RegisterFilter(filterTag, filterType, callback)
    if requestUpdate == true then LibFilters:RequestUpdate(filterType) end
end

function AF.util.RemoveAllFilters()
    local LibFilters = AF.util.LibFilters
    local filterType

    if AF.currentInventoryType == 6 then
        filterType = LF_VENDOR_BUY
    else
        filterType = LibFilters:GetCurrentFilterTypeForInventory(AF.currentInventoryType)
    end

    LibFilters:UnregisterFilter("AF_ButtonFilter")
    LibFilters:UnregisterFilter("AF_DropdownFilter")

    if filterType ~= nil then LibFilters:RequestUpdate(filterType) end
end

function AF.util.RefreshSubfilterBar(subfilterBar)
    local inventoryType = subfilterBar.inventoryType
    local inventory, inventorySlots

    if inventoryType == 6 then
        return
        --[[inventory = STORE_WINDOW
        inventorySlots = inventory.items]]
    else
        inventory = PLAYER_INVENTORY.inventories[inventoryType]
        inventorySlots = inventory.slots
    end

    for _, button in pairs(subfilterBar.subfilterButtons) do
        if button.name ~= "All" then
            --disable button
            if button.clickable then
                button.texture:SetColor(.3, .3, .3, .9)
                button:SetEnabled(false)
                button.clickable = false
            end

            --check button for availability
            for _, itemData in pairs(inventorySlots) do
                local passesCallback = button.filterCallback(itemData)
                local passesFilter = itemData.filterData[1] == inventory.currentFilter
                or  itemData.filterData[2] == inventory.currentFilter

                if passesCallback and passesFilter then
                    button.texture:SetColor(1, 1, 1, 1)
                    button:SetEnabled(true)
                    button.clickable = true
                    break
                end
            end
        end
    end
end

function AF.util.BuildDropdownCallbacks(groupName, subfilterName)
    if subfilterName == "Heavy" or subfilterName == "Medium"
    or subfilterName == "LightArmor" or subfilterName == "Clothing" then
        subfilterName = "Body"
    end

    local callbackTable = {}
    local keys = {
        All = {},
        Weapons = {
            "OneHand", "TwoHand", "Bow", "DestructionStaff", "HealStaff",
        },
        Armor = {
            "Body", "Shield", "Jewelry", "Vanity",
        },
        Consumables = {
            "Crown", "Food", "Drink", "Recipe", "Potion", "Poison", "Motif", "Writ", "Container", "Repair", "Trophy",
        },
        Crafting = {
            "Blacksmithing", "Clothier", "Woodworking", "Alchemy", "Enchanting", "Provisioning", "Style", "WeaponTrait", "ArmorTrait",
        },
        Furnishings = {
            "CraftingStation", "Light", "Ornamental", "Seating", "TargetDummy",
        },
        Miscellaneous = {
            "Glyphs", "SoulGem", "Siege", "Bait", "Tool", "Trophy", "Fence", "Trash",
        },
        Junk = {
            "Weapon", "Apparel", "Consumable", "Materials", "Miscellaneous"
        },
        Blacksmithing = {
            "RawMaterial", "RefinedMaterial", "Temper",
        },
        Clothing = {
            "RawMaterial", "RefinedMaterial", "Resin",
        },
        Woodworking = {
            "RawMaterial", "RefinedMaterial", "Tannin",
        },
        Alchemy = {
            "Reagent", "Water", "Oil",
        },
        Enchanting = {
            "Aspect", "Essence", "Potency",
        },
        Provisioning = {
            "FoodIngredient", "DrinkIngredient", "OldIngredient", "RareIngredient", "Bait",
        },
        Style = {
            "NormalStyle", "RareStyle", "AllianceStyle", "ExoticStyle", "CrownStyle",
        },
        Traits = {
            "ArmorTrait", "WeaponTrait",
        },
    }

    local function insertAddon(addonTable)
        --generate information if necessary
        if addonTable.generator then
            local strings

            addonTable.callbackTable, strings = addonTable.generator()

            for key, string in pairs(strings) do
                AF.strings[key] = string
            end
        end

        --check to see if addon is set up for a submenu
        if addonTable.submenuName then
            --insert whole package
            table.insert(callbackTable, addonTable)
        else
            --insert all callbackTable entries
            local currentAddonTable = addonTable.callbackTable

            for _, callbackEntry in ipairs(currentAddonTable) do
                table.insert(callbackTable, callbackEntry)
            end
        end
    end

    -- insert global "All" filters
    for _, callbackEntry in ipairs(AF.subfilterCallbacks.All.dropdownCallbacks) do
        table.insert(callbackTable, callbackEntry)
    end

    --insert global addon filters
    for _, addonTable in ipairs(AF.subfilterCallbacks.All.addonDropdownCallbacks) do
        insertAddon(addonTable)
    end

    --insert filters that apply to the whole group
    if groupName ~= "All" then
        for _, callbackEntry in ipairs(AF.subfilterCallbacks[groupName].All.dropdownCallbacks) do
            table.insert(callbackTable, callbackEntry)
        end

        if subfilterName == "All" then
            --insert all default filters for each subfilter
            for _, subfilterName in ipairs(keys[groupName]) do
                local currentSubfilterTable = AF.subfilterCallbacks[groupName][subfilterName]

                for _, callbackEntry in ipairs(currentSubfilterTable.dropdownCallbacks) do
                    table.insert(callbackTable, callbackEntry)
                end
            end

            --insert all filters provided by addons
            for _, addonTable in ipairs(AF.subfilterCallbacks[groupName].addonDropdownCallbacks) do
                insertAddon(addonTable)
            end
        else
            --insert filters for provided subfilter
            local currentSubfilterTable = AF.subfilterCallbacks[groupName][subfilterName]
            for _, callbackEntry in ipairs(currentSubfilterTable.dropdownCallbacks) do
                table.insert(callbackTable, callbackEntry)
            end

            --insert filters provided by addons for this subfilter
            for _, addonTable in ipairs(AF.subfilterCallbacks[groupName].addonDropdownCallbacks) do
                --scan addon to see if it applies to given subfilter
                for _, subfilter in ipairs(addonTable.subfilters) do
                    if subfilter == subfilterName or subfilter == "All" then
                        --add addon filters
                        insertAddon(addonTable)
                    end
                end
            end
        end
    end

    return callbackTable
end

function AF.util.GetLanguage()
    local lang = GetCVar("language.2")
    local supported = {
        de = 1,
        en = 2,
        es = 3,
        fr = 4,
        ru = 5,
        jp = 6,
    }

    --check for supported languages
    if(supported[lang] ~= nil) then return lang end

    --return english if not supported
    return "en"
end

--thanks ckaotik
function AF.util.Localize(text)
    if type(text) == 'number' then
        -- get the string from this constant
        text = GetString(text)
    end
    -- clean up suffixes such as ^F or ^S
    return zo_strformat(SI_TOOLTIP_ITEM_NAME, text) or " "
end

function AF.util.ThrottledUpdate(callbackName, timer, callback, ...)
    local args = {...}
    local function Update()
        EVENT_MANAGER:UnregisterForUpdate(callbackName)
        callback(unpack(args))
    end

    EVENT_MANAGER:UnregisterForUpdate(callbackName)
    EVENT_MANAGER:RegisterForUpdate(callbackName, timer, Update)
end

function AF.util.GetItemLink(slot)
    if slot.bagId then
        return GetItemLink(slot.bagId, slot.slotIndex)
    else
        return GetStoreItemLink(slot.slotIndex)
    end
end