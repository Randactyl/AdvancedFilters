local MAJOR, MINOR = "libFilters-2.0", 1
local libFilters, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not libFilters then return end	--the same or newer version of this lib is already loaded into memory
--thanks to Seerah for the previous lines and library

--some constants for your filters
LF_INVENTORY             = 1 --done
LF_BANK_WITHDRAW         = 2 --done
LF_BANK_DEPOSIT          = 3 --done
LF_GUILDBANK_WITHDRAW    = 4 --done
LF_GUILDBANK_DEPOSIT     = 5 --done
LF_VENDOR_BUY            = 6 --done
LF_VENDOR_SELL           = 7 --done
LF_VENDOR_BUYBACK        = 8
LF_VENDOR_REPAIR         = 9
LF_GUILDSTORE_BROWSE     = 10
LF_GUILDSTORE_SELL       = 11 --done
LF_MAIL_SEND             = 12 --done
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
LF_FENCE_SELL            = 24 --done
LF_FENCE_LAUNDER         = 25 --done
LF_CRAFTBAG				 = 26 --done

libFilters.filters = {
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
}
local filters = libFilters.filters

local enchantingModeToFilterType = {
	[ENCHANTING_MODE_CREATION] = LF_ENCHANTING_CREATION,
	[ENCHANTING_MODE_EXTRACTION] = LF_ENCHANTING_EXTRACTION,
}

local filterTypeToUpdaterName = {
	[LF_INVENTORY] = "INVENTORY", --done
	[LF_BANK_WITHDRAW] = "BANK_WITHDRAW", --done
	[LF_BANK_DEPOSIT] = "INVENTORY", --done
	[LF_GUILDBANK_WITHDRAW] = "GUILDBANK_WITHDRAW", --done
	[LF_GUILDBANK_DEPOSIT] = "INVENTORY", --done
	[LF_VENDOR_BUY] = "VENDOR_BUY", --done
	[LF_VENDOR_SELL] = "INVENTORY", --done
	[LF_VENDOR_BUYBACK] = "VENDOR_BUYBACK",
	[LF_VENDOR_REPAIR] = "VENDOR_REPAIR",
	[LF_GUILDSTORE_BROWSE] = "GUILDSTORE_BROWSE",
	[LF_GUILDSTORE_SELL] = "INVENTORY", --done
	[LF_MAIL_SEND] = "INVENTORY", --done
	[LF_TRADE] = "INVENTORY", --done
	[LF_SMITHING_REFINE] = "SMITHING_REFINE",
	[LF_SMITHING_CREATION] = "SMITHING_CREATION",
	[LF_SMITHING_DECONSTRUCT] = "SMITHING_DECONSTRUCT", --done
	[LF_SMITHING_IMPROVEMENT] = "SMITHING_IMPROVEMENT", --done
	[LF_SMITHING_RESEARCH] = "SMITHING_RESEARCH",
	[LF_ALCHEMY_CREATION] = "ALCHEMY_CREATION", --done
	[LF_ENCHANTING_CREATION] = "ENCHANTING", --done
	[LF_ENCHANTING_EXTRACTION] = "ENCHANTING", --done
	[LF_PROVISIONING_COOK] = "PROVISIONING_COOK",
	[LF_PROVISIONING_BREW] = "PROVISIONING_BREW",
	[LF_FENCE_SELL] = "INVENTORY", --done
	[LF_FENCE_LAUNDER] = "INVENTORY", --done
	[LF_CRAFTBAG] = "CRAFTBAG", --done
}

local inventoryUpdaters = {
	INVENTORY = function()
		PLAYER_INVENTORY:UpdateList(INVENTORY_BACKPACK)
	end,
	BANK_WITHDRAW = function()
		PLAYER_INVENTORY:UpdateList(INVENTORY_BANK)
	end,
	GUILDBANK_WITHDRAW = function()
		PLAYER_INVENTORY:UpdateList(INVENTORY_GUILD_BANK)
	end,
	VENDOR_BUY = function()
		if BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.state ~= "shown" then
			STORE_WINDOW:UpdateList()
		end
	end,
	SMITHING_DECONSTRUCT = function()
		SMITHING.deconstructionPanel.inventory:HandleDirtyEvent()
	end,
	SMITHING_IMPROVEMENT = function()
		SMITHING.improvementPanel.inventory:HandleDirtyEvent()
	end,
	ALCHEMY_CREATION = function()
		ALCHEMY.inventory:HandleDirtyEvent()
	end,
	ENCHANTING = function()
		ENCHANTING.inventory:HandleDirtyEvent()
	end,
	CRAFTBAG = function()
		if INVENTORY_CRAFT_BAG then
			PLAYER_INVENTORY:UpdateList(INVENTORY_CRAFT_BAG)
		end
	end
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
	return not runFilters(LF_SMITHING_DECONSTRUCT, bagId, slotIndex)
end

--LAF_IMPROVEMENT
--since this is a PreHook using ZO_PreHook, a return of true means don't add
local function ImprovementFilter(self, bagId, slotIndex, ...)
	return not runFilters(LF_SMITHING_IMPROVEMENT, bagId, slotIndex)
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
	return not runFilters(LF_ALCHEMY_CREATION, bagId, slotIndex)
end

-- _inventory_ should be one of:
--  a) backpack layout fragment with .layoutData
--  b) inventory table from PLAYER_INVENTORY.inventories
function libFilters:HookAdditionalFilter(filterType, inventory)
    --lazily initialize the add-on
    if(not self.IS_INITIALIZED) then self:InitializeLibFilters() end

    local layoutData = inventory.layoutData or inventory
	local originalFilter = layoutData.additionalFilter

	layoutData.libFilters2_filterType = filterType

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

	callbacks[filterTag] = filterCallback
	--d("registered "..filterTag)
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

