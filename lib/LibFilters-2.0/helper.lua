--enable LF_VENDOR_BUY
STORE_WINDOW.ShouldAddItemToList = function(self, itemData)
    local result = true
    
    if type(self.additionalFilter) == "function" then
        result = self.additionalFilter(itemData)
    end

    for i = 1, #itemData.filterData do
        if(itemData.filterData[i] == self.currentFilter) or (self.currentFilter == ITEMFILTERTYPE_ALL) then
            return result and true
        end
    end
    
    return false
end

--enable LF_VENDOR_BUYBACK
local DATA_TYPE_BUY_BACK_ITEM = 1
BUY_BACK_WINDOW.UpdateList = function(self)
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
end

--enable LF_VENDOR_REPAIR
local DATA_TYPE_REPAIR_ITEM = 1
local function GatherDamagedEquipmentFromBag(bagId, dataTable)
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
REPAIR_WINDOW.UpdateList = function(self)
    ZO_ScrollList_Clear(self.list)
    ZO_ScrollList_ResetToTop(self.list)

    local scrollData = ZO_ScrollList_GetDataList(self.list)

    GatherDamagedEquipmentFromBag(BAG_WORN, scrollData)
    GatherDamagedEquipmentFromBag(BAG_BACKPACK, scrollData)

    self:ApplySort()
end

--enable LF_ALCHEMY_CREATION, LF_ENCHANTING_CREATION, LF_ENCHANTING_EXTRACTION,
--  LF_SMITHING_REFINE, LF_SMITHING_DECONSTRUCT, LF_SMITHING_IMPROVEMENT
local function enumerate(self, predicate, filterFunction, filterType, data)
    local oldPredicate = predicate
    predicate = function(bagId, slotIndex)
        local result = true

        if type(self.additionalFilter) == "function" then
            result = self.additionalFilter(bagId, slotIndex)
        end

        return oldPredicate(bagId, slotIndex) and result
    end

    local list = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, predicate)
    PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BANK, predicate, list)
    PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_CRAFT_BAG, predicate, list)

    ZO_ClearTable(self.itemCounts)

    for itemId, itemInfo in pairs(list) do
        if not filterFunction or filterFunction(itemInfo.bag, itemInfo.index, filterType) then
            self:AddItemData(itemInfo.bag, itemInfo.index, itemInfo.stack, self:GetScrollDataType(itemInfo.bag, itemInfo.index), data, self.customDataGetFunction, validItemIds)
        end
        self.itemCounts[itemId] = itemInfo.stack
    end

    return list
end
ZO_AlchemyInventory.EnumerateInventorySlotsAndAddToScrollData = enumerate
ZO_EnchantingInventory.EnumerateInventorySlotsAndAddToScrollData = enumerate
ZO_SmithingExtractionInventory.EnumerateInventorySlotsAndAddToScrollData = enumerate
ZO_SmithingImprovementInventory.EnumerateInventorySlotsAndAddToScrollData = enumerate

--enable LF_SMITHING_RESEARCH
ZO_SMITHING_RESEARCH_FILTER_TYPE_WEAPONS = 1
ZO_SMITHING_RESEARCH_FILTER_TYPE_ARMOR = 2
local function DetermineResearchLineFilterType(craftingType, researchLineIndex)
    local traitType = GetSmithingResearchLineTraitInfo(craftingType, researchLineIndex, 1)

    if ZO_CraftingUtils_IsTraitAppliedToWeapons(traitType) then
        return ZO_SMITHING_RESEARCH_FILTER_TYPE_WEAPONS
    elseif ZO_CraftingUtils_IsTraitAppliedToArmor(traitType) then
        return ZO_SMITHING_RESEARCH_FILTER_TYPE_ARMOR
    end
end
function SMITHING.researchPanel.Refresh(self)
    self.dirty = false
    self.researchLineList:Clear()

    local craftingType = GetCraftingInteractionType()
    local numCurrentlyResearching = 0

    for researchLineIndex = 1, GetNumSmithingResearchLines(craftingType) do
        local name, icon, numTraits, timeRequiredForNextResearchSecs = GetSmithingResearchLineInfo(craftingType, researchLineIndex)

        if numTraits > 0 then
            local researchingTraitIndex, areAllTraitsKnown = self:FindResearchingTraitIndex(craftingType, researchLineIndex, numTraits)

            if researchingTraitIndex then
                numCurrentlyResearching = numCurrentlyResearching + 1
            end

            if DetermineResearchLineFilterType(craftingType, researchLineIndex) == self.typeFilter then
                local function predicate(bagId, slotIndex)
                    local result = true

                    if type(self.additionalFilter) == "function" then
                        result = self.additionalFilter(bagId, slotIndex)
                    end

                    return result
                end

                local virtualInventoryList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BANK, predicate, PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, predicate))

                local itemTraitCounts = self:GenerateResearchTraitCounts(virtualInventoryList, craftingType, researchLineIndex, numTraits)
                local data = {
                    craftingType = craftingType,
                    researchLineIndex = researchLineIndex,
                    name = name,
                    icon = icon,
                    numTraits = numTraits,
                    timeRequiredForNextResearchSecs = timeRequiredForNextResearchSecs,
                    researchingTraitIndex = researchingTraitIndex,
                    areAllTraitsKnown = areAllTraitsKnown,
                    itemTraitCounts = itemTraitCounts
                }

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
end

--enable LF_QUICKSLOT
function QUICKSLOT_WINDOW.ShouldAddItemToList(self, itemData)
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
end