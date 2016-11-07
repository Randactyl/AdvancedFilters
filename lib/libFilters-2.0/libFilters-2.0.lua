local MAJOR, MINOR = "LibFilters-2.0", 2.1
local LibFilters, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibFilters then return end

--some constants for your filters
LF_INVENTORY             = 1
LF_BANK_WITHDRAW         = 2
LF_BANK_DEPOSIT          = 3
LF_GUILDBANK_WITHDRAW    = 4
LF_GUILDBANK_DEPOSIT     = 5
LF_VENDOR_BUY            = 6
LF_VENDOR_SELL           = 7
LF_VENDOR_BUYBACK        = 8
LF_VENDOR_REPAIR         = 9
LF_GUILDSTORE_BROWSE     = 10
LF_GUILDSTORE_SELL       = 11
LF_MAIL_SEND             = 12
LF_TRADE                 = 13
LF_SMITHING_REFINE       = 14
LF_SMITHING_CREATION     = 15
LF_SMITHING_DECONSTRUCT  = 16
LF_SMITHING_IMPROVEMENT  = 17
LF_SMITHING_RESEARCH     = 18
LF_ALCHEMY_CREATION      = 19
LF_ENCHANTING_CREATION   = 20
LF_ENCHANTING_EXTRACTION = 21
LF_PROVISIONING_COOK     = 22
LF_PROVISIONING_BREW     = 23
LF_FENCE_SELL            = 24
LF_FENCE_LAUNDER         = 25
LF_CRAFTBAG				 = 26
LF_QUICKSLOT             = 27

LibFilters.isInitialized = false
LibFilters.filters = {
	[LF_INVENTORY] = {},
	[LF_BANK_WITHDRAW] = {},
	[LF_BANK_DEPOSIT] = {},
	[LF_GUILDBANK_WITHDRAW] = {},
	[LF_GUILDBANK_DEPOSIT] = {},
	[LF_VENDOR_BUY] = {},
	[LF_VENDOR_SELL] = {},
	[LF_VENDOR_BUYBACK] = {},
	[LF_VENDOR_REPAIR] = {},
	[LF_GUILDSTORE_BROWSE] = {},
	[LF_GUILDSTORE_SELL] = {},
	[LF_MAIL_SEND] = {},
	[LF_TRADE] = {},
	[LF_SMITHING_REFINE] = {},
	[LF_SMITHING_CREATION] = {},
	[LF_SMITHING_DECONSTRUCT] = {},
	[LF_SMITHING_IMPROVEMENT] = {},
	[LF_SMITHING_RESEARCH] = {},
	[LF_ALCHEMY_CREATION] = {},
	[LF_ENCHANTING_CREATION] = {},
	[LF_ENCHANTING_EXTRACTION] = {},
	[LF_PROVISIONING_COOK] = {},
	[LF_PROVISIONING_BREW] = {},
	[LF_FENCE_SELL] = {},
	[LF_FENCE_LAUNDER] = {},
	[LF_CRAFTBAG] = {},
	[LF_QUICKSLOT] = {},
}
local filters = LibFilters.filters

local filterTypeToUpdaterName = {
	[LF_INVENTORY] = "INVENTORY",
	[LF_BANK_WITHDRAW] = "BANK_WITHDRAW",
	[LF_BANK_DEPOSIT] = "INVENTORY",
	[LF_GUILDBANK_WITHDRAW] = "GUILDBANK_WITHDRAW",
	[LF_GUILDBANK_DEPOSIT] = "INVENTORY",
	[LF_VENDOR_BUY] = "VENDOR_BUY",
	[LF_VENDOR_SELL] = "INVENTORY",
	[LF_VENDOR_BUYBACK] = "VENDOR_BUYBACK",
	[LF_VENDOR_REPAIR] = "VENDOR_REPAIR",
	[LF_GUILDSTORE_BROWSE] = "GUILDSTORE_BROWSE",
	[LF_GUILDSTORE_SELL] = "INVENTORY",
	[LF_MAIL_SEND] = "INVENTORY",
	[LF_TRADE] = "INVENTORY",
	[LF_SMITHING_REFINE] = "SMITHING_REFINE",
	[LF_SMITHING_CREATION] = "SMITHING_CREATION",
	[LF_SMITHING_DECONSTRUCT] = "SMITHING_DECONSTRUCT",
	[LF_SMITHING_IMPROVEMENT] = "SMITHING_IMPROVEMENT",
	[LF_SMITHING_RESEARCH] = "SMITHING_RESEARCH",
	[LF_ALCHEMY_CREATION] = "ALCHEMY_CREATION",
	[LF_ENCHANTING_CREATION] = "ENCHANTING",
	[LF_ENCHANTING_EXTRACTION] = "ENCHANTING",
	[LF_PROVISIONING_COOK] = "PROVISIONING_COOK",
	[LF_PROVISIONING_BREW] = "PROVISIONING_BREW",
	[LF_FENCE_SELL] = "INVENTORY",
	[LF_FENCE_LAUNDER] = "INVENTORY",
	[LF_CRAFTBAG] = "CRAFTBAG",
	[LF_QUICKSLOT] = "QUICKSLOT",
}

