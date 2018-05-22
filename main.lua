if AdvancedFilters == nil then AdvancedFilters = {} end
local AF = AdvancedFilters

--Get the current maximum itemfiltertye
AF.maxItemFilterType = ITEMFILTERTYPE_MAX_VALUE or 25 -- 25 is the maximum at API 100023 "Summerset"
--Build new "virtual" itemfiltertype for weapons + armor at blacksmith station.
--Needs the normal itemfiltertype_armor/weapon value "on-top" in order to get the change of
--a tab at the crafting station (ChangeFilter function) working.
--To distinguish the different crafting stations we need to add the TradeskillType number too
ITEMFILTERTYPE_AF_WEAPONS_SMITHING      = AF.maxItemFilterType + ITEMFILTERTYPE_WEAPONS + CRAFTING_TYPE_BLACKSMITHING
ITEMFILTERTYPE_AF_ARMOR_SMITHING        = AF.maxItemFilterType + ITEMFILTERTYPE_ARMOR + CRAFTING_TYPE_BLACKSMITHING
ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING   = AF.maxItemFilterType + ITEMFILTERTYPE_WEAPONS + CRAFTING_TYPE_WOODWORKING
ITEMFILTERTYPE_AF_ARMOR_WOODWORKING     = AF.maxItemFilterType + ITEMFILTERTYPE_ARMOR + CRAFTING_TYPE_WOODWORKING
ITEMFILTERTYPE_AF_ARMOR_CLOTHIER        = AF.maxItemFilterType + ITEMFILTERTYPE_ARMOR + CRAFTING_TYPE_CLOTHIER
ITEMFILTERTYPE_AF_RUNES_ENCHANTING      = AF.maxItemFilterType + ITEMFILTERTYPE_ENCHANTING + ENCHANTING_MODE_CREATION + CRAFTING_TYPE_ENCHANTING
ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING     = AF.maxItemFilterType + ITEMFILTERTYPE_ENCHANTING + ENCHANTING_MODE_EXTRACTION + CRAFTING_TYPE_ENCHANTING
ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING = AF.maxItemFilterType + ITEMFILTERTYPE_JEWELRYCRAFTING + SMITHING_FILTER_TYPE_JEWELRY + CRAFTING_TYPE_JEWELRYCRAFTING
--Get the current maximum inventory types and add 1 for the vendor buy inv type
INVENTORY_TYPE_VENDOR_BUY = 100

