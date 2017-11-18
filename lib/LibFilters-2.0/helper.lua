local helpers = {}

--enable LF_VENDOR_BUY
helpers["STORE_WINDOW"] = {
    version = 1,
    locations = {
        [1] = STORE_WINDOW,
    },
    helper = {
        funcName = "ShouldAddItemToList",
        func = function(self, itemData)
            local result = true

            if type(self.additionalFilter) == "function" then
                result = self.additionalFilter(itemData)
            end

            if self.currentFilter == ITEMFILTERTYPE_ALL then
                return result and true
            end

            for i = 1, #itemData.filterData do
                if itemData.filterData[i] == self.currentFilter then
                    return result and true
                end
            end

            return false
        end,
    },
}

--enable LF_VENDOR_BUYBACK
helpers["BUY_BACK_WINDOW"] = {
    version = 1,
    locations = {
        [1] = BUY_BACK_WINDOW,
    },
    helper = {
        funcName = "UpdateList",
        func = function(self)
            local DATA_TYPE_BUY_BACK_ITEM = 1
            ZO_ScrollList_Clear(self.list)
            ZO_ScrollList_ResetToTop(self.list)

            local scrollData = ZO_ScrollList_GetDataList(self.list)

            for entryIndex = 1, GetNumBuybackItems() do
                local icon, name, stack, price, quality, meetsRequirements = GetBuybackItemInfo(entryIndex)
                local buybackData = {
                    slotIndex = entryIndex,
                    icon = icon,
                    name = name,
                    stack = stack,
                    price = price,
                    quality = quality,
                    meetsRequirements = meetsRequirements,
                    stackBuyPrice = stack * price,
                }
                local result = true

                if type(self.additionalFilter) == "function" then
                    result = self.additionalFilter(buybackData)
                end

                if(stack > 0) and result then
                    scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(DATA_TYPE_BUY_BACK_ITEM, buybackData)
                end
            end

            self:ApplySort()
        end,
    },
}

--enable LF_VENDOR_REPAIR
helpers["REPAIR_WINDOW"] = {
    version = 1,
    locations = {
        [1] = REPAIR_WINDOW,
    },
    helper = {
        funcName = "UpdateList",
        func = function(self)
            local function GatherDamagedEquipmentFromBag(bagId, dataTable)
                local DATA_TYPE_REPAIR_ITEM = 1
                local bagSlots = GetBagSize(bagId)

                for slotIndex = 0, bagSlots - 1 do
                    local condition = GetItemCondition(bagId, slotIndex)

                    if condition < 100 and not IsItemStolen(bagId, slotIndex) then
                        local icon, stackCount, _, _, _, _, _, quality = GetItemInfo(bagId, slotIndex)

                        if stackCount > 0 then
                            local repairCost = GetItemRepairCost(bagId, slotIndex)

                            if repairCost > 0 then
                                local name = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemName(bagId, slotIndex))
                                local data = {
                                    bagId = bagId,
                                    slotIndex = slotIndex,
                                    name = name,
                                    icon = icon,
                                    stackCount = stackCount,
                                    quality = quality,
                                    condition = condition,
                                    repairCost = repairCost
                                }
                                local result = true

                                if type(REPAIR_WINDOW.additionalFilter) == "function" then
                                    result = REPAIR_WINDOW.additionalFilter(data)
                                end

                                if result then
                                    dataTable[#dataTable + 1] = ZO_ScrollList_CreateDataEntry(DATA_TYPE_REPAIR_ITEM, data)
                                end
                            end
                        end
                    end
                end
            end
            ZO_ScrollList_Clear(self.list)
            ZO_ScrollList_ResetToTop(self.list)

            local scrollData = ZO_ScrollList_GetDataList(self.list)

            GatherDamagedEquipmentFromBag(BAG_WORN, scrollData)
            GatherDamagedEquipmentFromBag(BAG_BACKPACK, scrollData)

            self:ApplySort()
        end,
    },
}