local function SafePlayerInventoryUpdateList(inventoryType)
	PLAYER_INVENTORY:UpdateList(inventoryType)

	--if the mouse is visible, cycle its visibility to refresh the integrity of the control beneath it
	if SCENE_MANAGER:IsInUIMode() then
		HideMouse()
		ShowMouse()
	end
end

local inventoryUpdaters = {
	INVENTORY = function()
		SafePlayerInventoryUpdateList(INVENTORY_BACKPACK)
	end,
	BANK_WITHDRAW = function()
		SafePlayerInventoryUpdateList(INVENTORY_BANK)
	end,
	GUILDBANK_WITHDRAW = function()
		SafePlayerInventoryUpdateList(INVENTORY_GUILD_BANK)
	end,
	VENDOR_BUY = function()
		if BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.state ~= "shown" then
			STORE_WINDOW:GetStoreItems()
			STORE_WINDOW:UpdateList()
		end
	end,
	VENDOR_BUYBACK = function()
		BUY_BACK_WINDOW:UpdateList()
	end,
	VENDOR_REPAIR = function()
		REPAIR_WINDOW:UpdateList()
	end,
	GUILDSTORE_BROWSE = function()
	end,
	SMITHING_REFINE = function()
		SMITHING.refinementPanel.inventory:HandleDirtyEvent()
	end,
	SMITHING_CREATION = function()
	end,
	SMITHING_DECONSTRUCT = function()
		SMITHING.deconstructionPanel.inventory:HandleDirtyEvent()
	end,
	SMITHING_IMPROVEMENT = function()
		SMITHING.improvementPanel.inventory:HandleDirtyEvent()
	end,
	SMITHING_RESEARCH = function()
		SMITHING.researchPanel:Refresh()
	end,
	ALCHEMY_CREATION = function()
		ALCHEMY.inventory:HandleDirtyEvent()
	end,
	ENCHANTING = function()
		ENCHANTING.inventory:HandleDirtyEvent()
	end,
	PROVISIONING_COOK = function()
	end,
	PROVISIONING_BREW = function()
	end,
	CRAFTBAG = function()
		SafePlayerInventoryUpdateList(INVENTORY_CRAFT_BAG)
	end,
	QUICKSLOT = function()
		QUICKSLOT_WINDOW:UpdateList()
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

function LibFilters:HookAdditionalFilter(filterType, inventory)
    local layoutData = inventory.layoutData or inventory
	local originalFilter = layoutData.additionalFilter

	layoutData.LibFilters2_filterType = filterType

	if type(originalFilter) == "function" then
		layoutData.additionalFilter = function(...)
			--for enchanting
			if (filterType == LF_ENCHANTING_CREATION or filterType == LF_ENCHANTING_EXTRACTION) then
				return runFilters(filterType, ...)
			end

			return originalFilter(...) and runFilters(filterType, ...)
		end
	else
		layoutData.additionalFilter = function(...)
			return runFilters(filterType, ...)
		end
	end
end

function LibFilters:InitializeLibFilters()
	if self.isInitialized then return end
	self.isInitialized = true

	self:HookAdditionalFilter(LF_INVENTORY, PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK])
	self:HookAdditionalFilter(LF_INVENTORY, BACKPACK_MENU_BAR_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_BANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_BANK])
	self:HookAdditionalFilter(LF_BANK_DEPOSIT, BACKPACK_BANK_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_GUILDBANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_GUILD_BANK])
	self:HookAdditionalFilter(LF_GUILDBANK_DEPOSIT, BACKPACK_GUILD_BANK_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_VENDOR_BUY, STORE_WINDOW)
	self:HookAdditionalFilter(LF_VENDOR_SELL, BACKPACK_STORE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LF_VENDOR_BUYBACK, BUY_BACK_WINDOW)
	self:HookAdditionalFilter(LF_VENDOR_REPAIR, REPAIR_WINDOW)
	
	--self:HookAdditionalFilter(LF_GUILDSTORE_BROWSE, )
	self:HookAdditionalFilter(LF_GUILDSTORE_SELL, BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_MAIL_SEND, BACKPACK_MAIL_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_TRADE, BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_SMITHING_REFINE, SMITHING.refinementPanel.inventory)
	--self:HookAdditionalFilter(LF_SMITHING_CREATION, )
	self:HookAdditionalFilter(LF_SMITHING_DECONSTRUCT, SMITHING.deconstructionPanel.inventory)
	self:HookAdditionalFilter(LF_SMITHING_IMPROVEMENT, SMITHING.improvementPanel.inventory)
	self:HookAdditionalFilter(LF_SMITHING_RESEARCH, SMITHING.researchPanel)
	
	self:HookAdditionalFilter(LF_ALCHEMY_CREATION, ALCHEMY.inventory)
	
	self:HookAdditionalFilter(LF_ENCHANTING_CREATION, ENCHANTING.inventory)
	self:HookAdditionalFilter(LF_ENCHANTING_EXTRACTION, ENCHANTING.inventory)
	
	--self:HookAdditionalFilter(LF_PROVISIONING_COOK, )
	--self:HookAdditionalFilter(LF_PROVISIONING_BREW, )
	
	self:HookAdditionalFilter(LF_FENCE_SELL, BACKPACK_FENCE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LF_FENCE_LAUNDER, BACKPACK_LAUNDER_LAYOUT_FRAGMENT)

	self:HookAdditionalFilter(LF_CRAFTBAG, PLAYER_INVENTORY.inventories[INVENTORY_CRAFT_BAG])

	self:HookAdditionalFilter(LF_QUICKSLOT, QUICKSLOT_WINDOW)