AF.subfilterGroups = {
    --Player inventory
    [INVENTORY_BACKPACK] = {
        [CRAFTING_TYPE_INVALID] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_WEAPONS] = {},
            [ITEMFILTERTYPE_ARMOR] = {},
            [ITEMFILTERTYPE_JEWELRY] = {},          -- new with Summersend
            [ITEMFILTERTYPE_JEWELRYCRAFTING] = {},  -- new with Summersend
            [ITEMFILTERTYPE_CONSUMABLE] = {},
            [ITEMFILTERTYPE_CRAFTING] = {},
            [ITEMFILTERTYPE_FURNISHING] = {},
            [ITEMFILTERTYPE_MISCELLANEOUS] = {},
            --[ITEMFILTERTYPE_JUNK] = {},
        },
    },
    --Bank
    [INVENTORY_BANK] = {
        [CRAFTING_TYPE_INVALID] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_WEAPONS] = {},
            [ITEMFILTERTYPE_ARMOR] = {},
            [ITEMFILTERTYPE_JEWELRY] = {},          -- new with Summersend
            [ITEMFILTERTYPE_JEWELRYCRAFTING] = {},  -- new with Summersend
            [ITEMFILTERTYPE_CONSUMABLE] = {},
            [ITEMFILTERTYPE_CRAFTING] = {},
            [ITEMFILTERTYPE_FURNISHING] = {},
            [ITEMFILTERTYPE_MISCELLANEOUS] = {},
            --[ITEMFILTERTYPE_JUNK] = {},
        },
    },
    --Guild bank
    [INVENTORY_GUILD_BANK] = {
        [CRAFTING_TYPE_INVALID] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_WEAPONS] = {},
            [ITEMFILTERTYPE_ARMOR] = {},
            [ITEMFILTERTYPE_JEWELRY] = {},          -- new with Summersend
            [ITEMFILTERTYPE_JEWELRYCRAFTING] = {},  -- new with Summersend
            [ITEMFILTERTYPE_CONSUMABLE] = {},
            [ITEMFILTERTYPE_CRAFTING] = {},
            [ITEMFILTERTYPE_FURNISHING] = {},
            [ITEMFILTERTYPE_MISCELLANEOUS] = {},
            --[ITEMFILTERTYPE_JUNK] = {},
        },
    },
    --Craft bag
    [INVENTORY_CRAFT_BAG] = {
        [CRAFTING_TYPE_INVALID] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_BLACKSMITHING] = {},
            [ITEMFILTERTYPE_CLOTHING] = {},
            [ITEMFILTERTYPE_WOODWORKING] = {},
            [ITEMFILTERTYPE_ALCHEMY] = {},
            [ITEMFILTERTYPE_ENCHANTING] = {},
            [ITEMFILTERTYPE_PROVISIONING] = {},
            [ITEMFILTERTYPE_JEWELRYCRAFTING] = {},  -- new with Summersend
            [ITEMFILTERTYPE_STYLE_MATERIALS] = {},
            [ITEMFILTERTYPE_TRAIT_ITEMS] = {},
        },
    },
    --Vendor buy
    [INVENTORY_TYPE_VENDOR_BUY] = {
        [CRAFTING_TYPE_INVALID] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_WEAPONS] = {},
            [ITEMFILTERTYPE_ARMOR] = {},
            [ITEMFILTERTYPE_CONSUMABLE] = {},
            [ITEMFILTERTYPE_CRAFTING] = {},
            [ITEMFILTERTYPE_MISCELLANEOUS] = {},
        },
    },
    --Crafting SMITHING: Deconstruction
    [LF_SMITHING_DECONSTRUCT] = {
        [CRAFTING_TYPE_BLACKSMITHING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_WEAPONS_SMITHING] = {},
            [ITEMFILTERTYPE_AF_ARMOR_SMITHING] = {},
        },
        [CRAFTING_TYPE_WOODWORKING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING] = {},
            [ITEMFILTERTYPE_AF_ARMOR_WOODWORKING] = {},
        },
        [CRAFTING_TYPE_CLOTHIER] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_ARMOR_CLOTHIER] = {},
        },
        --[[
        [CRAFTING_TYPE_JEWELRYCRAFTING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING] = {},
        },
        ]]
    },

    --Crafting SMITHING: Improvement
    [LF_SMITHING_IMPROVEMENT] = {
        [CRAFTING_TYPE_BLACKSMITHING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_WEAPONS_SMITHING] = {},
            [ITEMFILTERTYPE_AF_ARMOR_SMITHING] = {},
        },
        [CRAFTING_TYPE_WOODWORKING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING] = {},
            [ITEMFILTERTYPE_AF_ARMOR_WOODWORKING] = {},
        },
        [CRAFTING_TYPE_CLOTHIER] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_ARMOR_CLOTHIER] = {},
        },
        --[[
        [CRAFTING_TYPE_JEWELRYCRAFTING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING] = {},
        },
        ]]
    },

    --Crafting JEWELRY: Deconstruction
    [LF_JEWELRY_DECONSTRUCT] = {
        [CRAFTING_TYPE_JEWELRYCRAFTING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING] = {},
        },
    },
    --Crafting JEWELRY: Improvement
    [LF_JEWELRY_IMPROVEMENT] = {
        [CRAFTING_TYPE_JEWELRYCRAFTING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING] = {},
        },
    },

    --Crafting ENCHANTING: Creation
    [LF_ENCHANTING_CREATION] = {
        [CRAFTING_TYPE_ENCHANTING] = {
            [ITEMFILTERTYPE_ALL] = {},
            --[ITEMFILTERTYPE_AF_RUNES_ENCHANTING] = {}, TODO: Currently disabled as no extra filters are needed/possible
        },
    },
    --Crafting ENCHANTING: Extraction
    [LF_ENCHANTING_EXTRACTION] = {
        [CRAFTING_TYPE_ENCHANTING] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING] = {},
        },
    },
    --Houes bank withdraw
    [INVENTORY_HOUSE_BANK] = {
        [CRAFTING_TYPE_INVALID] = {
            [ITEMFILTERTYPE_ALL] = {},
            [ITEMFILTERTYPE_WEAPONS] = {},
            [ITEMFILTERTYPE_ARMOR] = {},
            [ITEMFILTERTYPE_CONSUMABLE] = {},
            [ITEMFILTERTYPE_CRAFTING] = {},
            [ITEMFILTERTYPE_FURNISHING] = {},
            [ITEMFILTERTYPE_MISCELLANEOUS] = {},
            --[ITEMFILTERTYPE_JUNK] = {},
            [ITEMFILTERTYPE_JEWELRY] = {},          -- new with Summersend
            [ITEMFILTERTYPE_JEWELRYCRAFTING] = {},  -- new with Summersend
        },
    },
}