--enable LF_ALCHEMY_CREATION, LF_ENCHANTING_CREATION, LF_ENCHANTING_EXTRACTION,
--  LF_SMITHING_REFINE
helpers["enumerate"] = {
    version = 3,
    locations = {
        [1] = ZO_AlchemyInventory,
        [2] = ZO_EnchantingInventory,
        [3] = ZO_SmithingExtractionInventory,
    },
    helper = {
        funcName = "EnumerateInventorySlotsAndAddToScrollData",
        func = function(self, predicate, filterFunction, filterType, data)
            local oldPredicate = predicate
            predicate = function(bagId, slotIndex)
                local result = true

                if type(self.additionalFilter) == "function" then
                    result = self.additionalFilter(bagId, slotIndex)
                end

                return oldPredicate(bagId, slotIndex) and result
            end

            -- Begin original function

            local list = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, predicate)
            PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BANK, predicate, list)
            PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_CRAFT_BAG, predicate, list)

            ZO_ClearTable(self.itemCounts)

            for itemId, itemInfo in pairs(list) do
                if not filterFunction or filterFunction(itemInfo.bag, itemInfo.index, filterType) then
                    self:AddItemData(itemInfo.bag, itemInfo.index, itemInfo.stack, self:GetScrollDataType(itemInfo.bag, itemInfo.index), data, self.customDataGetFunction)
                end
                self.itemCounts[itemId] = itemInfo.stack
            end

            return list
        end,
    },
}

--enable LF_SMITHING_DECONSTRUCT, LF_SMITHING_IMPROVEMENT
helpers["GetIndividualInventorySlotsAndAddToScrollData"] = {
    version = 2,
    locations = {
        [1] = ZO_SmithingExtractionInventory,
        [2] = ZO_SmithingImprovementInventory,
    },
    helper = {
        funcName = "GetIndividualInventorySlotsAndAddToScrollData",
        func = function(self, predicate, filterFunction, filterType, data, useWornBag)
            local oldPredicate = predicate
            predicate = function(itemData)
                local result = true

                if type(self.additionalFilter) == "function" then
                    result = self.additionalFilter(itemData.bagId, itemData.slotIndex)
                end

                return oldPredicate(itemData) and result
            end

            -- Begin original function

            local bagsToUse = useWornBag and ZO_ALL_CRAFTING_INVENTORY_BAGS_AND_WORN or ZO_ALL_CRAFTING_INVENTORY_BAGS_WITHOUT_WORN
            local filteredDataTable = SHARED_INVENTORY:GenerateFullSlotData(predicate, unpack(bagsToUse))

            ZO_ClearTable(self.itemCounts)

            for i, slotData in pairs(filteredDataTable) do
                if not filterFunction or filterFunction(slotData.bagId, slotData.slotIndex, filterType) then
                    self:AddItemData(slotData.bagId, slotData.slotIndex, slotData.stackCount, self:GetScrollDataType(slotData.bagId, slotData.slotIndex), data, self.customDataGetFunction, slotData)
                end
                self.itemCounts[i] = slotData.stackCount
            end

            return filteredDataTable
        end,
    },
}

