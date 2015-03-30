------------------------------------------------------------------
--AdvancedFilters.lua
--Author: ingeniousclown, Randactyl
--v0.7.7.0
 
--Advanced Filters adds a line of subfilters to the inventory
--screen.
------------------------------------------------------------------
local WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS

local g_currentInventoryType = INVENTORY_BACKPACK
local oldFilter = nil
 
local BAGS = ZO_PlayerInventoryBackpack
local BANK = ZO_PlayerBankBackpack
local GUILDBANK = ZO_GuildBankBackpack
 
local subfilterRows = {
	[ITEMFILTERTYPE_WEAPONS] = nil,
	[ITEMFILTERTYPE_ARMOR] = nil,
	[ITEMFILTERTYPE_CONSUMABLE] = nil,
	[ITEMFILTERTYPE_CRAFTING] = nil,
	[ITEMFILTERTYPE_MISCELLANEOUS] = nil
}

local queued = false

function ShowCurrentSubfilterRow()
	cur = subfilterRows[g_currentInventoryType]
	return cur
end

function GetCurrentInventoryType()
	return g_currentInventoryType
end

local function CheckSubfilters(subfilterRow)
	for _,v in ipairs(subfilterRow.subfilters) do
		v.texture:SetColor(.3, .3, .3, .9)
		v.isActive = false
	end
 
	for _,item in pairs(PLAYER_INVENTORY.inventories[GetCurrentInventoryType()].slots) do
		for _,filter in ipairs(subfilterRow.subfilters) do
			if(not filter.isActive and filter.button.filterCallback(item)) then
				filter.isActive = true
				filter.texture:SetColor(1, 1, 1, 1)
			end
		end
	end
end

local function GetCurrentSubfilterRow()
	return subfilterRows[g_currentInventoryType]
end

local function GuildBankReady()
	if(GetCurrentInventoryType() == INVENTORY_GUILD_BANK) then
		local subfilterRow = GetCurrentSubfilterRow()
		if subfilterRow then
			subfilterRow:ResetToAll()
			CheckSubfilters(subfilterRow)
		end
	end
	queued = false
end

local function QueueGuildBankUpdate()
	if queued == true then return end
	queued = true
	zo_callLater(function() GuildBankReady() end, 100)
end

local canUpdate = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true
}
local function UpdateInventoryFilters( bagId, slotIndex )
	local inventoryType = PLAYER_INVENTORY.bagToInventoryType[bagId]
	local pseudoSlot = {}
	local subfilterRow = GetCurrentSubfilterRow()
	pseudoSlot.bagId = bagId
	pseudoSlot.slotIndex = slotIndex
	if(inventoryType == GetCurrentInventoryType() and subfilterRow) then
		for _,filter in ipairs(subfilterRow.subfilters) do
			if(not filter.isActive and filter.button.filterCallback(pseudoSlot)) then
				filter.isActive = true
				filter.texture:SetColor(1, 1, 1, 1)
			end
		end
	end
	canUpdate[bagId] = true
end

local function InventorySlotUpdated( eventId, bagId, slotIndex )
	-- this is a simple way to buffer the event
	-- just wait 25ms before actually updating the filters so we can avoid
	-- doing this more than necessary
	-- and just in case, it's tracked separately per bag
	if(canUpdate[bagId]) then
		canUpdate[bagId] = false
		zo_callLater(function() UpdateInventoryFilters(bagId, slotIndex) end, 1000)
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

-- if there is a subfilter row defined for filterType, hides all rows except
-- the one and returns that row
-- otherwise hides all subfilter rows and returns nil
local function SwitchSubfilterRow(filterType)
	local activeRow = nil
	for k,v in pairs(subfilterRows) do
		if k == filterType then
			activeRow = v
			v.control:SetHidden(false)
		else
			v.control:SetHidden(true)
		end
	end
	return activeRow
end

