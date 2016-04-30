local MAJOR, MINOR = "LibMotifCategories-1.0", 1
local LibMotifCategories, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibMotifCategories then return end

LMC_MOTIF_CATEGORY_NORMAL = 1
LMC_MOTIF_CATEGORY_RARE = 2
LMC_MOTIF_CATEGORY_ALLIANCE = 3
LMC_MOTIF_CATEGORY_EXOTIC = 4
LMC_MOTIF_CATEGORY_CROWN = 5

local isLMCInitialized = false

local categoryLookup = {
    ["33150"] = LMC_MOTIF_CATEGORY_NORMAL, --Argonian
    ["33194"] = LMC_MOTIF_CATEGORY_NORMAL, --Bosmer
    ["33251"] = LMC_MOTIF_CATEGORY_NORMAL, --Breton
    ["33252"] = LMC_MOTIF_CATEGORY_NORMAL, --Altmer
    ["33253"] = LMC_MOTIF_CATEGORY_NORMAL, --Dunmer
    ["33255"] = LMC_MOTIF_CATEGORY_NORMAL, --Khajiit
    ["33256"] = LMC_MOTIF_CATEGORY_NORMAL, --Nord
    ["33257"] = LMC_MOTIF_CATEGORY_NORMAL, --Orc
    ["33258"] = LMC_MOTIF_CATEGORY_NORMAL, --Redguard

    ["46149"] = LMC_MOTIF_CATEGORY_RARE, --Barbaric
    ["46150"] = LMC_MOTIF_CATEGORY_RARE, --Primal
    ["46151"] = LMC_MOTIF_CATEGORY_RARE, --Daedric
    ["46152"] = LMC_MOTIF_CATEGORY_RARE, --Ancient Elf
    ["71766"] = LMC_MOTIF_CATEGORY_RARE, --Soul-Shriven
    
    ["33254"] = LMC_MOTIF_CATEGORY_ALLIANCE, --Imperial
    ["71738"] = LMC_MOTIF_CATEGORY_ALLIANCE, --Aldmeri Dominion
    ["71740"] = LMC_MOTIF_CATEGORY_ALLIANCE, --Ebonheart Pact
    ["71742"] = LMC_MOTIF_CATEGORY_ALLIANCE, --Daggerfall Covenant
    
    ["57587"] = LMC_MOTIF_CATEGORY_EXOTIC, --Dwemer
    ["59922"] = LMC_MOTIF_CATEGORY_EXOTIC, --Xivkyn
    ["64687"] = LMC_MOTIF_CATEGORY_EXOTIC, --Akaviri
    ["64689"] = LMC_MOTIF_CATEGORY_EXOTIC, --Glass
    ["64713"] = LMC_MOTIF_CATEGORY_EXOTIC, --Mercenary
    ["69555"] = LMC_MOTIF_CATEGORY_EXOTIC, --Ancient Orc
    ["71538"] = LMC_MOTIF_CATEGORY_EXOTIC, --Outlaw
    ["71582"] = LMC_MOTIF_CATEGORY_EXOTIC, --Trinimac
    ["71584"] = LMC_MOTIF_CATEGORY_EXOTIC, --Malacath
    ["75370"] = LMC_MOTIF_CATEGORY_EXOTIC, --Thieves Guild
    ["76910"] = LMC_MOTIF_CATEGORY_EXOTIC, --Assassins League
    ["76914"] = LMC_MOTIF_CATEGORY_EXOTIC, --Abah's Watch
    
    ["71668"] = LMC_MOTIF_CATEGORY_CROWN, --Crown Mimic Stone
}

local newLookup = {
    ["71538"] = LMC_MOTIF_CATEGORY_EXOTIC, --Outlaw
    ["71582"] = LMC_MOTIF_CATEGORY_EXOTIC, --Trinimac
    ["71584"] = LMC_MOTIF_CATEGORY_EXOTIC, --Malacath
    ["71738"] = MOTIF_CATEGORY_ALLIANCE, --Aldmeri Dominion
    ["71740"] = MOTIF_CATEGORY_ALLIANCE, --Ebonheart Pact
    ["71742"] = MOTIF_CATEGORY_ALLIANCE, --Daggerfall Covenant
    ["71766"] = LMC_MOTIF_CATEGORY_RARE, --Soul-Shriven
}

--ESO 2.4.0
if GetAPIVersion() == 100015 then
    newLookup = {
        ["75370"] = LMC_MOTIF_CATEGORY_EXOTIC, --Thieves Guild
        ["76910"] = LMC_MOTIF_CATEGORY_EXOTIC, --Assassins League
        ["76914"] = LMC_MOTIF_CATEGORY_EXOTIC, --Abah's Watch
    }
end

function LibMotifCategories:GetCategory(itemLink)
    local itemId = select(4, ZO_LinkHandler_ParseLink(itemLink))
    local isNew = false
    
    if newLookup[itemId] then isNew = true end
    
    return categoryLookup[itemId], isNew
end

function LibMotifCategories:GetLocalizedCategoryName(categoryConst)
    if not isLMCInitialized then self:Initialize() end
    
    return self.strings[categoryConst]
end

function LibMotifCategories:Initialize()
    isLMCInitialized = true
    
    local strings = {
        ["de"] = {
            "Normal", "Selten", "Allianz", "Exotisch", "Kronen",
        },
        ["en"] = {
            "Normal", "Rare", "Alliance", "Exotic", "Crown",
        },
        ["fr"] = {
            "Normal", "Rare", "Alliance", "Exotique", "Couronnes",
        },
    }
    
    local lang = GetCVar("language.2")
    
    if strings[lang] then
        self.strings = strings[lang]
    else
        self.strings = strings["en"]
    end
end