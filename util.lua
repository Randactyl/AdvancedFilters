if AdvancedFilters == nil then AdvancedFilters = {} end
local AF = AdvancedFilters
AF.util = {}
AF.util.libCIF = LibStub:GetLibrary("libCommonInventoryFilters", LibStub.SILENT)
AF.util.LibFilters = LibStub("LibFilters-2.0")
AF.util.LibMotifCategories = LibStub("LibMotifCategories-1.0")

function AF.util.GetCurrentFilterTypeForInventory(invType)
    if invType == nil then return end
    local filterType
    if invType == INVENTORY_TYPE_VENDOR_BUY then
        filterType = LF_VENDOR_BUY
    elseif AF.util.IsCraftingStationInventoryType(invType) then
        filterType = AF.currentInventoryType
    else
        filterType = AF.util.LibFilters:GetCurrentFilterTypeForInventory(invType)
    end
    return filterType
end

function AF.util.AbortSubfilterRefresh(inventoryType)
    if inventoryType == nil then return true end
    local doAbort = false
    if inventoryType == INVENTORY_TYPE_VENDOR_BUY or AF.util.IsCraftingStationInventoryType(inventoryType) then
        doAbort = true
    end
    return doAbort
end

function AF.util.ApplyFilter(button, filterTag, requestUpdate)
    local LibFilters = AF.util.LibFilters
    local callback = button.filterCallback
    local filterType = AF.util.GetCurrentFilterTypeForInventory(AF.currentInventoryType)

  --d("[AF]Apply " .. button.name .. " from " .. filterTag .. " for filterType " .. filterType .. " and inventoryType " .. AF.currentInventoryType)

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
    local filterType = AF.util.GetCurrentFilterTypeForInventory(AF.currentInventoryType)

    LibFilters:UnregisterFilter("AF_ButtonFilter")
    LibFilters:UnregisterFilter("AF_DropdownFilter")

    if filterType ~= nil then LibFilters:RequestUpdate(filterType) end
end

function AF.util.RefreshSubfilterBar(subfilterBar)
    local inventoryType = subfilterBar.inventoryType
    local inventory, inventorySlots

    if AF.util.AbortSubfilterRefresh(inventoryType) then
        return
    end
    inventory = PLAYER_INVENTORY.inventories[inventoryType]
    inventorySlots = inventory.slots

    for _, button in ipairs(subfilterBar.subfilterButtons) do
        if button.name ~= "All" then
            --disable button
            if button.clickable then
                button.texture:SetColor(.3, .3, .3, .9)
                button:SetEnabled(false)
                button.clickable = false
            end

            --check button for availability
            for _, bags in pairs(inventorySlots) do
                for _, itemData in pairs(bags) do
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
end

--Check if the current panel should show the dropdown "addon filters" for "all" too
function AF.util.checkIfPanelShouldShowAddonAllDropdownFilters(invType)
    --d("[AF]checkIfPanelShouldShowAddonAllDropdownFilters - invType: " .. tostring(invType))
    if invType == nil then return true end
    local inv2ShowAddonAllDropdownFilters = {
        [LF_ENCHANTING_CREATION]    = false,
        [LF_ENCHANTING_EXTRACTION]  = false,
        --[LF_SMITHING_REFINE]        = false,
        --[LF_SMITHING_CREATION]      = false,
    }
    local showAtInv = true
    if inv2ShowAddonAllDropdownFilters[invType] ~= nil then
        showAtInv = inv2ShowAddonAllDropdownFilters[invType]
    end
    return showAtInv
end

--Check if the craftbag is shown as the groupName at the craftbag is different than non-craftbag
--e.g. the groupName "Alchemy" is the normal groupName "Crafting" with subfilterName "Alchemy"
function AF.util.IsCraftBagShown()
    return not ZO_CraftBag:IsHidden()
end