AF.currentInventoryType = INVENTORY_BACKPACK

local function InitializeHooks()
    --TABLE TRACKER
    --[[
        this is a hacky way of knowing when items go in and out of an inventory.

        t = the tracked table (ZO_InventoryManager.isListDirty/PLAYER_INVENTORY.isListDirty)
        k = inventoryType
        v = isDirty
        pk = private key (no two empty tables are the same) where we store t
        mt = our metatable where we can do the tracking
    ]]
    --create private key
    local pk = {}
    --create metatable
    local mt = {
        __index = function(t, k)
            --d("*access to element " .. tostring(k))

            --access the tracked table
            return t[pk][k]
        end,
        __newindex = function(t, k, v)
            --d("*update of element " .. tostring(k) .. " to " .. tostring(v))

            --update the tracked table
            t[pk][k] = v

            --refresh subfilters for inventory type
            local subfilterGroup = AF.subfilterGroups[k]
            if not subfilterGroup then return end
            local currentSubfilterBar = subfilterGroup[AF.util.GetCraftingType()].currentSubfilterBar
            if not currentSubfilterBar then return end

            AF.util.ThrottledUpdate("RefreshSubfilterBar" .. currentSubfilterBar.name, 10, AF.util.RefreshSubfilterBar, currentSubfilterBar)
        end,
    }
    --tracking function. Returns a proxy table with our metatable attached.
    local function track(t)
        local proxy = {}
        proxy[pk] = t
        setmetatable(proxy, mt)
        return proxy
    end
    --untracking function. Returns the tracked table and destroys the proxy.
    local function untrack(proxy)
        local t = proxy[pk]
        proxy = nil
        return t
    end

    local function hideSubfilterBarSameParent(inventoryType)
--d("[AF]hideSubfilterBarSameParent - inventoryType: " .. inventoryType)
        --As some inventories/opanels use the same parents to anchor the subfilter bars to
        --the change of the panel won't chnage the parent and thus doesn't hide the subfilter
        --bars properly.
        --Example: ENCHANTING creation & extraction
        --This function checks the inventory type and hides the old subfilterbar if needed.
        if not inventoryType then return end
        local mapInvTypeToInvTypeBefore = {
            --Enchanting
            [LF_ENCHANTING_CREATION]   = LF_ENCHANTING_EXTRACTION,
            [LF_ENCHANTING_EXTRACTION] = LF_ENCHANTING_CREATION,
        }
        if mapInvTypeToInvTypeBefore[inventoryType] == nil then return false end
        local invTypeBefore = mapInvTypeToInvTypeBefore[inventoryType]
        if not invTypeBefore then return end
        local subfilterGroupBefore = AF.subfilterGroups[invTypeBefore]
        if subfilterGroupBefore ~= nil and subfilterGroupBefore.currentSubfilterBar then
            subfilterGroupBefore.currentSubfilterBar:SetHidden(true)
        end
    end

    local function ShowSubfilterBar(currentFilter, craftingType)
        if craftingType == nil then craftingType = AF.util.GetCraftingType() end
--d("[AF]]ShowSubfilterBar - currentFilter: " .. tostring(currentFilter) .. ", craftingType: " .. tostring(craftingType) .. ", invType: " .. tostring(AF.currentInventoryType))
        local function UpdateListAnchors(self, shiftY)
--d(">UpdateListAnchors - shiftY: " .. tostring(shiftY))
            if self == nil then return end
            local layoutData = self.appliedLayout or BACKPACK_DEFAULT_LAYOUT_FRAGMENT.layoutData
            if not layoutData then return end
            local list = self.list or self.inventories[AF.currentInventoryType].listView
            list:SetWidth(layoutData.width)
            list:ClearAnchors()
            list:SetAnchor(TOPRIGHT, nil, TOPRIGHT, 0, layoutData.backpackOffsetY + shiftY)
            list:SetAnchor(BOTTOMRIGHT)

            ZO_ScrollList_SetHeight(list, list:GetHeight())

            local sortBy = self.sortHeaders or self:GetDisplayInventoryTable(AF.currentInventoryType).sortHeaders
            sortBy = sortBy.headerContainer
            sortBy:ClearAnchors()
            sortBy:SetAnchor(TOPRIGHT, nil, TOPRIGHT, 0, layoutData.sortByOffsetY + shiftY)
        end

        --get new bar
        local subfilterGroup = AF.subfilterGroups[AF.currentInventoryType]
        local subfilterBar = subfilterGroup[craftingType][currentFilter]

        --hide old bar, if it exists
        if subfilterGroup.currentSubfilterBar ~= nil then
