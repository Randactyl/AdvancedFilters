AdvancedFilters = {}
local AF = AdvancedFilters

AF.subfilterGroups = {
	[INVENTORY_BACKPACK] = {},
	[INVENTORY_BANK] = {},
	[INVENTORY_GUILD_BANK] = {},
	--[5] = {},
}
AF.lastSubfilterBar = nil

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
		subfilterBars = AF.subfilterGroups[AF.currentInventoryType]
		local subfilterBar = subfilterBars[currentFilter]

		--hide old bar, if it exists
		if AF.lastSubfilterBar ~= nil then AF.lastSubfilterBar:SetHidden(true) end

		--refresh button availibility
		AF.util.RefreshSubfilterButtons(subfilterBar)
		AF.util.RefreshSubfilterButtons(AF.lastSubfilterBar)

		--set old bar reference
		AF.lastSubfilterBar = subfilterBar

		--if subfilters don't exist, remove filters and remove inventory anchor displacement
		if subfilterBar == nil then
			AF.util.RemoveAllFilters()
			if AF.currentInventoryType == 5 then
				UpdateListAnchors(STORE_WINDOW, 0)
			else
				UpdateListAnchors(PLAYER_INVENTORY, 0)
			end
		else
			--set currentFilter since we need it before the original ChangeFilter updates it
			if AF.currentInventoryType == 5 then
				STORE_WINDOW.currentFilter = currentFilter
			else
				PLAYER_INVENTORY.inventories[AF.currentInventoryType].currentFilter = currentFilter
			end

			--activate current button
			subfilterBar:ActivateButton(subfilterBar:GetCurrentButton())

			--show the bar
			subfilterBar:SetHidden(false)

			--set proper inventory anchor displacement
			if AF.currentInventoryType == 5 then
				UpdateListAnchors(STORE_WINDOW, subfilterBar.control:GetHeight())
			else
				UpdateListAnchors(PLAYER_INVENTORY, subfilterBar.control:GetHeight())
			end
		end
	end

	local function hookInventory(control, inventoryType)
		local function onInventoryShown(control, hidden)
			AF.currentInventoryType = inventoryType

			if inventoryType == 5 then
				RefreshSubfilterBar(STORE_WINDOW.currentFilter)
			else
				RefreshSubfilterBar(PLAYER_INVENTORY.inventories[inventoryType].currentFilter)
			end
		end

		ZO_PreHookHandler(control, "OnEffectivelyShown", onInventoryShown)
	end
	hookInventory(ZO_PlayerInventory, INVENTORY_BACKPACK)
	hookInventory(ZO_PlayerBank, INVENTORY_BANK)
	hookInventory(ZO_GuildBank, INVENTORY_GUILD_BANK)
	hookInventory(ZO_StoreWindow, 5)

	local function ChangeFilterInventory(self, filterTab)
		local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)
		RefreshSubfilterBar(currentFilter)
	end
	ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilterInventory)
	local function ChangeFilterStore(self, filterTab)
		local currentFilter = filterTab.filterType
		RefreshSubfilterBar(currentFilter)
	end
	ZO_PreHook(STORE_WINDOW, "ChangeFilter", ChangeFilterStore)
end

local function CreateSubfilterBars()
	local inventoryTypes = {
		["PlayerInventory"] = INVENTORY_BACKPACK,
		["PlayerBank"] = INVENTORY_BANK,
		["GuildBank"] = INVENTORY_GUILD_BANK,
		--["StoreWindow"] = 5,
	}
	local filterTypes = {
		["Weapons"] = ITEMFILTERTYPE_WEAPONS,
		["Armor"] = ITEMFILTERTYPE_ARMOR,
		["Consumables"] = ITEMFILTERTYPE_CONSUMABLE,
		["Crafting"] = ITEMFILTERTYPE_CRAFTING,
		["Miscellaneous"] = ITEMFILTERTYPE_MISCELLANEOUS,
	}
	local subfilterGroups = {
		[ITEMFILTERTYPE_WEAPONS] = {
			"HealStaff", "DestructionStaff", "Bow", "TwoHand", "OneHand", "All",
		},
		[ITEMFILTERTYPE_ARMOR] = {
			"Vanity", "Jewelry", "Shield", "Clothing", "Light", "Medium",
			"Heavy", "All",
		},
		[ITEMFILTERTYPE_CONSUMABLE] = {
			"Trophy", "Repair", "Container", "Motif", --[["Poison",]] "Potion",
			"Recipe", "Drink", "Food", "Crown", "All",
		},
		[ITEMFILTERTYPE_CRAFTING] = {
			"ArmorTrait", "WeaponTrait", "Style", "Provisioning", "Enchanting",
			"Alchemy", "Woodworking", "Clothier", "Blacksmithing", "All",
		},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {
			"Trash", "Fence", "Trophy", "Tool", "Bait", "Siege", "SoulGem",
			"Glyphs", "All",
		},
	}

	for inventoryName, inventoryType in pairs(inventoryTypes) do
		for groupName, filterType in pairs(filterTypes) do
			local subfilterNames = subfilterGroups[filterType]

			AF.subfilterGroups[inventoryType][filterType] = AF.AF_FilterBar:New(inventoryName, groupName, subfilterNames)
		end
	end
end

local function AdvancedFilters_Loaded(eventCode, addonName)
	if addonName ~= "AdvancedFilters" then return end
	EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)

	--enable ZOS inventory search boxes
	local bagSearch = ZO_PlayerInventorySearchBox
	local bankSearch = ZO_PlayerBankSearchBox
	local guildBankSearch = ZO_GuildBankSearchBox

	bagSearch:ClearAnchors()
	bagSearch:SetAnchor(RIGHT, ZO_PlayerInventoryMenuBarLabel, LEFT, -5)
	bagSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerInventoryMenuDivider, TOPLEFT, 0, -11)
	bagSearch:SetHidden(false)

	bankSearch:ClearAnchors()
	bankSearch:SetAnchor(RIGHT, ZO_PlayerBankMenuBarLabel, LEFT, -5)
	bankSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerBankMenuDivider, TOPLEFT, 0, -11)
	bankSearch:SetHidden(false)
	bankSearch:SetWidth(bagSearch:GetWidth())

	guildBankSearch:ClearAnchors()
	guildBankSearch:SetAnchor(RIGHT, ZO_GuildBankMenuBarLabel, LEFT, -5)
	guildBankSearch:SetAnchor(BOTTOMLEFT, ZO_GuildBankMenuDivider, TOPLEFT, 0, -11)
	guildBankSearch:SetHidden(false)
	guildBankSearch:SetWidth(bagSearch:GetWidth())

	CreateSubfilterBars()

	InitializeHooks()
end
EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)