end

function LibFilters:GetCurrentFilterTypeForInventory(inventoryType)
	local inventory = PLAYER_INVENTORY.inventories[inventoryType]
	local layoutData = PLAYER_INVENTORY.appliedLayout

	if inventoryType == INVENTORY_BACKPACK then
		if layoutData and layoutData.LibFilters2_filterType then
			return layoutData.LibFilters2_filterType
		end
	end

	return inventory.LibFilters2_filterType
end

function LibFilters:GetFilterCallback(filterTag, filterType)
	if not self:IsFilterRegistered(filterTag, filterType) then return end

	return filters[filterType][filterTag]
end

function LibFilters:IsFilterRegistered(filterTag, filterType)
	if filterType == nil then
		--check whether there's any filter with this tag
		for filterType, callbacks in pairs(filters) do
			if callbacks[filterTag] ~= nil then
				return true
			end
		end
		
		return false
	else
		--check only the specified filter type
		local callbacks = filters[filterType]
		
		return callbacks[filterTag] ~= nil
	end
end

function LibFilters:RegisterFilter(filterTag, filterType, filterCallback)
	local callbacks = filters[filterType]

	if not filterTag or not callbacks or type(filterCallback) ~= "function" then
		df("LibFilters: invalid arguments to RegisterFilter (%q, %s, %s)",
			tostring(filterTag), tostring(filterType), tostring(filterCallback))
		return
	end

	if callbacks[filterTag] ~= nil then
		df("LibFilters: %q filterType %s is already in use",
			tostring(filterTag), tostring(filterType))
		return
	end

	callbacks[filterTag] = filterCallback
end

function LibFilters:RequestUpdate(filterType)
	local updaterName = filterTypeToUpdaterName[filterType]
	local callbackName = "LibFilters_updateInventory_" .. updaterName
	local function Update()
		EVENT_MANAGER:UnregisterForUpdate(callbackName)
		inventoryUpdaters[updaterName]()
	end

	--cancel previously scheduled update if any
	EVENT_MANAGER:UnregisterForUpdate(callbackName)
	--register a new one
	EVENT_MANAGER:RegisterForUpdate(callbackName, 10, Update)
end

function LibFilters:UnregisterFilter(filterTag, filterType)
	if filterType == nil then
		--unregister all filters with this tag
		for filterType, callbacks in pairs(filters) do
			if callbacks[filterTag] ~= nil then
				callbacks[filterTag] = nil
			end
		end
	else
		--unregister only the specified filter type
		local callbacks = filters[filterType]
		
		if callbacks[filterTag] ~= nil then
			callbacks[filterTag] = nil
		end
	end
end