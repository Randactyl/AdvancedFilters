AdvancedFilters = {}
local AF = AdvancedFilters

AF.subfilterGroups = {
    [INVENTORY_BACKPACK] = {
        [ITEMFILTERTYPE_ALL] = {},
        [ITEMFILTERTYPE_WEAPONS] = {},
        [ITEMFILTERTYPE_ARMOR] = {},
        [ITEMFILTERTYPE_CONSUMABLE] = {},
        [ITEMFILTERTYPE_CRAFTING] = {},
        [ITEMFILTERTYPE_FURNISHING] = {},
        [ITEMFILTERTYPE_MISCELLANEOUS] = {},
        [ITEMFILTERTYPE_JUNK] = {},
    },
    [INVENTORY_BANK] = {
        [ITEMFILTERTYPE_ALL] = {},
        [ITEMFILTERTYPE_WEAPONS] = {},
        [ITEMFILTERTYPE_ARMOR] = {},
        [ITEMFILTERTYPE_CONSUMABLE] = {},
        [ITEMFILTERTYPE_CRAFTING] = {},
        [ITEMFILTERTYPE_FURNISHING] = {},
        [ITEMFILTERTYPE_MISCELLANEOUS] = {},
        [ITEMFILTERTYPE_JUNK] = {},
    },
    [INVENTORY_GUILD_BANK] = {
        [ITEMFILTERTYPE_ALL] = {},
        [ITEMFILTERTYPE_WEAPONS] = {},
        [ITEMFILTERTYPE_ARMOR] = {},
        [ITEMFILTERTYPE_CONSUMABLE] = {},
        [ITEMFILTERTYPE_CRAFTING] = {},
        [ITEMFILTERTYPE_FURNISHING] = {},
        [ITEMFILTERTYPE_MISCELLANEOUS] = {},
        [ITEMFILTERTYPE_JUNK] = {},
    },
    [INVENTORY_CRAFT_BAG] = {
        [ITEMFILTERTYPE_ALL] = {},
        [ITEMFILTERTYPE_BLACKSMITHING] = {},
        [ITEMFILTERTYPE_CLOTHING] = {},
        [ITEMFILTERTYPE_WOODWORKING] = {},
        [ITEMFILTERTYPE_ALCHEMY] = {},
        [ITEMFILTERTYPE_ENCHANTING] = {},
        [ITEMFILTERTYPE_PROVISIONING] = {},
        [ITEMFILTERTYPE_STYLE_MATERIALS] = {},
        [ITEMFILTERTYPE_TRAIT_ITEMS] = {},
    },
    [6] = {
        [ITEMFILTERTYPE_ALL] = {},
        [ITEMFILTERTYPE_WEAPONS] = {},
        [ITEMFILTERTYPE_ARMOR] = {},
        [ITEMFILTERTYPE_CONSUMABLE] = {},
        [ITEMFILTERTYPE_CRAFTING] = {},
        [ITEMFILTERTYPE_MISCELLANEOUS] = {},
    }, --VENDOR_SELL
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
            local currentSubfilterBar = subfilterGroup.currentSubfilterBar
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

    local function ShowSubfilterBar(currentFilter)
        local function UpdateListAnchors(self, shiftY)
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
        local subfilterBar = subfilterGroup[currentFilter]

        --hide old bar, if it exists
        if subfilterGroup.currentSubfilterBar ~= nil then
            subfilterGroup.currentSubfilterBar:SetHidden(true)
        end

        --if new bar exists
        if subfilterBar then
            --set current bar reference
            subfilterGroup.currentSubfilterBar = subfilterBar

            --set currentFilter since we need it before the original ChangeFilter updates it
            if subfilterBar.inventoryType == 6 then
                STORE_WINDOW.currentFilter = currentFilter
            else
                PLAYER_INVENTORY.inventories[subfilterBar.inventoryType].currentFilter = currentFilter
            end

            --activate current button
            subfilterBar:ActivateButton(subfilterBar:GetCurrentButton())

            --show the bar
            subfilterBar:SetHidden(false)

            --set proper inventory anchor displacement
            if subfilterBar.inventoryType == 6 then
                UpdateListAnchors(STORE_WINDOW, subfilterBar.control:GetHeight())
            else
                UpdateListAnchors(PLAYER_INVENTORY, subfilterBar.control:GetHeight())
            end
        else
            --remove all filters
            AF.util.RemoveAllFilters()

            --set original inventory anchor displacement
            if AF.currentInventoryType == 6 then
                UpdateListAnchors(STORE_WINDOW, 0)
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

            if inventoryType == 6 then
                AF.util.ThrottledUpdate("ShowSubfilterBar" .. inventoryType, 10,
                  ShowSubfilterBar, STORE_WINDOW.currentFilter)
            else
                AF.util.ThrottledUpdate(
                  "ShowSubfilterBar" .. inventoryType, 10, ShowSubfilterBar,
                  PLAYER_INVENTORY.inventories[inventoryType].currentFilter)
            end

            --PLAYER_INVENTORY.isListDirty doesn't "exist" in the first place.
            --The table in the backing class was being used, so we'll track that table,
            --    but set the proxy to the lookup point.
            PLAYER_INVENTORY.isListDirty = track(ZO_InventoryManager.isListDirty)
        end

        local function onFragmentHiding()
            PLAYER_INVENTORY.isListDirty = untrack(ZO_InventoryManager.isListDirty)
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
    hookFragment(GUILD_BANK_FRAGMENT, INVENTORY_GUILD_BANK)
    hookFragment(CRAFT_BAG_FRAGMENT, INVENTORY_CRAFT_BAG)
    hookFragment(STORE_FRAGMENT, 6)

    --PREHOOKS
    local function ChangeFilterInventory(self, filterTab)
        local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)

        if AF.currentInventoryType ~= 6 then
            AF.util.ThrottledUpdate(
              "ShowSubfilterBar" .. AF.currentInventoryType, 10,
              ShowSubfilterBar, currentFilter)
        end
    end
    ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilterInventory)
    local function ChangeFilterVendor(self, filterTab)
        local currentFilter = filterTab.filterType

        AF.util.ThrottledUpdate("ShowSubfilterBar6", 10, ShowSubfilterBar,
          currentFilter)

        local subfilterGroup = AF.subfilterGroups[6]
        if not subfilterGroup then return end
        local currentSubfilterBar = subfilterGroup.currentSubfilterBar
        if not currentSubfilterBar then return end

        AF.util.ThrottledUpdate("RefreshSubfilterBar" .. currentSubfilterBar.name, 10,
          AF.util.RefreshSubfilterBar, currentSubfilterBar)
    end
    ZO_PreHook(STORE_WINDOW, "ChangeFilter", ChangeFilterVendor)
