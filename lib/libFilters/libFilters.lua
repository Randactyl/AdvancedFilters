local MAJOR, MINOR = "libFilters", 16
local libFilters, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not libFilters then return end	--the same or newer version of this lib is already loaded into memory
--thanks to Seerah for the previous lines and library

--some constants for your filters
LAF_BAGS = 1
LAF_BANK = 2
LAF_GUILDBANK = 3
LAF_STORE = 4
LAF_DECONSTRUCTION = 5
LAF_GUILDSTORE = 6
LAF_MAIL = 7
LAF_TRADE = 8
LAF_ENCHANTING_CREATION = 11
LAF_ENCHANTING_EXTRACTION = 12
LAF_IMPROVEMENT = 13
LAF_FENCE = 14
LAF_LAUNDER = 15
LAF_ALCHEMY = 16

libFilters.filters = {
	[LAF_BAGS] = {},
	[LAF_BANK] = {},
	[LAF_GUILDBANK] = {},
	[LAF_STORE] = {},
	[LAF_DECONSTRUCTION] = {},
	[LAF_GUILDSTORE] = {},
	[LAF_MAIL] = {},
	[LAF_TRADE] = {},
	[LAF_ENCHANTING_CREATION] = {},
	[LAF_ENCHANTING_EXTRACTION] = {},
	[LAF_IMPROVEMENT] = {},
	[LAF_FENCE] = {},
	[LAF_LAUNDER] = {},
	[LAF_ALCHEMY] = {},
}
local filters = libFilters.filters

local enchantingModeToFilterType = {
	[ENCHANTING_MODE_CREATION] = LAF_ENCHANTING_CREATION,
	[ENCHANTING_MODE_EXTRACTION] = LAF_ENCHANTING_EXTRACTION,
}

local filterTypeToUpdaterName = {
	[LAF_BAGS] = "BACKPACK",
	[LAF_BANK] = "BANK",
	[LAF_GUILDBANK] = "GUILD_BANK",
	[LAF_STORE] = "BACKPACK",
	[LAF_DECONSTRUCTION] = "DECONSTRUCTION",
	[LAF_GUILDSTORE] = "BACKPACK",
	[LAF_MAIL] = "BACKPACK",
	[LAF_TRADE] = "BACKPACK",
	[LAF_ENCHANTING_CREATION] = "ENCHANTING",
	[LAF_ENCHANTING_EXTRACTION] = "ENCHANTING",
	[LAF_IMPROVEMENT] = "IMPROVEMENT",
	[LAF_FENCE] = "BACKPACK",
	[LAF_LAUNDER] = "BACKPACK",
	[LAF_ALCHEMY] = "ALCHEMY",
}

local inventoryUpdaters = {
	BACKPACK = function()
		PLAYER_INVENTORY:UpdateList(INVENTORY_BACKPACK)
	end,
	BANK = function()
		PLAYER_INVENTORY:UpdateList(INVENTORY_BANK)
	end,
	GUILD_BANK = function()
		PLAYER_INVENTORY:UpdateList(INVENTORY_GUILD_BANK)
	end,
	DECONSTRUCTION = function()
		SMITHING.deconstructionPanel.inventory:HandleDirtyEvent()
	end,
	IMPROVEMENT = function()
		SMITHING.improvementPanel.inventory:HandleDirtyEvent()
	end,
	ENCHANTING = function()
		ENCHANTING.inventory:HandleDirtyEvent()
	end,
	ALCHEMY = function()
		ALCHEMY.inventory:Refresh()
	end,
}

local function df(...)
	d(string.format(...))
end

local function runFilters(filterType, ...)
	for tag, filter in pairs(filters[filterType]) do
		if not filter(...) then
			return false
		end
	end
	return true
end

--LAF_DECONSTRUCTION
--since this is a PreHook using ZO_PreHook, a return of true means don't add
local function DeconstructionFilter(self, bagId, slotIndex, ...)
	return not runFilters(LAF_DECONSTRUCTION, bagId, slotIndex)
end

--LAF_IMPROVEMENT
--since this is a PreHook using ZO_PreHook, a return of true means don't add
local function ImprovementFilter(self, bagId, slotIndex, ...)
	return not runFilters(LAF_IMPROVEMENT, bagId, slotIndex)
end

--LAF_ENCHANTING
--since this is a PreHook using ZO_PreHook, a return of true means don't add
local function EnchantingFilter(self, bagId, slotIndex, ...)
	local filterType = enchantingModeToFilterType[ENCHANTING.enchantingMode]
	return filterType and not runFilters(filterType, bagId, slotIndex)
end

--LAF_ALCHEMY
--since this is a PreHook using ZO_PreHook, a return of true means don't add
local function AlchemyFilter(self, bagId, slotIndex, ...)
	return not runFilters(LAF_ALCHEMY, bagId, slotIndex)
end

-- _inventory_ should be one of:
--  a) backpack layout fragment with .layoutData
--  b) inventory table from PLAYER_INVENTORY.inventories
function libFilters:HookAdditionalFilter(filterType, inventory)
    --lazily initialize the add-on
    if(not self.IS_INITIALIZED) then self:InitializeLibFilters() end

    local layoutData = inventory.layoutData or inventory
	local originalFilter = layoutData.additionalFilter

	layoutData.libFilters_filterType = filterType

	if type(originalFilter) == "function" then
		layoutData.additionalFilter = function(slot)
			return originalFilter(slot) and runFilters(filterType, slot)
		end
	else
		layoutData.additionalFilter = function(slot)
			return runFilters(filterType, slot)
		end
	end