--d(">hiding current/old subfilterbar")
            subfilterGroup.currentSubfilterBar:SetHidden(true)
        end
        --hide old bar at same parent
        hideSubfilterBarSameParent(AF.currentInventoryType)

        --do nothing if we're in a guild store and regular filters are disabled.
        if not ZO_TradingHouse:IsHidden() and AF.util.libCIF._guildStoreSellFiltersDisabled then return end

        --Crafting
        local craftingInv
        local isCraftingInventoryType = false
        if AF.util.IsCraftingPanelShown() then
--d(">crafting subfilterbar shown")
            isCraftingInventoryType = AF.util.IsCraftingStationInventoryType(subfilterBar.inventoryType)
            if isCraftingInventoryType then
                craftingInv = AF.util.GetInventoryFromCraftingPanel(subfilterBar.inventoryType)
            end
        end

        --if new bar exists
        if subfilterBar then
            --set current bar reference
            subfilterGroup.currentSubfilterBar = subfilterBar

--d(">subfilterBar exists, name: " .. tostring(subfilterBar.control:GetName()) .. ",  inventoryType: " ..tostring(subfilterBar.inventoryType))

            --set currentFilter since we need it before the original ChangeFilter updates it
            if subfilterBar.inventoryType == INVENTORY_TYPE_VENDOR_BUY then
                STORE_WINDOW.currentFilter = currentFilter
            elseif isCraftingInventoryType then
--d("> Set currentfilter to: " .. currentFilter)
                craftingInv.currentFilter = currentFilter
            else
--d(">player inv. subfilterbar")
                PLAYER_INVENTORY.inventories[subfilterBar.inventoryType].currentFilter = currentFilter
            end

            --activate current button
            subfilterBar:ActivateButton(subfilterBar:GetCurrentButton())

            --show the bar
            subfilterBar:SetHidden(false)

            --set proper inventory anchor displacement
            if subfilterBar.inventoryType == INVENTORY_TYPE_VENDOR_BUY then
                UpdateListAnchors(STORE_WINDOW, subfilterBar.control:GetHeight())
            elseif isCraftingInventoryType then
