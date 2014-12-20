--init filtering library
local libFilters = LibStub("libFilters")

test = 2354
--local "globals"
local SUBFILTER_HEIGHT = 40
local STARTX = 148
local ICON_SIZE = 32
local INDEX = 0
local HIGHLIGHT_TEXTURE = [[/esoui/art/actionbar/magechamber_lightningspelloverlay_up.dds]]
local BUTTON_STRING = "AdvancedFilters_Button_Filter"
local DROPDOWN_STRING = "AdvancedFilters_Dropdown_Filter"
local prefixes = {
	[INVENTORY_BACKPACK] = "Backpack",
	[INVENTORY_BANK] = "Bank",
	[INVENTORY_GUILD_BANK] = "GuildBank",
}

--possibly unused
local resetting = false
local highlightTexture = nil

--declaration of intent to create object
AdvancedFilterGroup = ZO_Object:Subclass()

--local helpers
local function GetNextIndex()
	INDEX = INDEX + 1
	return INDEX
end

local function AdvancedFilters_GetLanguage()
	local lang = GetCVar("language.2")

	--check for supported languages
	if(lang == "de" or lang == "en" or lang == "fr" or lang == "ru") then return lang end

	--return english if not supported
	return "en"
end

local function MoveHighlightToMe(button)
	highlightTexture:ClearAnchors()
	highlightTexture:SetParent(button)
	highlightTexture:SetAnchor(CENTER, button, CENTER)
	highlightTexture:SetDimensions(ICON_SIZE, ICON_SIZE)
	highlightTexture:SetHidden(false)
end

local function CycleTextures(button, currentSelected)
	if(button == currentSelected) then return end

	if(button.upTexture) then
		highlightTexture:SetHidden(true)
		button:GetNamedChild("Flash"):SetHidden(false)
		button:GetNamedChild("Texture"):SetTexture(button.downTexture)
		button:SetScale(1.5)
		button:SetMouseEnabled(false)
	end

	if(currentSelected and currentSelected.upTexture) then 
		currentSelected:GetNamedChild("Flash"):SetHidden(true)
		currentSelected:GetNamedChild("Texture"):SetTexture(currentSelected.upTexture)
		currentSelected:SetScale(1)
		currentSelected:SetMouseEnabled(true)
	end
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
	}

	--if we got here from ResetToAll(), then don't do anything
   	if resetting == true then return end

	--first, clear current filters
	for i = 1, #possibleLAFs, 1 do
		libFilters:UnregisterFilter(filterTag, possibleLAFs[i])
	end
	--then register new one
	if(button.filterCallback == nil) then return end
	for i = 1, #possibleLAFs, 1 do
		libFilters:RegisterFilter(filterTag, possibleLAFs[i], button.filterCallback)
	end
end

local function OnDropdownSelect(self)
	if(not GetCurrentInventoryType()) then return end
	currentDropdown = self

	SetUpCallbackFilter(self, DROPDOWN_STRING)
	-- PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
end

--interface
function AdvancedFilterGroup:New(groupName)
	local obj = ZO_Object.New(self)
	obj:Init(groupName)
	return obj
end

function AdvancedFilterGroup:Init(groupName)
	local _,_,_,_,_,offsetY = ZO_PlayerInventorySortBy:GetAnchor() --get upper anchor position for subfilter bar
	local parent = ZO_PlayerInventory --parent for the subfilter bar control

	self.offsetY = offsetY

	self.name = groupName --unique identifier

	self.control = WINDOW_MANAGER:CreateControl("AdvancedFilterGroup" .. groupName, parent, CT_CONTROL, GetNextIndex)
	self.control:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, offsetY)
	self.control:SetDimensions(parent:GetWidth(), SUBFILTER_HEIGHT)
	self.control:SetHidden(true)

	self.label = WINDOW_MANAGER:CreateControl(self.control:GetName() .. "Label", self.control, CT_LABEL)
	self.label:SetAnchor(LEFT, self.control, LEFT, -45)
	self.label:SetFont("ZoFontGameSmall")
	self.label:SetHidden(false)
	self.label:SetVerticalAlignment(TEXT_ALIGN_CENTER)
	self.label:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
	self.label:SetDimensions(136, SUBFILTER_HEIGHT)
	self.label:SetText(string.upper(AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS["All"]))

	self.divider = WINDOW_MANAGER:CreateControlFromVirtual(self.control:GetName() .. "Divider", self.control, "ZO_WideHorizontalDivider")
	self.divider:SetHidden(false)
	self.divider:SetAnchor(TOPLEFT, self.control, BOTTOMLEFT)
	self.divider:SetAnchor(TOPRIGHT, self.control, BOTTOMRIGHT)
	self.divider:SetAlpha(0.3)

	if(not highlightTexture) then
		highlightTexture = WINDOW_MANAGER:CreateControl("AdvancedFilterGroupHighlight", self.control, CT_TEXTURE)
		highlightTexture:SetDimensions(ICON_SIZE, ICON_SIZE)
		highlightTexture:SetTexture(HIGHLIGHT_TEXTURE)
		highlightTexture:SetTextureCoords(0.25, 0.75, 0.25, 0.75)
		highlightTexture:SetColor(1, 1, 1, .75)
	end

	self.subfilters = {}
	self.activeButtons = {
		[INVENTORY_BACKPACK] = nil,
		[INVENTORY_BANK] = nil,
		[INVENTORY_GUILD_BANK] = nil,
	}
