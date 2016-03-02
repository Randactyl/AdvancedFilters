local AF = AdvancedFilters
AF.util = {}
AF.util.libFilters = LibStub("libFilters")

function AF.util.ApplyFilter(button, filterTag, requestUpdate)
    local libFilters = AF.util.libFilters
	local callback = button.filterCallback
	local laf
    if AF.currentInventoryType == 5 then
        laf = LAF_STORE
    else
        laf = libFilters:GetCurrentLAF(AF.currentInventoryType)
    end

	--if something isn't right. abort
	if callback == nil then
        d("callback was nil for " .. filterTag)
        return
    end
	if laf == nil then
        d("laf was nil for " .. filterTag)
        return
    end

	--first, clear current filters without an update
	libFilters:UnregisterFilter(filterTag)
	--then register new one and hand off update parameter
	libFilters:RegisterFilter(filterTag, laf, callback)
	if requestUpdate == true then
		libFilters:RequestInventoryUpdate(laf)
	end
end

function AF.util.RemoveAllFilters()
    local libFilters = AF.util.libFilters
    local laf
    if AF.currentInventoryType == 5 then
        laf = LAF_STORE
    else
        laf = libFilters:GetCurrentLAF(AF.currentInventoryType)
    end

	libFilters:UnregisterFilter(BUTTON_STRING)
	libFilters:UnregisterFilter(DROPDOWN_STRING)

	if laf ~= nil then
		libFilters:RequestInventoryUpdate(laf)
	end
end

function AF.util.RefreshSubfilterButtons(subfilterBar)
    if not subfilterBar then return end
    local inventory, inventorySlots

    --disable buttons
    for _, button in pairs(subfilterBar.subfilterButtons) do
        button.texture:SetColor(.3, .3, .3, .9)
        button:SetEnabled(false)
        button.clickable = false
    end

    if AF.currentInventoryType == 5 then
	    inventory = STORE_WINDOW
        inventorySlots = inventory.items

        --check buttons for availability
        for _, item in pairs(inventorySlots) do
            for _, button in pairs(subfilterBar.subfilterButtons) do
                if button.filterCallback(item) and (not button.clickable)
                  and (item.filterData[1] == inventory.currentFilter) then
                    button.texture:SetColor(1, 1, 1, 1)
                    button:SetEnabled(true)
                    button.clickable = true
                end
            end
        end
    else
        inventory = PLAYER_INVENTORY.inventories[AF.currentInventoryType]
        inventorySlots = inventory.slots

        --check buttons for availability
        for _, item in pairs(inventory.slots) do
            if item.dataEntry and item.dataEntry.data then
                local itemData = item.dataEntry.data
                for _, button in pairs(subfilterBar.subfilterButtons) do
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
end

function AF.util.BuildDropdownCallbacks(groupName, subfilterName)
	if subfilterName == "Heavy" or subfilterName == "Medium"
	  or subfilterName == "Light" or subfilterName == "Clothing" then
		subfilterName = "Body"
	end
	local callbackTable = {}
	local keys = {
		["Weapons"] = {
			[1] = "All",
			[2] = "OneHand",
			[3] = "TwoHand",
			[4] = "Bow",
			[5] = "DestructionStaff",
			[6] = "HealStaff",
		},
		["Armor"] = {
			[1] = "All",
			[2] = "Body",
			[3] = "Shield",
			[4] = "Jewelry",
			[5] = "Vanity",
		},
		["Consumables"] = {
			[1] = "All",
			[2] = "Crown",
			[3] = "Food",
			[4] = "Drink",
			[5] = "Recipe",
			[6] = "Potion",
			[7] = "Poison",
			[8] = "Motif",
			[9] = "Container",
			[10] = "Repair",
			[11] = "Trophy",
		},
		["Crafting"] = {
			[1] = "All",
			[2] = "Blacksmithing",
			[3] = "Clothier",
			[4] = "Woodworking",
			[5] = "Alchemy",
			[6] = "Enchanting",
			[7] = "Provisioning",
			[8] = "Style",
			[9] = "WeaponTrait",
			[10] = "ArmorTrait",
		},
		["Miscellaneous"] = {
			[1] = "All",
			[2] = "Glyphs",
			[3] = "SoulGem",
			[4] = "Siege",
			[5] = "Bait",
			[6] = "Tool",
			[7] = "Trophy",
			[8] = "Fence",
			[9] = "Trash",
		},
	}

	-- insert global "All" filters
	for _, callbackEntry in ipairs(AF.subfilterCallbacks["All"].dropdownCallbacks) do
		table.insert(callbackTable, callbackEntry)
	end

	if subfilterName == "All" then
		--insert all default filters for each subfilter
		for _, subfilterName in ipairs(keys[groupName]) do
			local currentSubfilterTable = AF.subfilterCallbacks[groupName][subfilterName]

			for _, callbackEntry in ipairs(currentSubfilterTable.dropdownCallbacks) do
				table.insert(callbackTable, callbackEntry)
			end
		end

		--insert all filters provided by addons
		for _, addonTable in ipairs(AF.subfilterCallbacks[groupName].addonDropdownCallbacks) do
			--check to see if addon is set up for a submenu
			if addonTable.submenuName then
				--insert whole package
				table.insert(callbackTable, addonTable)
			else
				--insert all callbackTable entries
				local currentAddonTable = addonTable.callbackTable

				for _, callbackEntry in ipairs(currentAddonTable) do
					table.insert(callbackTable, callbackEntry)
				end
			end
		end
	else
		--insert filters for provided subfilter
		local currentSubfilterTable = AF.subfilterCallbacks[groupName][subfilterName]
		for _, callbackEntry in ipairs(currentSubfilterTable.dropdownCallbacks) do
			table.insert(callbackTable, callbackEntry)
		end

		--insert filters provided by addons for this subfilter
		for _, addonTable in ipairs(AF.subfilterCallbacks[groupName].addonDropdownCallbacks) do
			--scan addon to see if it applies to given subfilter
			for _, subfilter in ipairs(addonTable.subfilters) do
				if subfilter == subfilterName or subfilter == "All" then
					--add addon filters
					--check to see if addon is set up for a submenu
					if addonTable.submenuName then
						--insert whole package
						table.insert(callbackTable, addonTable)
					else
						--insert all callbackTable entries
						local currentAddonTable = addonTable.callbackTable

						for _, callbackEntry in ipairs(currentAddonTable) do
							table.insert(callbackTable, callbackEntry)
						end
					end
				end
			end
		end
	end

	return callbackTable
end