--d("> UpdateListAnchors - Crafting")
                UpdateListAnchors(craftingInv, subfilterBar.control:GetHeight())
            else
                UpdateListAnchors(PLAYER_INVENTORY, subfilterBar.control:GetHeight())
            end
        else
            --remove all filters
            AF.util.RemoveAllFilters()

            --set original inventory anchor displacement
            if AF.currentInventoryType == INVENTORY_TYPE_VENDOR_BUY then
                UpdateListAnchors(STORE_WINDOW, 0)
            elseif isCraftingInventoryType then
                UpdateListAnchors(craftingInv, 0)
            else
                UpdateListAnchors(PLAYER_INVENTORY, 0)
            end

            --remove current bar reference
            subfilterGroup.currentSubfilterBar = nil
        end
    end

    --FRAGMENT HOOKS
    local function hookFragment(fragment, inventoryType)
        local function onFragmentShowing()
            AF.currentInventoryType = inventoryType

            if inventoryType == INVENTORY_TYPE_VENDOR_BUY then
                AF.util.ThrottledUpdate("ShowSubfilterBar" .. inventoryType, 10,
                  ShowSubfilterBar, STORE_WINDOW.currentFilter)
            else
                AF.util.ThrottledUpdate(
                  "ShowSubfilterBar" .. inventoryType, 10, ShowSubfilterBar,
                  PLAYER_INVENTORY.inventories[inventoryType].currentFilter)
            end

            PLAYER_INVENTORY.isListDirty = track(PLAYER_INVENTORY.isListDirty)
        end

        local function onFragmentHiding()
            PLAYER_INVENTORY.isListDirty = untrack(PLAYER_INVENTORY.isListDirty)
        end

        local function onFragmentStateChange(oldState, newState)
            if newState == SCENE_FRAGMENT_SHOWING then
                onFragmentShowing()
            elseif newState == SCENE_FRAGMENT_HIDING then
                onFragmentHiding()
            end
        end

        fragment:RegisterCallback("StateChange", onFragmentStateChange)
    end
    hookFragment(INVENTORY_FRAGMENT, INVENTORY_BACKPACK)
    hookFragment(BANK_FRAGMENT, INVENTORY_BANK)
    hookFragment(HOUSE_BANK_FRAGMENT, INVENTORY_HOUSE_BANK)
    hookFragment(GUILD_BANK_FRAGMENT, INVENTORY_GUILD_BANK) -- new value is: 5
    hookFragment(CRAFT_BAG_FRAGMENT, INVENTORY_CRAFT_BAG) -- new value is: 6
    hookFragment(STORE_FRAGMENT, INVENTORY_TYPE_VENDOR_BUY)

    --Hook the crafting station
    --SMITHING
    local function HookSmithingSetMode(self, mode)
        if not AF.util.IsCraftingPanelShown() then return false end
        --[[
            --Smithing modes
            SMITHING_MODE_ROOT = 0
            SMITHING_MODE_REFINMENT = 1
            SMITHING_MODE_CREATION = 2
            SMITHING_MODE_DECONSTRUCTION = 3
            SMITHING_MODE_IMPROVEMENT = 4
            SMITHING_MODE_RESEARCH = 5
            SMITHING_MODE_RECIPES = 6
        ]]
        local craftType = GetCraftingInteractionType()
        if     mode == SMITHING_MODE_DECONSTRUCTION then
            if craftType == CRAFTING_TYPE_JEWELRYCRAFTING then
                AF.currentInventoryType = LF_JEWELRY_DECONSTRUCT
            else
                AF.currentInventoryType = LF_SMITHING_DECONSTRUCT
            end
        elseif mode == SMITHING_MODE_IMPROVEMENT then
            if craftType == CRAFTING_TYPE_JEWELRYCRAFTING then
                AF.currentInventoryType = LF_JEWELRY_IMPROVEMENT
            else
                AF.currentInventoryType = LF_SMITHING_IMPROVEMENT
            end
        end
        return false
    end
    --ZO_PreHook(ZO_Smithing, "SetMode", HookSmithingSetMode)
    local origSmithingSetMode = ZO_Smithing.SetMode
    ZO_Smithing.SetMode = function(...)
        origSmithingSetMode(...)
        HookSmithingSetMode(...)
    end

    --ENCHANTING
    local function HookEnchantingSetEnchantingMode(self, mode)
