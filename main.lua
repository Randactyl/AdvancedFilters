AdvancedFilters = {}
local AF = AdvancedFilters

AF.subfilterGroups = {
	[INVENTORY_BACKPACK] = {
		[ITEMFILTERTYPE_WEAPONS] = {},
		[ITEMFILTERTYPE_ARMOR] = {},
		[ITEMFILTERTYPE_CONSUMABLE] = {},
		[ITEMFILTERTYPE_CRAFTING] = {},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {},		
	},
	[INVENTORY_BANK] = {
		[ITEMFILTERTYPE_WEAPONS] = {},
		[ITEMFILTERTYPE_ARMOR] = {},
		[ITEMFILTERTYPE_CONSUMABLE] = {},
		[ITEMFILTERTYPE_CRAFTING] = {},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {},
	},
	[INVENTORY_GUILD_BANK] = {
		[ITEMFILTERTYPE_WEAPONS] = {},
		[ITEMFILTERTYPE_ARMOR] = {},
		[ITEMFILTERTYPE_CONSUMABLE] = {},
		[ITEMFILTERTYPE_CRAFTING] = {},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {},
	},
	[INVENTORY_CRAFT_BAG] = {
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
		[ITEMFILTERTYPE_WEAPONS] = {},
		[ITEMFILTERTYPE_ARMOR] = {},
		[ITEMFILTERTYPE_CONSUMABLE] = {},
		[ITEMFILTERTYPE_CRAFTING] = {},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {},
	}, --VENDOR_SELL
}

AF.currentInventoryType = INVENTORY_BACKPACK

local function InitializeHooks()
	local function RefreshSubfilterBar(currentFilter)
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

		--hide and update old bar, if it exists
		if subfilterGroup.lastSubfilterBar ~= nil then
			subfilterGroup.lastSubfilterBar:SetHidden(true)
		end

		--if new bar exists
		if subfilterBar then
			--set old bar reference
			subfilterGroup.lastSubfilterBar = subfilterBar

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
		end
	end

	--SCENE SHOWN HOOKS
	local function hookInventory(control, inventoryType)
		local function onInventoryShown(control, hidden)
			AF.currentInventoryType = inventoryType

			if inventoryType == 6 then
				AF.util.ThrottledUpdate("showVendorSellBar", 10,
				  RefreshSubfilterBar, STORE_WINDOW.currentFilter)
			else
				AF.util.ThrottledUpdate(
				  "showInventory" .. inventoryType .. "Bar", 10,
				  RefreshSubfilterBar,
				  PLAYER_INVENTORY.inventories[inventoryType].currentFilter)
			end
		end

		ZO_PreHookHandler(control, "OnEffectivelyShown", onInventoryShown)
	end
	hookInventory(ZO_PlayerInventory, INVENTORY_BACKPACK)
	hookInventory(ZO_PlayerBank, INVENTORY_BANK)
	hookInventory(ZO_GuildBank, INVENTORY_GUILD_BANK)
	hookInventory(ZO_CraftBag, INVENTORY_CRAFT_BAG)
	hookInventory(ZO_StoreWindow, 6)

	--PREHOOKS
	local function ChangeFilterInventory(self, filterTab)
		local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)
		
		if AF.currentInventoryType ~= 6 then
			AF.util.ThrottledUpdate(
			  "showInventory" .. AF.currentInventoryType .. "Bar", 10,
			  RefreshSubfilterBar, currentFilter)
		end
	end
	ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilterInventory)
	local function ChangeFilterVendor(self, filterTab)
		local currentFilter = filterTab.filterType
		
		AF.util.ThrottledUpdate("showVendorSellBar", 10, RefreshSubfilterBar,
		  currentFilter)
		
		AF.util.ThrottledUpdate("changeFilterVendor", 10,
		  AF.util.RefreshSubfilterGroup, 6)
	end
	ZO_PreHook(STORE_WINDOW, "ChangeFilter", ChangeFilterVendor)

	--POSTHOOKS
	--create private index
	--this is my table. There are many like it, but this one is mine.
    local index = {}
    --create metatable
    local mt = {
		__index = function(t, k)
        	--d("*access to element " .. tostring(k))
        	return t[index][k]   -- access the original table
    	end,
    	__newindex = function(t, k, v)
        	--d("*update of element " .. tostring(k) .. " to " .. tostring(v))
        	t[index][k] = v   -- update original table
			--refresh subfilters for inventory type
			AF.util.ThrottledUpdate("isDirtyRefresh", 10, AF.util.RefreshSubfilterGroup, k)
    	end,
    }
	--tracking function. Returns a proxy table with our metatable attached.
	local function track(t)
		local proxy = {}
		proxy[index] = t
		setmetatable(proxy, mt)
		return proxy
    end
	--PLAYER_INVENTORY.isListDirty doesn't "exist" in the first place.
	--The table in the backing class was being used, so we'll track that table,
	--	but set the proxy to the lookup point.
	PLAYER_INVENTORY.isListDirty = track(ZO_InventoryManager.isListDirty)
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
		[ITEMFILTERTYPE_WEAPONS] = "Weapons",
		[ITEMFILTERTYPE_ARMOR] = "Armor",
		[ITEMFILTERTYPE_CONSUMABLE] = "Consumables",
		[ITEMFILTERTYPE_CRAFTING] = "Crafting",
		[ITEMFILTERTYPE_MISCELLANEOUS] = "Miscellaneous",
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
		[ITEMFILTERTYPE_WEAPONS] = {
			"HealStaff", "DestructionStaff", "Bow", "TwoHand", "OneHand", "All",
		},
		[ITEMFILTERTYPE_ARMOR] = {
			"Vanity", "Jewelry", "Shield", "Clothing", "Light", "Medium",
			"Heavy", "All",
		},
		[ITEMFILTERTYPE_CONSUMABLE] = {
			"Trophy", "Repair", "Container", "Motif", "Poison", "Potion",
			"Recipe", "Drink", "Food", "Crown", "All",
		},
		[ITEMFILTERTYPE_CRAFTING] = {
			"WeaponTrait", "ArmorTrait", "Style", "Provisioning", "Enchanting",
			"Alchemy", "Woodworking", "Clothier", "Blacksmithing", "All",
		},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {
			"Trash", "Fence", "Trophy", "Tool", "Bait", "Siege", "SoulGem",
			"Glyphs", "All",
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
			"OldIngredient", "DrinkIngredient", "FoodIngredient", "All",
		},
		[ITEMFILTERTYPE_STYLE_MATERIALS] = {
			"CrownStyle", "ExoticStyle", "AllianceStyle", "RareStyle",
			"NormalStyle", "RawMaterial", "All",
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

	CreateSubfilterBars()
	InitializeHooks()
end
EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)