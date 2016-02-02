--init filtering library
local libFilters = LibStub("libFilters")

--local "globals"
local SUBFILTER_HEIGHT = 40
local STARTX = 148
local ICON_SIZE = 32
local INDEX = 0
local BUTTON_STRING = "AdvancedFilters_Button_Filter"
local DROPDOWN_STRING = "AdvancedFilters_Dropdown_Filter"
local lang = AdvancedFilters_GetLanguage()
local tooltipSet = AF_Strings[lang]

AdvancedFilterGroup = ZO_Object:Subclass()

--local helpers
local function GetNextIndex()
	INDEX = INDEX + 1
	return INDEX
end

local function SetUpCallbackFilter(button, filterTag, requestUpdate)
	local callback = button.filterCallback
	local laf = libFilters:GetCurrentLAF(GetCurrentInventoryType())

	--if something isn't right. abort
	if callback == nil then return end
	if laf == nil then return end

	--first, clear current filters without an update
	libFilters:UnregisterFilter(filterTag)
	--then register new one and hand off update parameter
	libFilters:RegisterFilter(filterTag, laf, callback)
	if requestUpdate == true then
		libFilters:RequestInventoryUpdate(laf)
	end
end

local function OnDropdownSelect(selectedItemData, selectionChanged)
	--update if the dropdown selection changed
	SetUpCallbackFilter(selectedItemData, DROPDOWN_STRING, selectionChanged)
end

--interface
function AdvancedFilterGroup:New(inventoryName, groupName, subfilterNames)
	local obj = ZO_Object.New(self)
	obj:Init(inventoryName, groupName, subfilterNames)
	return obj
end

function AdvancedFilterGroup:Init(inventoryName, groupName, subfilterNames)
	--get upper anchor position for subfilter bar
	local _,_,_,_,_,offsetY = ZO_PlayerInventorySortBy:GetAnchor()
	--parent for the subfilter bar control
	local parent = ZO_PlayerInventory

	self.offsetY = offsetY

	--unique identifier
	self.name = inventoryName .. groupName

	self.control = WINDOW_MANAGER:CreateControlFromVirtual("AdvancedFilterGroup" .. self.name, parent, "AF_Base")
	self.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, offsetY)

	self.label = self.control:GetNamedChild("Label")
	self.label:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
	self.label:SetText(tooltipSet["All"])

	self.divider = self.control:GetNamedChild("Divider")

	self.subfilters = {}
	self.activeButtons = {
		[INVENTORY_BACKPACK] = nil,
		[INVENTORY_BANK] = nil,
		[INVENTORY_GUILD_BANK] = nil,
	}

	for _, subfilterName in ipairs(subfilterNames) do
		self:AddSubfilter(groupName, subfilterName)
	end
end