local function SetFilterParent( parent )
	for k,v in pairs(subfilterRows) do
		v.control:SetParent(parent)
		v.control:ClearAnchors()
		v.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, v.offsetY)
	end
end

local function ChangeFilter( self, filterTab )
	local inventoryType = filterTab.inventoryType
	local inventory = PLAYER_INVENTORY.inventories[inventoryType]
 
	local newFilter = self:GetTabFilterInfo(inventoryType, filterTab)
	local subfilterRow = SwitchSubfilterRow(newFilter)
 
	if subfilterRow then
		subfilterRow:ResetToAll()
		CheckSubfilters(subfilterRow)
		UpdateInventoryAnchors(self, inventoryType, subfilterRow.control:GetHeight())
		oldFilter = subfilterRow
	else
		if oldFilter then oldFilter:ResetToAll() end
		UpdateInventoryAnchors(self, inventoryType, 0)
	end
end

local function AdvancedFilters_Loaded( eventCode, addOnName )
	if(addOnName ~= "AdvancedFilters") then return end
	EVENT_MANAGER:UnregisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED)
 
    ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilter)
 
	WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS = AdvancedFilters_InitAllFilters()
	subfilterRows[ITEMFILTERTYPE_WEAPONS] = WEAPONS
	subfilterRows[ITEMFILTERTYPE_ARMOR] = ARMOR
	subfilterRows[ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	subfilterRows[ITEMFILTERTYPE_CRAFTING] = MATERIALS
	subfilterRows[ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANOUS
 
	BAGS.inventoryType = INVENTORY_BACKPACK
	BANK.inventoryType = INVENTORY_BANK
	GUILDBANK.inventoryType = INVENTORY_GUILD_BANK
 
	local bagSearch = ZO_PlayerInventorySearchBox
	bagSearch:ClearAnchors()
	bagSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerInventory, TOPLEFT, 36, -8)
	bagSearch:SetHidden(false)
 
	local bankSearch = ZO_PlayerBankSearchBox
	bankSearch:ClearAnchors()
	bankSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerBank, TOPLEFT, 36, -8)
	bankSearch:SetHidden(false)
	bankSearch:SetWidth(bagSearch:GetWidth())
 
	local guildBankSearch = ZO_GuildBankSearchBox
	guildBankSearch:ClearAnchors()
	guildBankSearch:SetAnchor(BOTTOMLEFT, ZO_GuildBank, TOPLEFT, 36, -8)
	guildBankSearch:SetHidden(false)
	guildBankSearch:SetWidth(bagSearch:GetWidth())
 
	local function hookInventoryShown(control, inventoryType)
		local function onInventoryShown(control, hidden)
			g_currentInventoryType = inventoryType
 
			SetFilterParent(control)
 
			local inventory = PLAYER_INVENTORY.inventories[inventoryType]
			local subfilterRow = SwitchSubfilterRow(inventory.currentFilter)
 
			if subfilterRow then
				zo_callLater(function() subfilterRow:ResetToAll() end, 100)
				zo_callLater(function() CheckSubfilters(subfilterRow) end, 500)

				UpdateInventoryAnchors(PLAYER_INVENTORY, inventoryType, subfilterRow.control:GetHeight())
			else
				TemporaryFixForStaleFilter()
				UpdateInventoryAnchors(PLAYER_INVENTORY, inventoryType, 0)
			end
		end
		ZO_PreHookHandler(control, "OnEffectivelyShown", onInventoryShown)
	end
 
	hookInventoryShown(ZO_PlayerInventory, INVENTORY_BACKPACK)
	hookInventoryShown(ZO_PlayerBank, INVENTORY_BANK)
	hookInventoryShown(ZO_GuildBank, INVENTORY_GUILD_BANK)
 
	EVENT_MANAGER:RegisterForEvent("AdvancedFilters_InventorySlotUpdate", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, InventorySlotUpdated)
end

EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)