end

local function CreateSubfilterBars()
    local inventoryNames = {
        [INVENTORY_BACKPACK] = "PlayerInventory",
        [INVENTORY_BANK] = "PlayerBank",
        [INVENTORY_GUILD_BANK] = "GuildBank",
        [INVENTORY_CRAFT_BAG] = "CraftBag",
        [6] = "VendorSell",
    }

    local filterTypeNames = {
        [ITEMFILTERTYPE_ALL] = "All",
        [ITEMFILTERTYPE_WEAPONS] = "Weapons",
        [ITEMFILTERTYPE_ARMOR] = "Armor",
        [ITEMFILTERTYPE_CONSUMABLE] = "Consumables",
        [ITEMFILTERTYPE_CRAFTING] = "Crafting",
        [ITEMFILTERTYPE_FURNISHING] = "Furnishings",
        [ITEMFILTERTYPE_MISCELLANEOUS] = "Miscellaneous",
        [ITEMFILTERTYPE_JUNK] = "Junk",
        [ITEMFILTERTYPE_BLACKSMITHING] = "Blacksmithing",
        [ITEMFILTERTYPE_CLOTHING] = "Clothing",
        [ITEMFILTERTYPE_WOODWORKING] = "Woodworking",
        [ITEMFILTERTYPE_ALCHEMY] = "Alchemy",
        [ITEMFILTERTYPE_ENCHANTING] = "Enchanting",
        [ITEMFILTERTYPE_PROVISIONING] = "Provisioning",
        [ITEMFILTERTYPE_STYLE_MATERIALS] = "Style",
        [ITEMFILTERTYPE_TRAIT_ITEMS] = "Traits",
    }

    local subfilterButtonNames = {
        [ITEMFILTERTYPE_ALL] = {
            "All",
        },
        [ITEMFILTERTYPE_WEAPONS] = {
            "HealStaff", "DestructionStaff", "Bow", "TwoHand", "OneHand", "All",
        },
        [ITEMFILTERTYPE_ARMOR] = {
            "Vanity", "Jewelry", "Shield", "Clothing", "LightArmor", "Medium",
            "Heavy", "All",
        },
        [ITEMFILTERTYPE_CONSUMABLE] = {
            "Trophy", "Repair", "Container", "Writ", "Motif", "Poison",
            "Potion", "Recipe", "Drink", "Food", "Crown", "All",
        },
        [ITEMFILTERTYPE_CRAFTING] = {
            "WeaponTrait", "ArmorTrait", "Style", "Provisioning", "Enchanting",
            "Alchemy", "Woodworking", "Clothier", "Blacksmithing", "All",
        },
        [ITEMFILTERTYPE_FURNISHING] = {
            "TargetDummy", "Seating", "Ornamental", "Light", "CraftingStation",
            "All",
        },
        [ITEMFILTERTYPE_MISCELLANEOUS] = {
            "Trash", "Fence", "Trophy", "Tool", "Bait", "Siege", "SoulGem",
            "Glyphs", "All",
        },
        [ITEMFILTERTYPE_JUNK] = {
            "Miscellaneous", "Materials", "Consumable", "Apparel", "Weapon",
            "All"
        },
        [ITEMFILTERTYPE_BLACKSMITHING] = {
            "Temper", "RefinedMaterial", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_CLOTHING] = {
            "Resin", "RefinedMaterial", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_WOODWORKING] = {
            "Tannin", "RefinedMaterial", "RawMaterial", "All",
        },
        [ITEMFILTERTYPE_ALCHEMY] = {
            "Oil", "Water", "Reagent", "All",
        },
        [ITEMFILTERTYPE_ENCHANTING] = {
            "Potency", "Essence", "Aspect", "All",
        },
        [ITEMFILTERTYPE_PROVISIONING] = {
            "Bait", "RareIngredient", "OldIngredient", "DrinkIngredient", "FoodIngredient", "All",
        },
        [ITEMFILTERTYPE_STYLE_MATERIALS] = {
            "CrownStyle", "ExoticStyle", "AllianceStyle", "RareStyle",
            "NormalStyle", "All",
        },
        [ITEMFILTERTYPE_TRAIT_ITEMS] = {
            "WeaponTrait", "ArmorTrait", "All",
        },
    }

    for inventoryType, subfilterGroup in pairs(AF.subfilterGroups) do
        for itemFilterType, _ in pairs(subfilterGroup) do
            local subfilterBar = AF.AF_FilterBar:New(
              inventoryNames[inventoryType],
              filterTypeNames[itemFilterType],
              subfilterButtonNames[itemFilterType]
            )

            subfilterBar:SetInventoryType(inventoryType)

            AF.subfilterGroups[inventoryType][itemFilterType] = subfilterBar
        end
    end
end

function AdvancedFilters_Loaded(eventCode, addonName)
    if addonName ~= "AdvancedFilters" then return end
    EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)

    AF.util.LibFilters:InitializeLibFilters()

    CreateSubfilterBars()
    InitializeHooks()
end
EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)