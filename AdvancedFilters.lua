--variable declaration
local g_currentInventoryType = INVENTORY_BACKPACK --set in inventory hook
local allSubfilterBars = {
	[INVENTORY_BACKPACK] = {
		[ITEMFILTERTYPE_WEAPONS] = nil,
		[ITEMFILTERTYPE_ARMOR] = nil,
		[ITEMFILTERTYPE_CONSUMABLE] = nil,
		[ITEMFILTERTYPE_CRAFTING] = nil,
		[ITEMFILTERTYPE_MISCELLANEOUS] = nil,
		lastSubfilterBar = nil,
	},
	[INVENTORY_BANK] = {},
	[INVENTORY_GUILD_BANK] = {},
}
local subfilterBars = {}

local function SetFilterParents()
	local parent = ZO_PlayerInventory
	for _, v in pairs(allSubfilterBars[INVENTORY_BACKPACK]) do
		v.control:SetParent(parent)
		v.control:ClearAnchors()
		v.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, v.offsetY)
	end

	parent = ZO_PlayerBank
	for _, v in pairs(allSubfilterBars[INVENTORY_BANK]) do
		v.control:SetParent(parent)
		v.control:ClearAnchors()
		v.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, v.offsetY)
	end

	parent = ZO_GuildBank
	for _, v in pairs(allSubfilterBars[INVENTORY_GUILD_BANK]) do
		v.control:SetParent(parent)
		v.control:ClearAnchors()
		v.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, v.offsetY)
	end
end

local function RefreshSubfilterBar(currentFilter)
	local function UpdateInventoryAnchors(self, inventoryType, shiftY)
		local layoutData = self.appliedLayout or BACKPACK_DEFAULT_LAYOUT_FRAGMENT.layoutData
		if not layoutData then return end

		local inventory = self.inventories[inventoryType]
		local backpack = inventory.listView
		backpack:SetWidth(layoutData.width)
		backpack:ClearAnchors()
		backpack:SetAnchor(TOPRIGHT, nil, TOPRIGHT, 0, layoutData.backpackOffsetY + shiftY)
		backpack:SetAnchor(BOTTOMRIGHT)

		ZO_ScrollList_SetHeight(backpack, backpack:GetHeight())

		local displayInventory = self:GetDisplayInventoryTable(inventoryType)
		local sortBy = displayInventory.sortHeaders.headerContainer
		sortBy:ClearAnchors()
		sortBy:SetAnchor(TOPRIGHT, nil, TOPRIGHT, 0, layoutData.sortByOffsetY + shiftY)
	end

	--get new bar
	subfilterBars = allSubfilterBars[g_currentInventoryType]
	local subfilterBar = subfilterBars[currentFilter]

	--hide old bar, if it exists
	if subfilterBars.lastSubfilterBar then subfilterBars.lastSubfilterBar:SetHidden(true) end

	--set old bar reference
	subfilterBars.lastSubfilterBar = subfilterBar

	--if subfilters don't exist, remove filters and remove inventory anchor displacement
	if subfilterBar == nil then
		AdvancedFilterGroup_RemoveAllFilters()
		UpdateInventoryAnchors(PLAYER_INVENTORY, g_currentInventoryType, 0)
	else
		--set currentFilter since we need it before the original ChangeFilter updates it
		PLAYER_INVENTORY.inventories[g_currentInventoryType].currentFilter = currentFilter

		--activate current button
		subfilterBar:ActivateButton(subfilterBar:GetCurrentButton())

		--show the bar
		subfilterBar:SetHidden(false)

		--set proper inventory anchor displacement
		UpdateInventoryAnchors(PLAYER_INVENTORY, g_currentInventoryType, subfilterBar.control:GetHeight())
	end
end

local function ChangeFilter(self, filterTab)
	local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)
	RefreshSubfilterBar(currentFilter)
end

