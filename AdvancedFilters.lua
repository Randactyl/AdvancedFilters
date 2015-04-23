------------------------------------------------------------------
--AdvancedFilters.lua
--Author: ingeniousclown, Randactyl
--v0.8.0.0
 
--Advanced Filters adds a line of subfilters to the inventory
--screen.
------------------------------------------------------------------
--variable declaration
local g_currentInventoryType = INVENTORY_BACKPACK --set in inventory hook

local BAGS = ZO_PlayerInventoryBackpack
local BANK = ZO_PlayerBankBackpack
local GUILDBANK = ZO_GuildBankBackpack

subfilterBars = {
	[ITEMFILTERTYPE_WEAPONS] = nil,
	[ITEMFILTERTYPE_ARMOR] = nil,
	[ITEMFILTERTYPE_CONSUMABLE] = nil,
	[ITEMFILTERTYPE_CRAFTING] = nil,
	[ITEMFILTERTYPE_MISCELLANEOUS] = nil,
}

local lastSubfilterBar = nil

--global utilities
function GetCurrentInventoryType()
	return g_currentInventoryType
end

--local functions
local function RefreshSubfilterBar(inventory, currentFilter)
	--hide old bar, if it exists
	if lastSubfilterBar then lastSubfilterBar:SetHidden(true) end

	--get new bar
	local subfilterBar = subfilterBars[currentFilter]

	--if subfilters don't exist, remove filters and return 0 for for inventory anchor displacement
	if subfilterBar == nil then
		AdvancedFilterGroup_RemoveAllFilters()
		return 0
	end

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

	--set old bar reference and return proper inventory anchor displacement
	lastSubfilterBar = subfilterBar
	return subfilterBar.control:GetHeight()
end

local function SetFilterParent(parent)
	for k,v in pairs(subfilterBars) do
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

local function ChangeFilter(self, filterTab)
	local inventory = PLAYER_INVENTORY.inventories[g_currentInventoryType]
	local currentFilter = self:GetTabFilterInfo(filterTab.inventoryType, filterTab)

	local offset = RefreshSubfilterBar(inventory, currentFilter)
	UpdateInventoryAnchors(PLAYER_INVENTORY, g_currentInventoryType, offset)
end

local function AdvancedFilters_Loaded(eventCode, addonName)
	if addonName ~= "AdvancedFilters" then return end
	EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)

	ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilter)

	local WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS = AdvancedFilters_InitAllFilters()
	subfilterBars[ITEMFILTERTYPE_WEAPONS] = WEAPONS
	subfilterBars[ITEMFILTERTYPE_ARMOR] = ARMOR
	subfilterBars[ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	subfilterBars[ITEMFILTERTYPE_CRAFTING] = MATERIALS
	subfilterBars[ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANOUS

	BAGS.inventoryType = INVENTORY_BACKPACK
	BANK.inventoryType = INVENTORY_BANK
	GUILDBANK.inventoryType = INVENTORY_GUILD_BANK

	local function hookInventory(control, inventoryType)
		local function onInventoryShown(control, hidden)
			g_currentInventoryType = inventoryType

			SetFilterParent(control)

			local inventory = PLAYER_INVENTORY.inventories[inventoryType]
			local offset = RefreshSubfilterBar(inventory, inventory.currentFilter)
			UpdateInventoryAnchors(PLAYER_INVENTORY, inventoryType, offset)
		end
		local function onInventoryHidden(control, hidden)
			local inventory = PLAYER_INVENTORY.inventories[inventoryType]
			local subfilterBar = subfilterBars[inventory.currentFilter]
			--do something?
		end
		ZO_PreHookHandler(control, "OnEffectivelyShown", onInventoryShown)
		ZO_PreHookHandler(control, "OnEffectivelyHidden", onInventoryHidden)
	end

	hookInventory(ZO_PlayerInventory, INVENTORY_BACKPACK)
	hookInventory(ZO_PlayerBank, INVENTORY_BANK)
	hookInventory(ZO_GuildBank, INVENTORY_GUILD_BANK)
end
EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)