end

function libFilters:RequestInventoryUpdate(filterType)
	local updaterName = filterTypeToUpdaterName[filterType]
	local callbackName = "libFilters_updateInventory_" .. updaterName
	-- cancel previously scheduled update if any
	EVENT_MANAGER:UnregisterForUpdate(callbackName)
	--register a new one
	EVENT_MANAGER:RegisterForUpdate(callbackName, 10, function()
		EVENT_MANAGER:UnregisterForUpdate(callbackName)
		inventoryUpdaters[updaterName]()

		--d("inventoryUpdater Running: "..tostring(updaterName))
	end)
end

--filterCallback must be a function with parameter (slot) and return true/false
function libFilters:RegisterFilter(filterTag, filterType, filterCallback)
	--lazily initialize the library
	if(not self.IS_INITIALIZED) then self:InitializeLibFilters() end

	local callbacks = filters[filterType]

	if not filterTag or not callbacks or type(filterCallback) ~= "function" then
		df("libFilters: invalid arguments to RegisterFilter (%q, %s, %s)",
			tostring(filterTag), tostring(filterType), tostring(filterCallback))
		return
	end

	if callbacks[filterTag] ~= nil then
		df("libFilters: %q filterType %s is already in use",
			tostring(filterTag), tostring(filterType))
		return
	end

	--d("registered "..filterTag)
	callbacks[filterTag] = filterCallback
end

function libFilters:UnregisterFilter(filterTag, filterType)
	--lazily initialize the add-on
	if(not self.IS_INITIALIZED) then self:InitializeLibFilters() end

	if filterType == nil then
		-- unregister all filters with this tag
		for filterType, callbacks in pairs(filters) do
			if callbacks[filterTag] ~= nil then
				callbacks[filterTag] = nil
			end
		end
	else
		-- unregister only the specified filter type
		local callbacks = filters[filterType]
		if callbacks[filterTag] ~= nil then
			callbacks[filterTag] = nil
		end
	end

	--d("unregistered "..filterTag)
end

function libFilters:IsFilterRegistered(filterTag, filterType)
	if filterType == nil then
		-- check whether there's any filter with this tag
		for filterType, callbacks in pairs(filters) do
			if callbacks[filterTag] ~= nil then
				return true
			end
		end
		return false
	else
		-- check only the specified filter type
		local callbacks = filters[filterType]
		return callbacks[filterTag] ~= nil
	end
end

function libFilters:GetCurrentLAF(inventoryType)
	local inventory = PLAYER_INVENTORY.inventories[inventoryType]
	local layoutData = PLAYER_INVENTORY.appliedLayout

	if inventoryType == INVENTORY_BACKPACK then
		if layoutData and layoutData.libFilters_filterType then
			return layoutData.libFilters_filterType
		end
	end

	return inventory.libFilters_filterType
end

function libFilters:InventoryTypeToLAF(inventoryType)
	if(inventoryType == INVENTORY_BACKPACK) then
		return LAF_BAGS
	elseif(inventoryType == INVENTORY_BANK) then
		return LAF_BANK
	elseif(inventoryType == INVENTORY_GUILD_BANK) then
		return LAF_GUILDBANK
	end

	return 0
end

function libFilters:BagIdToLAF(bagId)
	if(bagId == BAG_BACKPACK) then
		return LAF_BAGS
	elseif(bagId == BAG_BANK) then
		return LAF_BANK
	elseif(bagId == BAG_GUILDBANK) then
		return LAF_GUILDBANK
	end

	return 0
end

function libFilters:InitializeLibFilters()
	if self.IS_INITIALIZED then return end
	self.IS_INITIALIZED = true

	-- PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK].additionalFilter
	-- is reset every time a different backpack layout fragment is shown,
	-- therefore it needs to be hooked in each fragment's layout data
	self:HookAdditionalFilter(LAF_BAGS, PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK])
	self:HookAdditionalFilter(LAF_BAGS, BACKPACK_MENU_BAR_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_BAGS, BACKPACK_BANK_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_BAGS, BACKPACK_GUILD_BANK_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_STORE, BACKPACK_STORE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_GUILDSTORE, BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_MAIL, BACKPACK_MAIL_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_TRADE, BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_FENCE, BACKPACK_FENCE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LAF_LAUNDER, BACKPACK_LAUNDER_LAYOUT_FRAGMENT)

	-- other inventories seem to never reset additionalFilter
	self:HookAdditionalFilter(LAF_BANK, PLAYER_INVENTORY.inventories[INVENTORY_BANK])
	self:HookAdditionalFilter(LAF_GUILDBANK, PLAYER_INVENTORY.inventories[INVENTORY_GUILD_BANK])

	ZO_PreHook(SMITHING.deconstructionPanel.inventory, "AddItemData", DeconstructionFilter)
	ZO_PreHook(SMITHING.improvementPanel.inventory, "AddItemData", ImprovementFilter)
	ZO_PreHook(ENCHANTING.inventory, "AddItemData", EnchantingFilter)
	ZO_PreHook(ALCHEMY.inventory, "AddItemData", AlchemyFilter)
end