local function InitializeGroups()
	local inventoryTypes = {
		["Inventory"] = INVENTORY_BACKPACK,
		["Bank"] = INVENTORY_BANK,
		["GuildBank"] = INVENTORY_GUILD_BANK,
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
			[1] = "HealStaff",
			[2] = "DestructionStaff",
			[3] = "Bow",
			[4] = "TwoHand",
			[5] = "OneHand",
			[6] = "All",
		},
		[ITEMFILTERTYPE_ARMOR] = {
			[1] = "Vanity",
			[2] = "Jewelry",
			[3] = "Shield",
			[4] = "Clothing",
			[5] = "Light",
			[6] = "Medium",
			[7] = "Heavy",
			[8] = "All",
		},
		[ITEMFILTERTYPE_CONSUMABLE] = {
			[1] = "Trophy",
			[2] = "Repair",
			[3] = "Container",
			[4] = "Motif",
			[5] = "Poison",
			[6] = "Potion",
			[7] = "Recipe",
			[8] = "Drink",
			[9] = "Food",
			[10] = "Crown",
			[11] = "All",
		},
		[ITEMFILTERTYPE_CRAFTING] = {
			[1] = "ArmorTrait",
			[2] = "WeaponTrait",
			[3] = "Style",
			[4] = "Provisioning",
			[5] = "Enchanting",
			[6] = "Alchemy",
			[7] = "Woodworking",
			[8] = "Clothier",
			[9] = "Blacksmithing",
			[10] = "All",
		},
		[ITEMFILTERTYPE_MISCELLANEOUS] = {
			[1] = "Trash",
			[2] = "Fence",
			[3] = "Trophy",
			[4] = "Tool",
			[5] = "Bait",
			[6] = "Siege",
			[7] = "SoulGem",
			[8] = "Glyphs",
			[9] = "All",
		},
	}
	local inventoryType = inventoryTypes[inventoryName]
	local filterType = filterTypes[groupName]
	local subfilterNames = subfilterGroups[filterType]

	for inventoryName, inventoryType in pairs(inventoryTypes) do
		for groupName, filterType in pairs(filterTypes) do
			local subfilterNames = subfilterGroups[filterType]

			allSubfilterBars[inventoryType][filterType] = AdvancedFilterGroup:New(inventoryName, groupName, subfilterNames)
		end
	end
end

local function AdvancedFilters_Loaded(eventCode, addonName)
	if addonName ~= "AdvancedFilters" then return end
	EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)

	ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilter)

	InitializeGroups()

	SetFilterParents()

	local function hookInventory(control, inventoryType)
		local function onInventoryShown(control, hidden)
			g_currentInventoryType = inventoryType

			RefreshSubfilterBar(PLAYER_INVENTORY.inventories[inventoryType].currentFilter)
		end

		ZO_PreHookHandler(control, "OnEffectivelyShown", onInventoryShown)
	end

	hookInventory(ZO_PlayerInventory, INVENTORY_BACKPACK)
	hookInventory(ZO_PlayerBank, INVENTORY_BANK)
	hookInventory(ZO_GuildBank, INVENTORY_GUILD_BANK)

	--enable ZOS inventory search boxes
	local bagSearch = ZO_PlayerInventorySearchBox
	local bankSearch = ZO_PlayerBankSearchBox
	local guildBankSearch = ZO_GuildBankSearchBox

	bagSearch:ClearAnchors()
	bagSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerInventory, TOPLEFT, 36, -8)
	bagSearch:SetHidden(false)

	bankSearch:ClearAnchors()
	bankSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerBank, TOPLEFT, 36, -8)
	bankSearch:SetHidden(false)
	bankSearch:SetWidth(bagSearch:GetWidth())

	guildBankSearch:ClearAnchors()
	guildBankSearch:SetAnchor(BOTTOMLEFT, ZO_GuildBank, TOPLEFT, 36, -8)
	guildBankSearch:SetHidden(false)
	guildBankSearch:SetWidth(bagSearch:GetWidth())
end

EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)

--[[GLOBAL FUNCTIONS]]----------------------------------------------------------
--these are only inteded for use internally

function GetCurrentInventoryType()
	return g_currentInventoryType
end

function AdvancedFilters_RefreshSubfilterButtons(subfilterBar, currentFilter)
	local inventory = PLAYER_INVENTORY.inventories[g_currentInventoryType]
	subfilterBar = subfilterBar or subfilterBars.lastSubfilterBar


	--check buttons for availability
	for _, button in ipairs(subfilterBar.subfilters) do
		button.texture:SetColor(.3, .3, .3, .9)
		button:SetEnabled(false)
		button.clickable = false
	end
	for _, item in pairs(inventory.slots) do
		if item.dataEntry and item.dataEntry.data then
			local itemData = item.dataEntry.data
			for _, button in ipairs(subfilterBar.subfilters) do
				if((not button.clickable) and button.filterCallback(item)
				  and (item.dataEntry.data.filterData[1] == inventory.currentFilter)) then
					button.texture:SetColor(1, 1, 1, 1)
					button:SetEnabled(true)
					button.clickable = true
				end
			end
		end
	end
end
--[[END GLOBAL FUNCTIONS]]------------------------------------------------------
