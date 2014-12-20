------------------------------------------------------------------
--AdvancedFilters.lua
--Author: ingeniousclown, Randactyl
--v0.8.0.0
 
--Advanced Filters adds a line of subfilters to the inventory
--screen.
------------------------------------------------------------------
--variable declaration
local WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS

local g_currentInventoryType = INVENTORY_BACKPACK --set in inventory hook

local BAGS = ZO_PlayerInventoryBackpack
local BANK = ZO_PlayerBankBackpack
local GUILDBANK = ZO_GuildBankBackpack

subfilterBars = {
	[ITEMFILTERTYPE_WEAPONS] = nil,
	[ITEMFILTERTYPE_ARMOR] = nil,
	[ITEMFILTERTYPE_CONSUMABLE] = nil,
	[ITEMFILTERTYPE_CRAFTING] = nil,
	[ITEMFILTERTYPE_MISCELLANEOUS] = nil
}

local lastSubfilterBar = nil

--global utilities
function GetCurrentInventoryType()
	return g_currentInventoryType
end

function ShowCurrentSubfilterGroup()
	local cur = subfilterGroups[g_currentInventoryType]
	return cur
end

--local functions
local function RefreshSubfilterBar(inventory, currentFilter)
	--hide old bar, if it exists
	if lastSubfilterBar then lastSubfilterBar:SetHidden(true) end

	--get new bar
	local subfilterBar = subfilterBars[currentFilter]

	--if subfilters don't exist, remove filters and return 0 for for inventory anchor displacement
	if subfilterBar == nil then 
		AdvancedFilterGroup_ResetToAll()
		return 0
	end

	--check buttons for availability
	for _,v in ipairs(subfilterBar.subfilters) do
		v.texture:SetColor(.3, .3, .3, .9)
		v.clickable = false
	end
 
	for _,item in pairs(inventory.slots) do
		for _,filter in ipairs(subfilterBar.subfilters) do
			if(not filter.clickable and filter.button.filterCallback(item)) then
				filter.clickable = true
				filter.texture:SetColor(1, 1, 1, 1)
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
	--d(("AF SetFilterParent '%s'"):format(parent:GetName()))
	for k,v in pairs(subfilterBars) do
		v.control:SetParent(parent)
		v.control:ClearAnchors()
		v.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, v.offsetY)
	end
end

local function UpdateInventoryAnchors(self, inventoryType, shiftY)
	local layoutData = self.appliedLayout or BACKPACK_DEFAULT_LAYOUT_FRAGMENT.layoutData
	--d(("AF UpdateInventoryAnchors '%s' shiftY %+d"):format(tostring(layoutData), shiftY))
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

	WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS = AdvancedFilters_InitAllFilters()
	subfilterBars[ITEMFILTERTYPE_WEAPONS] = WEAPONS
	subfilterBars[ITEMFILTERTYPE_ARMOR] = ARMOR
	subfilterBars[ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	subfilterBars[ITEMFILTERTYPE_CRAFTING] = MATERIALS
	subfilterBars[ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANOUS

	BAGS.inventoryType = INVENTORY_BACKPACK
	BANK.inventoryType = INVENTORY_BANK
	GUILDBANK.inventoryType = INVENTORY_GUILD_BANK

	local function hookInventoryShown(control, inventoryType)
		local function onInventoryShown(control, hidden)
			--d(("AF InventoryShown '%s'"):format(control.GetName()))
			g_currentInventoryType = inventoryType

			SetFilterParent(control)

			local inventory = PLAYER_INVENTORY.inventories[inventoryType]
			local offset = RefreshSubfilterBar(inventory, inventory.currentFilter)
			UpdateInventoryAnchors(PLAYER_INVENTORY, inventoryType, offset)
		end
		ZO_PreHookHandler(control, "OnEffectivelyShown", onInventoryShown)
	end

	hookInventoryShown(ZO_PlayerInventory, INVENTORY_BACKPACK)
	hookInventoryShown(ZO_PlayerBank, INVENTORY_BANK)
	hookInventoryShown(ZO_GuildBank, INVENTORY_GUILD_BANK)

	--EVENT_MANAGER:RegisterForEvent("AdvancedFilters_InventorySlotUpdate", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, InventorySlotUpdated)
end
EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)