--enable LF_SMITHING_RESEARCH
helpers["SMITHING.researchPanel"] = {
    version = 3,
    locations = {
        [1] = SMITHING.researchPanel,
    },
    helper = {
        funcName = "Refresh",
        func = function(self)
            -- Include functions local to smithingresearch_shared.lua
            local function IsNotLockedOrRetraitedItem(bagId, slotIndex)
                return not IsItemPlayerLocked(bagId, slotIndex) and GetItemTraitInformation(bagId, slotIndex) ~= ITEM_TRAIT_INFORMATION_RETRAITED
            end

            local function DetermineResearchLineFilterType(craftingType, researchLineIndex)
                local traitType = GetSmithingResearchLineTraitInfo(craftingType, researchLineIndex, 1)
                if ZO_CraftingUtils_IsTraitAppliedToWeapons(traitType) then
                    return ZO_SMITHING_RESEARCH_FILTER_TYPE_WEAPONS
                elseif ZO_CraftingUtils_IsTraitAppliedToArmor(traitType) then
                    return ZO_SMITHING_RESEARCH_FILTER_TYPE_ARMOR
                end
            end

            -- Our filter function to insert LibFilter rules
            local function predicate(bagId, slotIndex)
                local result = IsNotLockedOrRetraitedItem(bagId, slotIndex)

                if type(self.additionalFilter) == "function" then
                    result = result and self.additionalFilter(bagId, slotIndex)
                end

                return result
            end

            -- Begin original function, ZO_SharedSmithingResearch:Refresh()
            self.dirty = false

            self.researchLineList:Clear()
            local craftingType = GetCraftingInteractionType()

            local numCurrentlyResearching = 0

            local virtualInventoryList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, predicate--[[IsNotLockedOrRetraitedItem]])
            PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BANK, predicate--[[IsNotLockedOrRetraitedItem]], virtualInventoryList)

            for researchLineIndex = 1, GetNumSmithingResearchLines(craftingType) do
                local name, icon, numTraits, timeRequiredForNextResearchSecs = GetSmithingResearchLineInfo(craftingType, researchLineIndex)
                if numTraits > 0 then
                    local researchingTraitIndex, areAllTraitsKnown = self:FindResearchingTraitIndex(craftingType, researchLineIndex, numTraits)
                    if researchingTraitIndex then
                        numCurrentlyResearching = numCurrentlyResearching + 1
                    end

                    if DetermineResearchLineFilterType(craftingType, researchLineIndex) == self.typeFilter then
                        local itemTraitCounts = self:GenerateResearchTraitCounts(virtualInventoryList, craftingType, researchLineIndex, numTraits)
                        local data = { craftingType = craftingType, researchLineIndex = researchLineIndex, name = name, icon = icon, numTraits = numTraits, timeRequiredForNextResearchSecs = timeRequiredForNextResearchSecs, researchingTraitIndex = researchingTraitIndex, areAllTraitsKnown = areAllTraitsKnown, itemTraitCounts = itemTraitCounts }
                        self.researchLineList:AddEntry(data)
                    end
                end
            end

            self.researchLineList:Commit()

            local maxResearchable = GetMaxSimultaneousSmithingResearch(craftingType)
            if numCurrentlyResearching >= maxResearchable then
                self.atMaxResearchLimit = true
            else
                self.atMaxResearchLimit = false
            end

            self:RefreshCurrentResearchStatusDisplay(numCurrentlyResearching, maxResearchable)

            if self.activeRow then
                self:OnResearchRowActivate(self.activeRow)
            end
        end,
    },
}

--enable LF_QUICKSLOT
helpers["QUICKSLOT_WINDOW"] = {
    version = 1,
    locations = {
        [1] = QUICKSLOT_WINDOW,
    },
    helper = {
        funcName = "ShouldAddItemToList",
        func = function(self, itemData)
            local result = true

            if type(self.additionalFilter) == "function" then
                result = self.additionalFilter(itemData)
            end

            for i = 1, #itemData.filterData do
                if(itemData.filterData[i] == ITEMFILTERTYPE_QUICKSLOT) then
                    return result and true
                end
            end

            return false
        end,
    },
}

--enable LF_RETRAIT
helpers["ZO_RetraitStation_CanItemBeRetraited"] = {
    version = 1,
    locations = { _G, },
    helper = {
        funcName = "ZO_RetraitStation_CanItemBeRetraited",
        func = function(itemData)
            local base = ZO_RETRAIT_STATION_KEYBOARD
            local result = CanItemBeRetraited(itemData.bagId, itemData.slotIndex)

            if type(base.additionalFilter) == "function" then
                result = result and base.additionalFilter(itemData.bagId, itemData.slotIndex)
            end

            return result
        end,
    }
}

--copy helpers into LibFilters
local LibFilters = LibStub("LibFilters-2.0")

for name, package in pairs(helpers) do
    if LibFilters.helpers[name] == nil then
        LibFilters.helpers[name] = package
    elseif LibFilters.helpers[name].version < package.version then
        LibFilters.helpers[name] = package
    end
end

helpers = nil
LibFilters = nil