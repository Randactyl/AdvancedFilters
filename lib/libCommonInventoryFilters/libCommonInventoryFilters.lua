local myNAME, myVERSION = "libCommonInventoryFilters", 1.0
local libCIF = LibStub:NewLibrary(myNAME, myVERSION)
if not libCIF then return end


local function enableGuildStoreSellFilters()
    local tradingHouseLayout = BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.layoutData

    if not tradingHouseLayout.hiddenFilters then
        tradingHouseLayout.hiddenFilters = {}
    end
    tradingHouseLayout.hiddenFilters[ITEMFILTERTYPE_QUEST] = true
    tradingHouseLayout.inventoryTopOffsetY = 45
    tradingHouseLayout.sortByOffsetY = 63
    tradingHouseLayout.backpackOffsetY = 96

    local originalFilter = tradingHouseLayout.additionalFilter

    function tradingHouseLayout.additionalFilter(slot)
        return originalFilter(slot) and not IsItemBound(slot.bagId, slot.slotIndex)
    end

    local tradingHouseHiddenColumns = { statValue = true, age = true }
    local zorgGetTabFilterInfo = PLAYER_INVENTORY.GetTabFilterInfo

    function PLAYER_INVENTORY:GetTabFilterInfo(inventoryType, tabControl)
        if libCIF._tradingHouseModeEnabled then
            local filterType, activeTabText = zorgGetTabFilterInfo(self, inventoryType, tabControl)
            return filterType, activeTabText, tradingHouseHiddenColumns
        else
            return zorgGetTabFilterInfo(self, inventoryType, tabControl)
        end
    end
end


local function fixSearchBoxBugs()
    -- http://www.esoui.com/forums/showthread.php?t=4551

    -- search box bug #1: stale searchData after swapping equipment

    SHARED_INVENTORY:RegisterCallback("SlotUpdated",
        function(bagId, slotIndex, slotData)
            if slotData and slotData.searchData then
                slotData.searchData.cached = false
                slotData.searchData.cache = nil
            end
        end)

    -- guild bank search box bug #2: wrong inventory updated

    ZO_GuildBankSearchBox:SetHandler("OnTextChanged",
        function(editBox)
            ZO_EditDefaultText_OnTextChanged(editBox)
            PLAYER_INVENTORY:UpdateList(INVENTORY_GUILD_BANK)
        end)

    -- guild bank search box bug #3: wrong search box cleared

    local guildBankScene = SCENE_MANAGER:GetScene("guildBank")
    guildBankScene:RegisterCallback("StateChange",
        function(oldState, newState)
            if newState == SCENE_HIDDEN then
                ZO_PlayerInventory_EndSearch(ZO_GuildBankSearchBox)
            end
        end)
end


local function showSearchBoxes()
    -- re-anchoring is necessary because they overlap with sort headers

    ZO_PlayerInventorySearchBox:ClearAnchors()
    ZO_PlayerInventorySearchBox:SetAnchor(BOTTOMLEFT, nil, TOPLEFT, 36, -8)
    ZO_PlayerInventorySearchBox:SetHidden(false)

    ZO_PlayerBankSearchBox:ClearAnchors()
    ZO_PlayerBankSearchBox:SetAnchor(BOTTOMLEFT, nil, TOPLEFT, 36, -8)
    ZO_PlayerBankSearchBox:SetWidth(ZO_PlayerInventorySearchBox:GetWidth())
    ZO_PlayerBankSearchBox:SetHidden(false)

    ZO_GuildBankSearchBox:ClearAnchors()
    ZO_GuildBankSearchBox:SetAnchor(BOTTOMLEFT, nil, TOPLEFT, 36, -8)
    ZO_GuildBankSearchBox:SetWidth(ZO_PlayerInventorySearchBox:GetWidth())
    ZO_GuildBankSearchBox:SetHidden(false)
end


local function onPlayerActivated(eventCode)
    EVENT_MANAGER:UnregisterForEvent(myNAME, eventCode)

    fixSearchBoxBugs()

    if not libCIF._searchBoxesDisabled then
        showSearchBoxes()
    end

    if not libCIF._guildStoreSellFiltersDisabled then
        -- note that this sets trading house layout offsets, so it
        -- has to be done before they are shifted
        enableGuildStoreSellFilters()
    end

    local shiftY = libCIF._backpackLayoutShiftY
    if shiftY then
        local function doShift(layoutData)
            layoutData.sortByOffsetY = layoutData.sortByOffsetY + shiftY
            layoutData.backpackOffsetY = layoutData.backpackOffsetY + shiftY
        end
        doShift(BACKPACK_MENU_BAR_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_BANK_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_MAIL_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_STORE_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_FENCE_LAYOUT_FRAGMENT.layoutData)
        doShift(BACKPACK_LAUNDER_LAYOUT_FRAGMENT.layoutData)
    end

    -- replace ZO_InventoryManager:SetTradingHouseModeEnabled
    -- no need to call the original, as it only does two things we don't need:
    --  1) saves/restores the current filter
    --      - or would, if the filter wasn't reset in ApplyBackpackLayout
    --      - this simply doesn't work
    --  2) shows the search box and hides the filters tab, or vice versa
    --      - we want to always show the search box and/or the filters too
    --        unless another add-on explicitly disables them
    function PLAYER_INVENTORY:SetTradingHouseModeEnabled(enabled)
        libCIF._tradingHouseModeEnabled = enabled
        ZO_PlayerInventorySearchBox:SetHidden(not enabled and libCIF._searchBoxesDisabled)
        ZO_PlayerInventoryTabs:SetHidden(enabled and libCIF._guildStoreSellFiltersDisabled)
    end
end


-- shift backpack sort headers and item list down (shiftY > 0) or up (shiftY < 0)
-- add-ons should only call this from their EVENT_ADD_ON_LOADED handler
function libCIF:addBackpackLayoutShiftY(shiftY)
    libCIF._backpackLayoutShiftY = (libCIF._backpackLayoutShiftY or 0) + shiftY
end


-- tell libCIF to skip enabling inventory filters on guild store sell tab
-- add-ons should only call this from their EVENT_ADD_ON_LOADED handler
function libCIF:disableGuildStoreSellFilters()
    libCIF._guildStoreSellFiltersDisabled = true
end


-- tell libCIF to skip showing inventory search boxes outside guild store sell tab
-- add-ons should only call this from their EVENT_ADD_ON_LOADED handler
function libCIF:disableSearchBoxes()
    libCIF._searchBoxesDisabled = true
end


EVENT_MANAGER:UnregisterForEvent(myNAME, EVENT_PLAYER_ACTIVATED)
EVENT_MANAGER:RegisterForEvent(myNAME, EVENT_PLAYER_ACTIVATED, onPlayerActivated)
