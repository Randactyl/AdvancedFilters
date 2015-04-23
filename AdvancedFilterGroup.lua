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
local tooltipSet = AF_Strings[lang].TOOLTIPS

--declaration of intent to create object
AdvancedFilterGroup = ZO_Object:Subclass()

--local helpers
local function GetNextIndex()
	INDEX = INDEX + 1
	return INDEX
end

local function MoveHighlightToMe(currentButton, lastButton)
	
end

local function SetUpCallbackFilter(button, filterTag)
	--local laf = libFilters:GetCurrentLAF(GetCurrentInventoryType())
	local possibleLAFs = {
		[1] = LAF_BAGS,
		[2] = LAF_BANK,
		[3] = LAF_GUILDBANK,
		[4] = LAF_STORE,
		[5] = LAF_MAIL,
		[6] = LAF_TRADE,
		[7] = LAF_FENCE,
		[8] = LAF_LAUNDER,
	}

	--first, clear current filters
	for i = 1, #possibleLAFs, 1 do
		libFilters:UnregisterFilter(filterTag, possibleLAFs[i])
	end
	--then register new one
	local callback = button.filterCallback or button.callback
	if(callback == nil) then return end
	for i = 1, #possibleLAFs, 1 do
		libFilters:RegisterFilter(filterTag, possibleLAFs[i], callback)
	end
end

local function OnDropdownSelect(selectedItemData)
	SetUpCallbackFilter(selectedItemData, DROPDOWN_STRING)
end

--interface
function AdvancedFilterGroup:New(groupName, inventoryName)
	local obj = ZO_Object.New(self)
	obj:Init(groupName, inventoryName)
	return obj
end

function AdvancedFilterGroup:Init(groupName, inventoryName)
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
	self.label:SetText(AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS["All"])

	self.divider = self.control:GetNamedChild("Divider")

	self.subfilters = {}
	self.activeButtons = {
		[INVENTORY_BACKPACK] = nil,
		[INVENTORY_BANK] = nil,
		[INVENTORY_GUILD_BANK] = nil,
	}
end

function AdvancedFilterGroup:AddSubfilter(name, icon, callback, dropdownCallbacks, dropdownWidth)
	local function AddDropdownFilter(button, callbackTable, dropdownWidth)
		local dropdown = WINDOW_MANAGER:CreateControlFromVirtual(button:GetName() .. "DropdownFilter", button, "ZO_ComboBox")
		local width = dropdownWidth or 136

		dropdown:SetHidden(true)
		dropdown:SetAnchor(RIGHT, self.control, RIGHT)
		dropdown:SetHeight(24)
		dropdown:SetWidth(width)

		local comboBox = dropdown.m_comboBox
	    comboBox:SetSortsItems(false)

		for _,v in ipairs(callbackTable) do
			comboBox:AddItem(ZO_ComboBox:CreateItemEntry(tooltipSet[v.name], function() OnDropdownSelect(v) end))
		end

		comboBox:SelectFirstItem()
	    comboBox:SetSelectedItemFont("ZoFontGameSmall")
	    comboBox:SetDropdownFont("ZoFontGameSmall")

		button.dropdown = dropdown
	end

	local anchorX = -STARTX + #self.subfilters * -ICON_SIZE

	local button = WINDOW_MANAGER:CreateControlFromVirtual(self.control:GetName() .. name .. "Button", self.control, "AF_Button")
	local texture = button:GetNamedChild("Texture")
	local highlight = button:GetNamedChild("Highlight")

	button:SetAnchor(RIGHT, self.control, RIGHT, anchorX, 0)
	button:SetClickSound(SOUNDS.MENU_BAR_CLICK)
	button:SetHandler("OnClicked", function(clickedButton, name)
            if(not clickedButton.clickable) then return end
			
            self:ActivateButton(clickedButton)
        end)
	button:SetHandler("OnMouseEnter", function(self)
			ZO_Tooltips_ShowTextTooltip(self, TOP, tooltipSet[name])

			if(button.clickable) then
				highlight:SetHidden(false)
			end
		end)
	button:SetHandler("OnMouseExit", function()
			ZO_Tooltips_HideTextTooltip()

			highlight:SetHidden(true)
		end)

	texture:SetTexture(icon.normal)

	highlight:SetTexture(icon.mouseOver)

	self.activeButtons[INVENTORY_BACKPACK] = button
	self.activeButtons[INVENTORY_BANK] = button
	self.activeButtons[INVENTORY_GUILD_BANK] = button

	button.name = name
	if(dropdownCallbacks) then
		AddDropdownFilter(button, dropdownCallbacks, dropdownWidth)
	end
	button.texture = texture
	button.clickable = true
    button.filterCallback = callback
	button.isSelected = false
	button.normal = icon.normal
	button.pressed = icon.pressed

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
	SetUpCallbackFilter(newButton, BUTTON_STRING)
	SetUpCallbackFilter(newButton.dropdown.m_comboBox:GetSelectedItemData(), DROPDOWN_STRING)
	
	--set new active button reference
	self.activeButtons[GetCurrentInventoryType()] = newButton
end

function AdvancedFilterGroup:GetCurrentButton()
	local currentButton = self.activeButtons[GetCurrentInventoryType()]
	return currentButton
end

function AdvancedFilterGroup:ChangeLabel(text)
	self.label:SetText(text)
end

function AdvancedFilterGroup:SetHidden( shouldHide )
	self.control:SetHidden(shouldHide)
end

function AdvancedFilterGroup_RemoveAllFilters()
	libFilters:UnregisterFilter(BUTTON_STRING)
	libFilters:UnregisterFilter(DROPDOWN_STRING)
end