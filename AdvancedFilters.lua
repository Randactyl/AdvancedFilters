--variable declaration
local g_currentInventoryType = INVENTORY_BACKPACK --set in inventory hook
local bagSearch = ZO_PlayerInventorySearchBox --reference to ZOS text search box
local bankSearch = ZO_PlayerBankSearchBox --reference to ZOS text search box
local guildBankSearch = ZO_GuildBankSearchBox --reference to ZOS text search box

allSubfilterBars = {
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
subfilterBars = {}

--global utilities
function GetCurrentInventoryType()
	return g_currentInventoryType
end

--local functions
--assign parent for each subfilter bar
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

local function RefreshSubfilterBar(currentFilter)
	local inventory = PLAYER_INVENTORY.inventories[g_currentInventoryType]

	subfilterBars = allSubfilterBars[g_currentInventoryType]

	--hide old bar, if it exists
	if subfilterBars.lastSubfilterBar then subfilterBars.lastSubfilterBar:SetHidden(true) end

	--get new bar
	local subfilterBar = subfilterBars[currentFilter]

	--if subfilters don't exist, remove filters and remove inventory anchor displacement
	if subfilterBar == nil then
		AdvancedFilterGroup_RemoveAllFilters()
		UpdateInventoryAnchors(PLAYER_INVENTORY, g_currentInventoryType, 0)
	else
		--check buttons for availability
		for _,button in ipairs(subfilterBar.subfilters) do
			button.texture:SetColor(.3, .3, .3, .9)
			button:SetEnabled(false)
			button.clickable = false
		end
		for _,item in pairs(inventory.slots) do
			for _,button in ipairs(subfilterBar.subfilters) do
				if(not button.clickable and button.filterCallback(item)) then
					button.texture:SetColor(1, 1, 1, 1)
					button:SetEnabled(true)
					button.clickable = true
				end
			end
		end

		--activate current button
		subfilterBar:ActivateButton(subfilterBar:GetCurrentButton())
		--show the bar
		subfilterBar:SetHidden(false)

		--set old bar reference and set proper inventory anchor displacement
		subfilterBars.lastSubfilterBar = subfilterBar
		UpdateInventoryAnchors(PLAYER_INVENTORY, g_currentInventoryType, subfilterBar.control:GetHeight())
	end
end

local function ChangeFilter(self, filterTab)
	local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)
	RefreshSubfilterBar(currentFilter)
end

local function AdvancedFilters_Loaded(eventCode, addonName)
	if addonName ~= "AdvancedFilters" then return end
	EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)

	ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilter)

	local WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANEOUS = AdvancedFilters_InitAllFilters("Inventory")
	allSubfilterBars[INVENTORY_BACKPACK][ITEMFILTERTYPE_WEAPONS] = WEAPONS
	allSubfilterBars[INVENTORY_BACKPACK][ITEMFILTERTYPE_ARMOR] = ARMOR
	allSubfilterBars[INVENTORY_BACKPACK][ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	allSubfilterBars[INVENTORY_BACKPACK][ITEMFILTERTYPE_CRAFTING] = MATERIALS
	allSubfilterBars[INVENTORY_BACKPACK][ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANEOUS

	WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANEOUS = AdvancedFilters_InitAllFilters("Bank")
	allSubfilterBars[INVENTORY_BANK][ITEMFILTERTYPE_WEAPONS] = WEAPONS
	allSubfilterBars[INVENTORY_BANK][ITEMFILTERTYPE_ARMOR] = ARMOR
	allSubfilterBars[INVENTORY_BANK][ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	allSubfilterBars[INVENTORY_BANK][ITEMFILTERTYPE_CRAFTING] = MATERIALS
	allSubfilterBars[INVENTORY_BANK][ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANEOUS

	WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANEOUS = AdvancedFilters_InitAllFilters("GuildBank")
	allSubfilterBars[INVENTORY_GUILD_BANK][ITEMFILTERTYPE_WEAPONS] = WEAPONS
	allSubfilterBars[INVENTORY_GUILD_BANK][ITEMFILTERTYPE_ARMOR] = ARMOR
	allSubfilterBars[INVENTORY_GUILD_BANK][ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	allSubfilterBars[INVENTORY_GUILD_BANK][ITEMFILTERTYPE_CRAFTING] = MATERIALS
	allSubfilterBars[INVENTORY_GUILD_BANK][ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANEOUS

	AdvancedFilters_DestroyAFCallbacks()

	SetFilterParents()

	ZO_PlayerInventoryBackpack.inventoryType = INVENTORY_BACKPACK
	ZO_PlayerBankBackpack.inventoryType = INVENTORY_BANK
	ZO_GuildBankBackpack.inventoryType = INVENTORY_GUILD_BANK

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