function AdvancedFilterGroup:AddSubfilter(groupName, subfilterName)
	local subfilterData = AdvancedFilters_GetSubfilterData(groupName, subfilterName)
	local icon = subfilterData.icon
	local callback = subfilterData.filterCallback
	local dropdownCallbacks = subfilterData.dropdownCallbacks

	local function AddDropdownFilter(button, callbackTable)
		local dropdown = WINDOW_MANAGER:CreateControlFromVirtual(button:GetName() .. "DropdownFilter", button, "ZO_ComboBox")

		dropdown:SetHidden(true)
		dropdown:SetAnchor(RIGHT, self.control, RIGHT)
		dropdown:SetHeight(24)
		dropdown:SetWidth(136)

		local comboBox = dropdown.m_comboBox

		comboBox.AddMenuItems = function(comboBox)
				local self = comboBox

				for i = 1, #self.m_sortedItems do
					-- The variable item must be defined locally here, otherwise it won't work as an upvalue to the selection helper
	        		local item = self.m_sortedItems[i]
	        		AddMenuItem(item.name, function() ZO_ComboBox_Base_ItemSelectedClickHelper(self, item) end, nil, self.m_font, self.m_normalColor, self.m_highlightColor)
	    		end

				local submenuCandidates = self.submenuCandidates

				for _, submenuCandidate in ipairs(submenuCandidates) do
					local entries = {}
					for _, callbackEntry in ipairs(submenuCandidate.callbackTable) do
						local entry = {
							label = tooltipSet[callbackEntry.name],
							callback = function()
									OnDropdownSelect(callbackEntry, true)
									button.forceNextDropdownRefresh = true
									self.m_selectedItemText:SetText(callbackEntry.name)
									ClearMenu()
								end,
						}
						table.insert(entries, entry)
					end

					AddCustomSubMenuItem(tooltipSet[submenuCandidate.submenuName], entries)
				end
			end

	    comboBox:SetSortsItems(false)

		comboBox.submenuCandidates = {}
		for _, v in ipairs(callbackTable) do
			if v.submenuName then
				table.insert(comboBox.submenuCandidates, v)
			else
				local itemEntry = ZO_ComboBox:CreateItemEntry(tooltipSet[v.name],
					function(comboBox, itemName, item, selectionChanged)
						OnDropdownSelect(v, selectionChanged or button.forceNextDropdownRefresh)
					end)
				comboBox:AddItem(itemEntry)
			end
		end

		comboBox:SelectFirstItem()
	    comboBox:SetSelectedItemFont("ZoFontGameSmall")
	    comboBox:SetDropdownFont("ZoFontGameSmall")

		button.dropdown = dropdown
	end

	local anchorX = -STARTX + #self.subfilters * -ICON_SIZE

	local button = WINDOW_MANAGER:CreateControlFromVirtual(self.control:GetName() .. subfilterName .. "Button", self.control, "AF_Button")
	local texture = button:GetNamedChild("Texture")
	local highlight = button:GetNamedChild("Highlight")

	texture:SetTexture(icon.normal)
	highlight:SetTexture(icon.mouseOver)

	button:SetAnchor(RIGHT, self.control, RIGHT, anchorX, 0)
	button:SetClickSound(SOUNDS.MENU_BAR_CLICK)
	button:SetHandler("OnClicked", function(clickedButton, subfilterName)
            if(not clickedButton.clickable) then return end

			self:ActivateButton(clickedButton)
        end)
	button:SetHandler("OnMouseEnter", function(self)
			ZO_Tooltips_ShowTextTooltip(self, TOP, tooltipSet[subfilterName])

			if(button.clickable) then
				highlight:SetHidden(false)
			end
		end)
	button:SetHandler("OnMouseExit", function()
			ZO_Tooltips_HideTextTooltip()

			highlight:SetHidden(true)
		end)

	button.name = subfilterName
	button.texture = texture
	button.clickable = true
    button.filterCallback = callback
	button.normal = icon.normal
	button.pressed = icon.pressed
	button.dropdownCallbacks = dropdownCallbacks

	if(dropdownCallbacks) then
		AddDropdownFilter(button, dropdownCallbacks)
	end

	self.activeButtons[INVENTORY_BACKPACK] = button
	self.activeButtons[INVENTORY_BANK] = button
	self.activeButtons[INVENTORY_GUILD_BANK] = button

	table.insert(self.subfilters, button)
end

function AdvancedFilterGroup:ActivateButton(newButton)
	local name = newButton.name
	self:ChangeLabel(tooltipSet[name])

    local oldButton = self.activeButtons[GetCurrentInventoryType()]

    --hide old pressed texture
	oldButton:GetNamedChild("Highlight"):SetHidden(true)
	oldButton:GetNamedChild("Texture"):SetTexture(oldButton.normal)
	oldButton:SetEnabled(true)

	--hide old dropdown
	oldButton.dropdown:SetHidden(true)

	--show new pressed texture
	newButton:GetNamedChild("Highlight"):SetHidden(false)
	newButton:GetNamedChild("Texture"):SetTexture(newButton.pressed)
	newButton:SetEnabled(false)

	--show new dropdown
	newButton.dropdown:SetHidden(false)

	--refresh filters
	local itemData = newButton.dropdown.m_comboBox:GetSelectedItemData()
	newButton.dropdown.m_comboBox:SelectItem(itemData)
	SetUpCallbackFilter(newButton, BUTTON_STRING, true)

	--set new active button reference
	self.activeButtons[GetCurrentInventoryType()] = newButton

	--refresh button availability
	AdvancedFilters_RefreshSubfilterButtons()
end

function AdvancedFilterGroup:GetCurrentButton()
	local currentButton = self.activeButtons[GetCurrentInventoryType()]
	return currentButton
end

function AdvancedFilterGroup:ChangeLabel(text)
	self.label:SetText(text)
end

function AdvancedFilterGroup:SetHidden(shouldHide)
	self.control:SetHidden(shouldHide)
end

function AdvancedFilterGroup_RemoveAllFilters()
	local laf = libFilters:GetCurrentLAF(GetCurrentInventoryType())

	libFilters:UnregisterFilter(BUTTON_STRING)
	libFilters:UnregisterFilter(DROPDOWN_STRING)

	if laf ~= nil then
		libFilters:RequestInventoryUpdate(laf)
	end
end