function AF.util.BuildDropdownCallbacks(groupName, subfilterName)
    local subfilterNameOrig = subfilterName
    if subfilterName == "Heavy" or subfilterName == "Medium"
    or subfilterName == "LightArmor" or subfilterName == "Clothing" then
        subfilterName = "Body"
    end
--d("[AF]]BuildDropdownCallbacks - groupName: " .. tostring(groupName) .. ", subfilterName: " .. tostring(subfilterName))
    local callbackTable = {}
    local keys = {
        All = {},
        Weapons = {
            "OneHand", "TwoHand", "Bow", "DestructionStaff", "HealStaff",
        },
        Armor = {
            "Body", "Shield", "Vanity",
        },
        Consumables = {
            "Crown", "Food", "Drink", "Recipe", "Potion", "Poison", "Motif", "Writ", "Container", "Repair", "Trophy",
        },
        Crafting = {
            "Blacksmithing", "Clothier", "Woodworking", "Alchemy", "Enchanting", "Provisioning", "JewelryCrafting", "Style", "WeaponTrait", "ArmorTrait", "JewelryTrait",
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
        --[[
        --TODO: Currently disabled as rune filters at the enchanting creation panel on ITEMFILTERTYPE_ base are not possible at the moment
        Runes = {

        },
        ]]
        Glyphs  = {
            "WeaponGlyph", "ArmorGlyph", "JewelryGlyph",
        },
        Provisioning = {
            "FoodIngredient", "DrinkIngredient", "OldIngredient", "RareIngredient", "Bait",
        },
        Style = {
            "NormalStyle", "RareStyle", "AllianceStyle", "ExoticStyle", "CrownStyle",
        },
        Traits = {
            "ArmorTrait", "WeaponTrait", "JewelryTrait",
        },
        Jewelry = {
            "Neck", "Ring"
        },
        JewelryCrafting = {
            "RawPlating", "RawMaterial", "Plating", "RefinedMaterial",
        },
        JewelryCraftingStation = {
            "Neck", "Ring"
        },
    }
    local craftBagGroups = {
        [1] = "Blacksmithing",
        [2] = "Clothing",
        [3] = "Woodworking",
        [4] = "Alchemy",
        [5] = "Enchanting",
        [6] = "Provisioning",
        [7] = "Style",
        [8] = "Traits",
        [9] = "JewelryCrafting",
    }

    local function insertAddon(addonTable, groupName, subfilterName)
        groupName = groupName or ""
        subfilterName = subfilterName or subfilterName

--[[
    local addonName = ""
    if addonTable.name ~= nil and addonTable.name ~= "" then
        addonName = addonTable.name
    else
        addonName = addonTable.callbackTable[1].name
    end
d("->insertAddon addonName: " .. tostring(addonName) ..", groupName: " .. tostring(groupName) .. ", subfilterName: " .. tostring(subfilterName))
]]
        --generate information if necessary
        if addonTable.generator then
            local strings

            addonTable.callbackTable, strings = addonTable.generator()

            for key, string in pairs(strings) do
                AF.strings[key] = string
            end
        end

        --Is the addon filter not to be shown at some libFilter panels?
        if addonTable.excludeFilterPanels ~= nil then
            local filterType = AF.util.GetCurrentFilterTypeForInventory(AF.currentInventoryType)
            if type(addonTable.excludeFilterPanels) == "table" then
                for _, filterPanelToExclude in pairs(addonTable.excludeFilterPanels) do
                    if filterType == filterPanelToExclude then
--d(">>>insertAddon - filterPanelToExclude: " ..tostring(filterPanelToExclude))
                        return
                    end
                end
            else
                if filterType == addonTable.excludeFilterPanels then
--d(">>>insertAddon - filterPanelToExclude: " ..tostring(addonTable.excludeFilterPanels))
                    return
                end
            end
        end

        --Only add the entries if the group name specified "to be used" are the given ones
        if groupName ~= 'All' and addonTable.onlyGroups ~= nil then
            if type(addonTable.onlyGroups) == "table" then
                local allowedGroupNames = {}
                for _, groupNameToCheck in pairs(addonTable.onlyGroups) do
                    --Groupname "Craftbag" stands for several group names, so add them all
                    if groupNameToCheck == "Craftbag" then
                        for _, craftBagGroup in pairs(craftBagGroups) do
                            allowedGroupNames[craftBagGroup] = true
                        end
                    end
                    allowedGroupNames[groupNameToCheck] = true
                end
                if not allowedGroupNames[groupName] then
--d("-->insertAddon - onlyGroups: " ..tostring(groupName))
                    return
                end
            else
                if addonTable.onlyGroups == "Craftbag" then
                    local allowedGroupNames = {}
                    --Groupname "Craftbag" stands for several group names, so add them all
                    for _, craftBagGroup in pairs(craftBagGroups) do
                        allowedGroupNames[craftBagGroup] = true
                    end
                    if not allowedGroupNames[groupName] then
                        --d("-->insertAddon - onlyGroups: " ..tostring(groupName))
                        return
                    end

                else
                    if groupName ~= addonTable.onlyGroups then
                        --d("-->insertAddon - onlyGroups: " ..tostring(addonTable.onlyGroups))
                        return
                    end
                end
            end
        end

        --Should any subfilter be excluded?
        if addonTable.excludeSubfilters ~= nil then
            if type(addonTable.excludeSubfilters) == "table" then
                for _, subfilterNameToExclude in pairs(addonTable.excludeSubfilters) do
                    if subfilterNameOrig == subfilterNameToExclude or subfilterName == subfilterNameToExclude then
--d("--->insertAddon - excludeSubfilters: " ..tostring(subfilterNameToExclude))
                        return
                    end
                end
            else
                if subfilterNameOrig == addonTable.excludeSubfilters or subfilterName == addonTable.excludeSubfilters then
--d("--->insertAddon - excludeSubfilters: " ..tostring(subfilterName))
                    return
                end
            end
        end

        --was the same addon filter already added before via the "ALL" type
        --only check if the groupName not equals "ALL", and if the duplicate checks should be done
        --e.g. they are not needed as the global addon filters get added
        if groupName ~= 'All' then --and subfilterName == 'All' then
            --Build names to compare
            local compareNames = {}
            if addonTable.submenuName then
                table.insert(compareNames, addonTable.submenuName)
            else
                if addonTable.callbackTable then
                    for _, callbackTableNameEntry in ipairs(addonTable.callbackTable) do
                        table.insert(compareNames, callbackTableNameEntry.name)
                    end
                end
            end
            --Compare names with the entries in dropdownbox now
            for _, compareName in ipairs(compareNames) do
                --Check the whole callback table for entries with the same name or submenuName
                for _, callbackTableEntry in ipairs(callbackTable) do
                    if callbackTableEntry.submenuName then
                        if callbackTableEntry.submenuName == compareName then
--d(">Duplicate submenu entry: " .. tostring(callbackTableEntry.submenuName))
                            return
                        end
                    else
                        if callbackTableEntry.name and callbackTableEntry.name == compareName then
--d(">Duplicate entry: " .. tostring(callbackTableEntry.name))
                            return
                        end
                    end
                end
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
    end -- function "insertAddon"

    -- insert global AdvancedFilters "All" filters
    for _, callbackEntry in ipairs(AF.subfilterCallbacks.All.dropdownCallbacks) do
        table.insert(callbackTable, callbackEntry)
    end

    --insert filters that apply to a group
    if groupName ~= "All" then
        --insert global AdvancedFilters "group" filters
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
            --but check if the current panel should show the addon filters for "all" too
            if AF.util.checkIfPanelShouldShowAddonAllDropdownFilters(AF.currentInventoryType) then
--d(">show GROUP addon dropdown 'ALL' filters")
                for _, addonTable in ipairs(AF.subfilterCallbacks[groupName].addonDropdownCallbacks) do
                    insertAddon(addonTable, groupName, subfilterName)
                end
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
                        insertAddon(addonTable, groupName, subfilterName)
                    end
                end
            end
        end
    end

    --insert global addon filters
    --but check if the current panel should show the addon filters for "all" too
    if AF.util.checkIfPanelShouldShowAddonAllDropdownFilters(AF.currentInventoryType) then
        --d(">show addon dropdown 'ALL' filters")
        for _, addonTable in ipairs(AF.subfilterCallbacks.All.addonDropdownCallbacks) do
            insertAddon(addonTable, groupName, subfilterName)
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
    --Supporrt for AutoCategory AddOn ->
    -- Collapsable headers in the inventories & crafting stations
    if slot == nil or type(slot) ~= "table" or (slot.isHeader ~= nil and slot.isHeader) then return end

    if slot.bagId then
        return GetItemLink(slot.bagId, slot.slotIndex)
    else
        return GetStoreItemLink(slot.slotIndex)
    end
end

function AF.util.IsCraftingPanelShown()
    return ZO_CraftingUtils_IsCraftingWindowOpen()
end

function AF.util.GetCraftingType()
    --[[
        TradeskillType
        CRAFTING_TYPE_ALCHEMY
        CRAFTING_TYPE_BLACKSMITHING
        CRAFTING_TYPE_CLOTHIER
        CRAFTING_TYPE_ENCHANTING
        CRAFTING_TYPE_INVALID
        CRAFTING_TYPE_PROVISIONING
        CRAFTING_TYPE_WOODWORKING
        CRAFTING_TYPE_JEWELRYCRAFTING
    ]]
    return GetCraftingInteractionType() or CRAFTING_TYPE_INVALID
end

function AF.util.GetInventoryFromCraftingPanel(libFiltersFilterPanelId)
    if libFiltersFilterPanelId == nil then return end
    local libFiltersFilterPanelId2Inventory = {
        [LF_SMITHING_REFINE]        = nil, --SMITHING.refinementPanel.inventory,
        [LF_SMITHING_CREATION]      = nil, --SMITHING.creationPanel.inventory,
        [LF_SMITHING_DECONSTRUCT]   = SMITHING.deconstructionPanel.inventory,
        [LF_SMITHING_IMPROVEMENT]   = SMITHING.improvementPanel.inventory,
        [LF_JEWELRY_DECONSTRUCT]    = SMITHING.deconstructionPanel.inventory,
        [LF_JEWELRY_IMPROVEMENT]    = SMITHING.improvementPanel.inventory,
        [LF_SMITHING_RESEARCH]      = nil, --SMITHING.researchPanel.inventory,
        [LF_ENCHANTING_CREATION]    = ENCHANTING.inventory,
        [LF_ENCHANTING_EXTRACTION]  = ENCHANTING.inventory,
    }
    return libFiltersFilterPanelId2Inventory[libFiltersFilterPanelId]
end

function AF.util.IsCraftingStationInventoryType(inventoryType)
    local craftingInventoryTypes = {
        [LF_SMITHING_DECONSTRUCT]   = true,
        [LF_SMITHING_IMPROVEMENT]   = true,
        [LF_JEWELRY_DECONSTRUCT]    = true,
        [LF_JEWELRY_IMPROVEMENT]    = true,
        [LF_ENCHANTING_CREATION]    = true,
        [LF_ENCHANTING_EXTRACTION]  = true,
    }
    local retVar = false
    if craftingInventoryTypes[inventoryType] ~= nil then
        retVar = craftingInventoryTypes[inventoryType]
    end
    return retVar
end

function AF.util.MapItemFilterType2CraftingStationFilterType(itemFilterType, filterPanelId, craftingType)
    if filterPanelId == nil then return end
    --[[
        ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR = 1
        ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS = 2
        ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_RAW_MATERIALS = 3
        ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR = 1
        ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS = 2
        --
        ENCHANTING_MODE_CREATION    = 1
        ENCHANTING_MODE_EXTRACTION  = 2
    ]]
    --Map the filter type (selected button, e.g. weapons) of a crafting station to the
    --itemfilter type that is used for the filters (shown items)
    local mapIFT2CSFT = {
        [LF_SMITHING_DECONSTRUCT] = {
            [CRAFTING_TYPE_BLACKSMITHING] = {
                [ITEMFILTERTYPE_AF_WEAPONS_SMITHING]       = ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
                [ITEMFILTERTYPE_AF_ARMOR_SMITHING]         = ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
            },
            [CRAFTING_TYPE_CLOTHIER] = {
                [ITEMFILTERTYPE_AF_ARMOR_CLOTHIER]         = ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
            },
            [CRAFTING_TYPE_WOODWORKING] = {
                [ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING]    = ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS,
                [ITEMFILTERTYPE_AF_ARMOR_WOODWORKING]      = ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR,
            },
            --[[
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [ITEMFILTERTYPE_JEWELRYCRAFTING]           = SMITHING_FILTER_TYPE_JEWELRY,
            },
           ]]
        },
        [LF_SMITHING_IMPROVEMENT] = {
            [CRAFTING_TYPE_BLACKSMITHING] = {
                [ITEMFILTERTYPE_AF_WEAPONS_SMITHING]       = ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS,
                [ITEMFILTERTYPE_AF_ARMOR_SMITHING]         = ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR,
            },
            [CRAFTING_TYPE_CLOTHIER] = {
                [ITEMFILTERTYPE_AF_ARMOR_CLOTHIER]         = ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR,
            },
            [CRAFTING_TYPE_WOODWORKING] = {
                [ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING]    = ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS,
                [ITEMFILTERTYPE_AF_ARMOR_WOODWORKING]      = ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR,
            },
            --[[
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [ITEMFILTERTYPE_JEWELRYCRAFTING]           = SMITHING_FILTER_TYPE_JEWELRY,
            },
            ]]

        },
        [LF_JEWELRY_DECONSTRUCT] = {
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING]           = SMITHING_FILTER_TYPE_JEWELRY,
            },
        },
        [LF_JEWELRY_IMPROVEMENT] = {
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING]           = SMITHING_FILTER_TYPE_JEWELRY,
            },

        },
        [LF_ENCHANTING_CREATION] = {
            [CRAFTING_TYPE_ENCHANTING] = {
                --TODO: Enable if itemfiltertype subfilters for the runes work: ITEMFILTERTYPE_AF_RUNES_ENCHANTING,
                --[[
                [ITEMFILTERTYPE_AF_RUNES_ENCHANTING]       = ENCHANTING_MODE_CREATION,
                ]]
                [ITEMFILTERTYPE_ALL]       = ENCHANTING_MODE_CREATION,
            },
        },
        [LF_ENCHANTING_EXTRACTION] = {
            [CRAFTING_TYPE_ENCHANTING] = {
                [ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING]      = ENCHANTING_MODE_EXTRACTION,
            },
        },
    }
    if craftingType == nil then craftingType = AF.util.GetCraftingType() end
    if itemFilterType == nil or craftingType == nil or mapIFT2CSFT[filterPanelId] == nil or mapIFT2CSFT[filterPanelId][craftingType] == nil or mapIFT2CSFT[filterPanelId][craftingType][itemFilterType] == nil then return end
    return mapIFT2CSFT[filterPanelId][craftingType][itemFilterType]