function libFilters:GetCurrentFilterType(inventoryType)
	local inventory = PLAYER_INVENTORY.inventories[inventoryType]
	local layoutData = PLAYER_INVENTORY.appliedLayout

	if inventoryType == INVENTORY_BACKPACK then
		if layoutData and layoutData.libFilters2_filterType then
			return layoutData.libFilters2_filterType
		end
	end

	return inventory.libFilters2_filterType
end

function libFilters:InventoryTypeToFilterType(inventoryType)
	if(inventoryType == INVENTORY_BACKPACK) then
		return LF_INVENTORY
	elseif(inventoryType == INVENTORY_BANK) then
		return LAF_BANK
	elseif(inventoryType == INVENTORY_GUILD_BANK) then
		return LAF_GUILDBANK
	end

	return 0
end

function libFilters:BagIdToFilterType(bagId)
	if(bagId == BAG_BACKPACK) then
		return LF_INVENTORY
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

	self:HookAdditionalFilter(LF_INVENTORY, PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK])
	self:HookAdditionalFilter(LF_INVENTORY, BACKPACK_MENU_BAR_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_BANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_BANK])
	self:HookAdditionalFilter(LF_BANK_DEPOSIT, BACKPACK_BANK_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_GUILDBANK_WITHDRAW, PLAYER_INVENTORY.inventories[INVENTORY_GUILD_BANK])
	self:HookAdditionalFilter(LF_GUILDBANK_DEPOSIT, BACKPACK_GUILD_BANK_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_VENDOR_BUY, STORE_WINDOW)
	self:HookAdditionalFilter(LF_VENDOR_SELL, BACKPACK_STORE_LAYOUT_FRAGMENT)
	--self:HookAdditionalFilter(LF_VENDOR_BUYBACK, )
	--self:HookAdditionalFilter(LF_VENDOR_REPAIR, )
	
	--self:HookAdditionalFilter(LF_GUILDSTORE_BROWSE, )
	self:HookAdditionalFilter(LF_GUILDSTORE_SELL, BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_MAIL_SEND, BACKPACK_MAIL_LAYOUT_FRAGMENT)
	
	self:HookAdditionalFilter(LF_TRADE, BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT)
	
	--self:HookAdditionalFilter(LF_SMITHING_REFINE, )
	--self:HookAdditionalFilter(LF_SMITHING_CREATION, )
	--self:HookAdditionalFilter(LF_SMITHING_DECONSTRUCT, )
	ZO_PreHook(SMITHING.deconstructionPanel.inventory, "AddItemData", DeconstructionFilter)
	--self:HookAdditionalFilter(LF_SMITHING_IMPROVEMENT, )
	ZO_PreHook(SMITHING.improvementPanel.inventory, "AddItemData", ImprovementFilter)
	--self:HookAdditionalFilter(LF_SMITHING_RESEARCH, )
	
	--self:HookAdditionalFilter(LF_ALCHEMY_CREATION, )
	ZO_PreHook(ALCHEMY.inventory, "AddItemData", AlchemyFilter)
	
	--self:HookAdditionalFilter(LF_ENCHANTING_CREATION, )
	--self:HookAdditionalFilter(LF_ENCHANTING_EXTRACTION, )
	ZO_PreHook(ENCHANTING.inventory, "AddItemData", EnchantingFilter)
	
	--self:HookAdditionalFilter(LF_PROVISIONING_COOK, )
	--self:HookAdditionalFilter(LF_PROVISIONING_BREW, )
	
	self:HookAdditionalFilter(LF_FENCE_SELL, BACKPACK_FENCE_LAYOUT_FRAGMENT)
	self:HookAdditionalFilter(LF_FENCE_LAUNDER, BACKPACK_LAUNDER_LAYOUT_FRAGMENT)
	
	if INVENTORY_CRAFT_BAG then
		self:HookAdditionalFilter(LF_CRAFTBAG, PLAYER_INVENTORY.inventories[INVENTORY_CRAFT_BAG])
	end
end