--d("[AF]HookEnchantingSetEnchantingMode, mode: " .. tostring(mode))
        if not AF.util.IsCraftingPanelShown() then return false end
        --[[
            --Enchanting modes
            ENCHANTING_MODE_CREATION = 1
            ENCHANTING_MODE_EXTRACTION = 2
            ENCHANTING_MODE_NONE = 0
        ]]
        if     mode == ENCHANTING_MODE_CREATION then
            AF.currentInventoryType = LF_ENCHANTING_CREATION
        elseif mode == ENCHANTING_MODE_EXTRACTION then
            AF.currentInventoryType = LF_ENCHANTING_EXTRACTION
        end
        return false
    end
    --ZO_PreHook(ZO_Enchanting, "SetEnchantingMode", HookEnchantingSetEnchantingMode)
    local origEnchantingSetEnchantMode = ZO_Enchanting.SetEnchantingMode
    ZO_Enchanting.SetEnchantingMode = function(...)
        origEnchantingSetEnchantMode(...)
        HookEnchantingSetEnchantingMode(...)
    end

    --PREHOOKS
    local function ChangeFilterInventory(self, filterTab)
        local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)
        if AF.currentInventoryType ~= INVENTORY_TYPE_VENDOR_BUY then
            AF.util.ThrottledUpdate(
              "ShowSubfilterBar" .. AF.currentInventoryType, 10,
              ShowSubfilterBar, currentFilter)
        end
    end
    ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilterInventory)

    local function ChangeFilterVendor(self, filterTab)
        local currentFilter = filterTab.filterType

        AF.util.ThrottledUpdate("ShowSubfilterBar" .. tostring(INVENTORY_TYPE_VENDOR_BUY), 10, ShowSubfilterBar,
          currentFilter)

        local subfilterGroup = AF.subfilterGroups[INVENTORY_TYPE_VENDOR_BUY]
        if not subfilterGroup then return end
        local currentSubfilterBar = subfilterGroup[AF.util.GetCraftingType()].currentSubfilterBar
        if not currentSubfilterBar then return end

        AF.util.ThrottledUpdate("RefreshSubfilterBar" .. currentSubfilterBar.name, 10,
          AF.util.RefreshSubfilterBar, currentSubfilterBar)
    end
    ZO_PreHook(STORE_WINDOW, "ChangeFilter", ChangeFilterVendor)

    local function ChangeFilterCrafting(self, filterTab)
        zo_callLater(function()
            local invType = AF.currentInventoryType
            local craftingType = AF.util.GetCraftingType()
            local currentFilter = AF.util.MapCraftingStationFilterType2ItemFilterType(self.filterType, invType, craftingType)

            AF.util.ThrottledUpdate("ShowSubfilterBar" .. invType .. "_" .. craftingType, 10,
                ShowSubfilterBar, currentFilter, craftingType)

            local subfilterGroup = AF.subfilterGroups[invType]
            if not subfilterGroup then return end
            local currentSubfilterBar = subfilterGroup[craftingType].currentSubfilterBar
            if not currentSubfilterBar then return end

            AF.util.ThrottledUpdate("RefreshSubfilterBar" .. currentSubfilterBar.name, 10,
                AF.util.RefreshSubfilterBar, currentSubfilterBar)

        end, 10) -- called with small delay, otherwise self.filterType is nil
    end
    ZO_PreHook(SMITHING.deconstructionPanel.inventory, "ChangeFilter", ChangeFilterCrafting)
    ZO_PreHook(SMITHING.improvementPanel.inventory, "ChangeFilter", ChangeFilterCrafting)

    local function ChangeFilterEnchanting(self, filterTab)
        zo_callLater(function()
            local invType = AF.currentInventoryType
            local craftingType = AF.util.GetCraftingType()
            local currentFilter = AF.util.MapCraftingStationFilterType2ItemFilterType(self.owner.enchantingMode, invType, craftingType)
--d("[AF]ChangeFilterEnchanting - currentFilter: " ..tostring(currentFilter) .. ", currentInventoryType: " .. tostring(invType) .. ", craftingType: " ..tostring(craftingType))
            --Only show subfilters at the enchanting extraction panel
            AF.util.ThrottledUpdate("ShowSubfilterBar" .. invType .. "_" .. craftingType, 10,
                ShowSubfilterBar, currentFilter, craftingType)
            local subfilterGroup = AF.subfilterGroups[invType]
            if not subfilterGroup then return end
            local currentSubfilterBar = subfilterGroup[craftingType].currentSubfilterBar
            if not currentSubfilterBar then return end

            AF.util.ThrottledUpdate("RefreshSubfilterBar" .. currentSubfilterBar.name, 10,
                AF.util.RefreshSubfilterBar, currentSubfilterBar)

        end, 10) -- called with small delay, otherwise self.filterType is nil
    end
    ZO_PreHook(ENCHANTING.inventory, "ChangeFilter", ChangeFilterEnchanting)
end

local function PresetCraftingStationHookVariables()
    --Preset the deconstruction/improvement crafting station currentFilter variables with "Weapons"
    SMITHING.deconstructionPanel.inventory.currentFilter= AF.util.MapItemFilterType2CraftingStationFilterType(ITEMFILTERTYPE_AF_WEAPONS_SMITHING, LF_SMITHING_DECONSTRUCT, CRAFTING_TYPE_BLACKSMITHING)
    SMITHING.improvementPanel.inventory.currentFilter   = AF.util.MapItemFilterType2CraftingStationFilterType(ITEMFILTERTYPE_AF_WEAPONS_SMITHING, LF_SMITHING_IMPROVEMENT, CRAFTING_TYPE_BLACKSMITHING)
    ENCHANTING.inventory.currentFilter                  = AF.util.MapItemFilterType2CraftingStationFilterType(ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING, LF_ENCHANTING_EXTRACTION, CRAFTING_TYPE_ENCHANTING)
end