end

function AdvancedFilterGroup:AddSubfilter(name, icon, callback, dropdownCallbacks, dropdownWidth)
	local tooltipSet = AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS

	local anchorX = -STARTX + #self.subfilters * -ICON_SIZE

	local subfilter = WINDOW_MANAGER:CreateControl( self.control:GetName() .. name, self.control, CT_CONTROL )
	subfilter.name = name
	subfilter:SetAnchor(RIGHT, self.control, RIGHT, anchorX, 0)
	subfilter:SetDimensions(ICON_SIZE, ICON_SIZE)

	subfilter.dropdown = nil
	if(dropdownCallbacks) then
		dropdown = self:AddDropdownFilter( subfilter, dropdownCallbacks, dropdownWidth )
	end

	local button = WINDOW_MANAGER:CreateControl( subfilter:GetName() .. "Button", subfilter, CT_BUTTON )
	button:SetAnchor(TOPLEFT, subfilter, TOPLEFT)
	button:SetDimensions(ICON_SIZE, ICON_SIZE)
	button:SetClickSound(SOUNDS.MENU_BAR_CLICK)
	button:SetHandler("OnClicked", function(button, name)
            if(not subfilter.clickable) then return end
			
			if(subfilter.dropdown and subfilter.dropdown:IsHidden()) then
                subfilter.dropdown:SetHidden(false)
            end
            local currentSelected = self.activeButtons[GetCurrentInventoryType()]
            if(button == currentSelected) then return end
            self:ActivateButton(button, name)
        end)
    button.filterCallback = callback
	button.isSelected = false
	button.upTexture = icon.upTexture
	button.downTexture = icon.downTexture
	subfilter.button = button
	self.activeButtons[INVENTORY_BACKPACK] = button
	self.activeButtons[INVENTORY_BANK] = button
	self.activeButtons[INVENTORY_GUILD_BANK] = button


	local texture = WINDOW_MANAGER:CreateControl( button:GetName() .. "Texture", button, CT_TEXTURE )
	texture:SetAnchor(CENTER, subfilter, CENTER)
	texture:SetDimensions(ICON_SIZE, ICON_SIZE)
	texture:SetTexture(icon.upTexture or icon)
	subfilter.texture = texture

	local flash
	if(icon.flash) then
		flash = WINDOW_MANAGER:CreateControl( button:GetName() .. "Flash", button, CT_TEXTURE)
		flash:SetAnchor(CENTER, subfilter, CENTER)
		flash:SetDimensions(ICON_SIZE, ICON_SIZE)
		flash:SetTexture(icon.flash)
		flash:SetHidden(true)
	end

	button:SetHandler("OnMouseEnter", function()
			ZO_Tooltips_ShowTextTooltip(self, TOP, tooltipSet[name])

			if(flash and subfilter.clickable) then
				flash:SetHidden(false)
			end
		end)
	button:SetHandler("OnMouseExit", function()
			ZO_Tooltips_HideTextTooltip()

			if(flash) then
				flash:SetHidden(true)
			end
		end)

	subfilter.clickable = true

	table.insert(self.subfilters, subfilter)
end

function AdvancedFilterGroup:AddDropdownFilter(parent, callbackTable, dropdownWidth)
	local tooltipSet = AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS
	local dropdown = WINDOW_MANAGER:CreateControlFromVirtual(parent:GetName() .. "DropdownFilter", parent, "ZO_ComboBox")
	local width = dropdownWidth or 136

	parent.dropdown = dropdown
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
	return dropdown
end

function AdvancedFilterGroup:ActivateButton(button, name)
	local tooltipSet = AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS
	self:ChangeLabel(tooltipSet[name])
    --MoveHighlightToMe(button)

    local currentSelected = self.activeButtons[GetCurrentInventoryType()]

    if(not GetCurrentInventoryType() or self == currentSelected) then return end

	if(self.filterCallback and currentSelected and currentSelected.filterCallback and not (self == currentSelected)) then 
		local dropdown = currentSelected:GetParent().dropdown
		if(dropdown) then
			dropdown.m_comboBox:SelectFirstItem()
			dropdown:SetHidden(true)
		end
	end

	CycleTextures(button, currentSelected)
	self.activeButtons[GetCurrentInventoryType()] = button
	SetUpCallbackFilter(button, BUTTON_STRING)
end

function AdvancedFilterGroup:GetCurrentButton()
	local currentButton = self.activeButtons[GetCurrentInventoryType()]
	return currentButton
end

function AdvancedFilterGroup:ChangeLabel( text )
	self.label:SetText(string.upper(text))
end

function AdvancedFilterGroup:SetHidden( shouldHide )
	self.control:SetHidden(shouldHide)
end

function AdvancedFilterGroup:GetControl()
	return self.control
end

function AdvancedFilterGroup_ResetToAll()
	libFilters:UnregisterFilter(BUTTON_STRING)
	libFilters:UnregisterFilter(DROPDOWN_STRING)
end