end

function AF.util.MapCraftingStationFilterType2ItemFilterType(craftingStationFilterType, filterPanelId, craftingType)
    if filterPanelId == nil then return end
    --[[
        ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR = 1
        ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS = 2
        ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_RAW_MATERIALS = 3
        ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR = 1
        ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS = 2
        --
        ENCHANTING_MODE_CREATION    = 1
        ENCHANTING_MODE_EXTRACTION  = 2
    ]]
    --Map the filter type (selected button, e.g. weapons) of a crafting station to the
    --itemfilter type that is used for the filters (shown items)
    local mapCSFT2IFT = {
        [LF_SMITHING_DECONSTRUCT] = {
            [CRAFTING_TYPE_BLACKSMITHING] = {
                [ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS] = ITEMFILTERTYPE_AF_WEAPONS_SMITHING,
                [ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR]   = ITEMFILTERTYPE_AF_ARMOR_SMITHING,
            },
            [CRAFTING_TYPE_CLOTHIER] = {
                [ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR]   = ITEMFILTERTYPE_AF_ARMOR_CLOTHIER,
            },
            [CRAFTING_TYPE_WOODWORKING] = {
                [ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS] = ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING,
                [ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR]   = ITEMFILTERTYPE_AF_ARMOR_WOODWORKING,
            },
            --[[
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [SMITHING_FILTER_TYPE_JEWELRY]                      = ITEMFILTERTYPE_JEWELRYCRAFTING,
            },
            ]]

        },
        [LF_SMITHING_IMPROVEMENT] = {
            [CRAFTING_TYPE_BLACKSMITHING] = {
                [ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS]= ITEMFILTERTYPE_AF_WEAPONS_SMITHING,
                [ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR]  = ITEMFILTERTYPE_AF_ARMOR_SMITHING,
            },
            [CRAFTING_TYPE_CLOTHIER] = {
                [ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR]  = ITEMFILTERTYPE_AF_ARMOR_CLOTHIER,
            },
            [CRAFTING_TYPE_WOODWORKING] = {
                [ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS]= ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING,
                [ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR]  = ITEMFILTERTYPE_AF_ARMOR_WOODWORKING,
            },
            --[[
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [SMITHING_FILTER_TYPE_JEWELRY]                      = ITEMFILTERTYPE_JEWELRYCRAFTING,
            },
            ]]
        },
        [LF_JEWELRY_DECONSTRUCT] = {
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [SMITHING_FILTER_TYPE_JEWELRY]                      = ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING,
            },

        },
        [LF_JEWELRY_IMPROVEMENT] = {
            [CRAFTING_TYPE_JEWELRYCRAFTING] = {
                [SMITHING_FILTER_TYPE_JEWELRY]                      = ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING,
            },
        },
        [LF_ENCHANTING_CREATION] = {
            [CRAFTING_TYPE_ENCHANTING] = {
                [ENCHANTING_MODE_CREATION]                          = ITEMFILTERTYPE_ALL, --TODO: Enable if itemfiltertype subfilters for the runes work: ITEMFILTERTYPE_AF_RUNES_ENCHANTING,
            },
        },
        [LF_ENCHANTING_EXTRACTION] = {
                [CRAFTING_TYPE_ENCHANTING] = {
                    [ENCHANTING_MODE_EXTRACTION]                    = ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING,
                },
        }
    }
    if craftingType == nil then craftingType = AF.util.GetCraftingType() end
    if craftingStationFilterType == nil or craftingType == nil or mapCSFT2IFT[filterPanelId] == nil or mapCSFT2IFT[filterPanelId][craftingType] == nil or mapCSFT2IFT[filterPanelId][craftingType][craftingStationFilterType] == nil then return end
    return mapCSFT2IFT[filterPanelId][craftingType][craftingStationFilterType]
end

--Slot is the bagId, coming from libFilters, helper function (e.g. deconstruction).
--Prepare the slot variable with bagId and slotIndex
function AF.util.prepareSlot(bagId, slotIndex)
    local slot = {}
    slot.bagId = bagId
    slot.slotIndex = slotIndex
    return slot
end