local function CreateSubfilterBars()
    local inventoryNames = {
        [INVENTORY_BACKPACK]        = "PlayerInventory",
        [INVENTORY_BANK]            = "PlayerBank",
        [INVENTORY_GUILD_BANK]      = "GuildBank",
        [INVENTORY_CRAFT_BAG]       = "CraftBag",
        [INVENTORY_TYPE_VENDOR_BUY] = "VendorBuy",
        [LF_SMITHING_DECONSTRUCT]   = "SmithingDeconstruction",
        [LF_SMITHING_IMPROVEMENT]   = "SmithingImprovement",
        [LF_JEWELRY_DECONSTRUCT]    = "JewelryCraftingDeconstruction",
        [LF_JEWELRY_IMPROVEMENT]    = "JewelryCraftingImprovement",
        [LF_ENCHANTING_CREATION]    = "EnchantingCreation",
        [LF_ENCHANTING_EXTRACTION]  = "EnchantingExtraction",
        [INVENTORY_HOUSE_BANK]      = "HouseBankWithdraw",
    }

    local tradeSkillNames = {
        [CRAFTING_TYPE_INVALID]         = "_",
        [CRAFTING_TYPE_ALCHEMY]         = "_ALCHEMY_",
        [CRAFTING_TYPE_BLACKSMITHING]   = "_BLACKSMITH_",
        [CRAFTING_TYPE_CLOTHIER]        = "_CLOTHIER_",
        [CRAFTING_TYPE_ENCHANTING]      = "_ENCHANTING_",
        [CRAFTING_TYPE_PROVISIONING]    = "_PROVISIONING_",
        [CRAFTING_TYPE_WOODWORKING]     = "_WOODWORKING_",
        [CRAFTING_TYPE_JEWELRYCRAFTING] = "_JEWELRY_",
    }

    local filterTypeNames = {
        [ITEMFILTERTYPE_ALL]                    = "All",
        [ITEMFILTERTYPE_WEAPONS]                = "Weapons",
        [ITEMFILTERTYPE_AF_WEAPONS_SMITHING]    = "Weapons",
        [ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING] = "Weapons",
        [ITEMFILTERTYPE_ARMOR]                  = "Armor",
        [ITEMFILTERTYPE_AF_ARMOR_SMITHING]      = "Armor",
        [ITEMFILTERTYPE_AF_ARMOR_WOODWORKING]   = "Armor",
        [ITEMFILTERTYPE_AF_ARMOR_CLOTHIER]      = "Armor",
        [ITEMFILTERTYPE_AF_RUNES_ENCHANTING]    = "Runes",
        [ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING]   = "Glyphs",
        [ITEMFILTERTYPE_JEWELRY]                = "Jewelry",
        [ITEMFILTERTYPE_JEWELRYCRAFTING]        = "JewelryCrafting",
        [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING] = "JewelryCraftingStation",
        [ITEMFILTERTYPE_CONSUMABLE]             = "Consumables",
        [ITEMFILTERTYPE_CRAFTING]               = "Crafting",
        [ITEMFILTERTYPE_FURNISHING]             = "Furnishings",
        [ITEMFILTERTYPE_MISCELLANEOUS]          = "Miscellaneous",
        --[ITEMFILTERTYPE_JUNK] = "Junk",
        [ITEMFILTERTYPE_BLACKSMITHING]          = "Blacksmithing",
        [ITEMFILTERTYPE_CLOTHING]               = "Clothing",
        [ITEMFILTERTYPE_WOODWORKING]            = "Woodworking",
        [ITEMFILTERTYPE_ALCHEMY]                = "Alchemy",
        [ITEMFILTERTYPE_ENCHANTING]             = "Enchanting",
        [ITEMFILTERTYPE_PROVISIONING]           = "Provisioning",
        [ITEMFILTERTYPE_STYLE_MATERIALS]        = "Style",
        [ITEMFILTERTYPE_TRAIT_ITEMS]            = "Traits",
    }

    local subfilterButtonNames = {
        [ITEMFILTERTYPE_ALL] = {
            "All",
        },
        [ITEMFILTERTYPE_WEAPONS] = {
            "HealStaff", "DestructionStaff", "Bow", "TwoHand", "OneHand", "All",
        },
        [ITEMFILTERTYPE_AF_WEAPONS_SMITHING] = {
            "TwoHand", "OneHand", "All",
        },
        [ITEMFILTERTYPE_AF_WEAPONS_WOODWORKING] = {
            "HealStaff", "DestructionStaff", "Bow", "All",
        },
        [ITEMFILTERTYPE_ARMOR] = {
            "Vanity", "Shield", "Clothing", "LightArmor", "Medium",
            "Heavy", "All",
        },
        [ITEMFILTERTYPE_JEWELRY] = {
            "Neck", "Ring", "All",
        },
        [ITEMFILTERTYPE_AF_ARMOR_SMITHING] = {
            "Heavy", "All",
        },
        [ITEMFILTERTYPE_AF_ARMOR_CLOTHIER] = {
            "LightArmor", "Medium", "All",
        },
        [ITEMFILTERTYPE_AF_ARMOR_WOODWORKING] = {
            "Shield", "All",
        },
        [ITEMFILTERTYPE_AF_RUNES_ENCHANTING] = {
            "All",
        },
        [ITEMFILTERTYPE_AF_GLYPHS_ENCHANTING] = {
            "WeaponGlyph", "ArmorGlyph", "JewelryGlyph", "All",
        },
        [ITEMFILTERTYPE_CONSUMABLE] = {
            "Trophy", "Repair", "Container", "Writ", "Motif", "Poison",
            "Potion", "Recipe", "Drink", "Food", "Crown", "All",
        },
        [ITEMFILTERTYPE_CRAFTING] = {
            "FurnishingMat", "JewelryTrait", "WeaponTrait", "ArmorTrait", "Style",
            "JewelryCrafting", "Provisioning", "Enchanting", "Alchemy", "Woodworking",
            "Clothier", "Blacksmithing", "All",
        },
        [ITEMFILTERTYPE_FURNISHING] = {
            "TargetDummy", "Seating", "Ornamental", "Light", "CraftingStation",
            "All",
        },
        [ITEMFILTERTYPE_MISCELLANEOUS] = {
            "Trash", "Fence", "Trophy", "Tool", "Bait", "Siege", "SoulGem",
            "Glyphs", "All",
        },
        --[[[ITEMFILTERTYPE_JUNK] = {
            "Miscellaneous", "Materials", "Consumable", "Apparel", "Weapon",
            "All"
        },]]
        [ITEMFILTERTYPE_BLACKSMITHING] = {
            "FurnishingMat", "Temper", "RefinedMaterial", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_CLOTHING] = {
            "FurnishingMat", "Resin", "RefinedMaterial", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_WOODWORKING] = {
            "FurnishingMat", "Tannin", "RefinedMaterial", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_ALCHEMY] = {
            "FurnishingMat", "Oil", "Water", "Reagent", "All",
        },
        [ITEMFILTERTYPE_ENCHANTING] = {
            "FurnishingMat", "Potency", "Essence", "Aspect", "All",
        },
        [ITEMFILTERTYPE_PROVISIONING] = {
            "FurnishingMat", "Bait", "RareIngredient", "OldIngredient",
            "DrinkIngredient", "FoodIngredient", "All",
        },
        [ITEMFILTERTYPE_JEWELRYCRAFTING] = {
            "FurnishingMat", "Plating", "RefinedMaterial", "RawPlating", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_AF_ITEMFILTERTYPE_JEWELRYCRAFTING] = {
            "Ring", "Neck", "All",
        },
        [ITEMFILTERTYPE_STYLE_MATERIALS] = {
            "CrownStyle", "ExoticStyle", "AllianceStyle", "RareStyle",
            "NormalStyle", "All",
        },
        [ITEMFILTERTYPE_TRAIT_ITEMS] = {
            "JewelryTrait", "WeaponTrait", "ArmorTrait", "All",
        },
    }

    for inventoryType, tradeSkillTypeSubFilterGroup in pairs(AF.subfilterGroups) do
        for tradeSkillType, subfilterGroup in pairs(tradeSkillTypeSubFilterGroup) do
            for itemFilterType, _ in pairs(subfilterGroup) do
                local subfilterBar = AF.AF_FilterBar:New(
                  inventoryNames[inventoryType],
                  tradeSkillNames[tradeSkillType],
                  filterTypeNames[itemFilterType],
                  subfilterButtonNames[itemFilterType]
                )

                subfilterBar:SetInventoryType(inventoryType)

                AF.subfilterGroups[inventoryType][tradeSkillType][itemFilterType] = subfilterBar
            end
        end
    end
end

function AdvancedFilters_Loaded(eventCode, addonName)
    if addonName ~= "AdvancedFilters" then return end
    EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)

    AF.util.LibFilters:InitializeLibFilters()

    CreateSubfilterBars()
    InitializeHooks()
    PresetCraftingStationHookVariables()
end
EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)