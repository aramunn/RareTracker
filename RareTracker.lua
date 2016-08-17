require "Apollo"
require "Window"

-----------------------------------------------------------------------------------------------
-- Module Definition
-----------------------------------------------------------------------------------------------
local RareTracker = {}

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
local normalTextColor = ApolloColor.new("xkcdBrightSkyBlue")
local selectedTextColor = ApolloColor.new("UI_BtnTextHoloPressedFlyby")
local activeTextColor = ApolloColor.new("xkcdAppleGreen")
local inactiveTextColor = ApolloColor.new("xkcdCherryRed")
local customUnitColor = ApolloColor.new("xkcdBloodOrange")
local karrAchievements = {
    ["EN"] = {
        -- Dominion Only
        ["I Like it Rare: Auroria"] = true,
        ["I Like it Rare: Deradune"] = true,
        ["I Like it Rare: Ellevar"] = true,
        -- Exile Only
        ["I Like it Rare: Algoroc"] = true,
        ["I Like it Rare: Celestion"] = true,
        ["I Like it Rare: Galeras"] = true,
        -- Common
        ["Apex Predator"] = true,
        ["Artic Extinction"] = true,
        ["Exotic Executioner: Alizar"] = true,
        ["Exotic Executioner: Arcterra"] = true,
        ["Exotic Executioner: Blighthaven"] = true,
        ["Exotic Executioner: Farside"] = true,
        ["Exotic Executioner: Halon Ring"] = true,
        ["Exotic Executioner: Isigrol"] = true,
        ["Exotic Executioner: Malgrave"] = true,
        ["Exotic Executioner: Olyssia"] = true,
        ["Exotic Executioner: Southern Grimvault"] = true,
        ["Exotic Executioner: Star-Comm Basin"] = true,
        ["Exotic Executioner: The Defile"] = true,
        ["Exotic Executioner: Western Grimvault"] = true,
        ["Exotic Executioner: Wilderrun"] = true,
        ["Exotic Executioner: Whitevale"] = true,
        ["I Like it Rare: Arcterra"] = true,
        ["I Like it Rare: Blighthaven"] = true,
        ["I Like it Rare: Containment Facility R-12"] = true,
        ["I Like it Rare: Crimson Badlands"] = true,
        ["I Like it Rare: Farside"] = true,
        ["I Like it Rare: Malgrave"] = true,
        ["I Like it Rare: Northren Wastes"] = true,
        ["I Like it Rare: Southern Grimvault"] = true,
        ["I Like it Rare: Star-Comm Basin"] = true,
        ["I Like it Rare: The Defile"] = true,
        ["I Like it Rare: Western Grimvault"] = true,
        ["I Like it Rare: Wilderrun"] = true,
        ["World Boss: Big Boss Hunter"] = true
    },
    ["DE"] = {
        -- Dominion Only
        ["Die Rote Liste: Auroria"] = true,
        ["Die Rote Liste: Deradune"] = true,
        ["Die Rote Liste: Ellevar"] = true,
        -- Exile Only
        ["Die Rote Liste: Algoroc"] = true,
        ["Die Rote Liste: Celestion"] = true,
        ["Die Rote Liste: Galeras"] = true,
        -- Common
        ["Arktische Ausrottung"] = true,
        ["Die Rote Liste: Arkterra"] = true,
        ["Die Rote Liste: Blutrotes Hinterland"] = true,
        ["Die Rote Liste: Die Verderbnis"] = true,
        ["Die Rote Liste: Fäulnisrefugium"] = true,
        ["Die Rote Liste: Fernseits"] = true,
        ["Die Rote Liste: Isolationsanlage R-12"] = true,
        ["Die Rote Liste: Jochgrab"] = true,
        ["Die Rote Liste: Nördliches Ödland"] = true,
        ["Die Rote Liste: StarKom-Becken"] = true,
        ["Die Rote Liste: Südliche Gramkammer"] = true,
        ["Die Rote Liste: Westliche Gramkammer"] = true,
        ["Die Rote Liste: Wildlauf"] = true,
        ["Exotenschreck: Alizar"] = true,
        ["Exotenschreck: Arkterra"] = true,
        ["Exotenschreck: Die Verderbnis"] = true,
        ["Exotenschreck: Fäulnisrefugium"] = true,
        ["Exotenschreck: Fernseits"] = true,
        ["Exotenschreck: Halonring"] = true,
        ["Exotenschreck: Isigrol"] = true,
        ["Exotenschreck: Jochgrab"] = true,
        ["Exotenschreck: Olyssia"] = true,
        ["Exotenschreck: StarKom-Becken"] = true,
        ["Exotenschreck: Südliche Gramkammer"] = true,
        ["Exotenschreck: Weißtal"] = true,
        ["Exotenschreck: Westliche Gramkammer"] = true,
        ["Exotenschreck: Wildlauf"] = true,
        ["Spitze der Nahrungspyramide"] = true,
        ["Weltboss: Großbossjäger"] = true
    },
    ["FR"] = {
        -- Dominion Only
        ["Espèces en voie de disparition : Auroria"] = true,
        ["Espèces en voie de disparition : Déradune"] = true,
        ["Espèces en voie de disparition : Ellevar"] = true,
        -- Exile Only
        ["Espèces en voie de disparition : Célestion"] = true,
        ["Espèces en voie de disparition : Sombreflore"] = true,
        -- TODO: Check Exile sides
        -- Common
        ["Borreau exotique: Alizar"] = true,
        ["Borreau exotique: Annequ d'Halon"] = true,
        ["Borreau exotique: Arcterra"] = true,
        ["Borreau exotique: Bassin de Star-Comm"] = true,
        ["Borreau exotique: Infection"] = true,
        ["Borreau exotique: Isigrol"] = true,
        ["Borreau exotique: Maltombe"] = true,
        ["Borreau exotique: Mornegeôle ouest"] = true,
        ["Borreau exotique: Mornegeôle sud"] = true,
        ["Borreau exotique: Olyssia"] = true,
        ["Borreau exotique: Outre-horizon"] = true,
        ["Borreau exotique: Refuge Impur"] = true,
        ["Borreau exotique: Sombreflore"] = true,
        ["Borreau exotique: Valblanc"] = true,
        ["Boss : Le Saint des chasseurs"] = true,
        ["Espèces en voie de disparition : Arcterra"] = true, -- Arcterra
        ["Espèces en voie de disparition : Basin de Star-Comm"] = true, -- Starcomm Basin
        ["Espèces en voie de disparition : Infection"] = true,  -- The Defile
        ["Espèces en voie de disparition : Maltombe"] = true, -- Malgrave
        ["Espèces en voie de disparition : Mornegeôle ouest"] = true, -- Western Grimvault
        ["Espèces en voie de disparition : Mornegeôle sud"] = true, -- Southern Grimvault
        ["Espèces en voie de disparition : Outre-horizon"] = true,  -- Farside
        ["Espèces en voie de disparition : Refuge Impur"] = true, -- Blighthaven
        ["Espèces en voie de disparition : Septentrion Morne"] = true,  -- Northren Wastes
        ["Espèces en voie de disparition : Terres Maudites Écarlates"] = true,  -- Badlands
        ["Espèces en voie de disparition : Unité de confinement R-12"] = true,  -- R12
        ["Extinction arctique"] = true,
        ["Prédateur ultime"] = true,
    }
}
-----------------------------------------------------------------------------------------------
-- Helper Functions
-----------------------------------------------------------------------------------------------
function trim(s)
    return s:match'^%s*(.*%S)' or ''
end

function table.find(val, list)
    for _,v in pairs(list) do
        if v == val then
            return true
        end
    end

    return false
end

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}

        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
    copy = orig
    end

    return copy
end

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function RareTracker:new(o)
    o = o or {}

    setmetatable(o, self)

    self.__index = self
    self.nMajorVersion = 2
    self.nMinorVersion = 2
    self.nPatchVersion = 0
    self.bNewRares = false
    self.arRareMobs = {}
    self.arIgnoredTypes = { "Mount", "Scanner", "Simple" }
    self.wndSelectedRare = nil
    self.arDefaultRareNames = {}

    local strCancelLocale = Apollo.GetString("CRB_Cancel")

    if strCancelLocale == "Cancel" then
        self.strLocale = "EN"
    elseif strCancelLocale == "Annuler" then
        self.strLocale = "FR"
    elseif strCancelLocale == "Abbrechen" then
        self.strLocale = "DE"
    else
        self.strLocale = "EN"
    end

    return o
end

function RareTracker:Init()
    local bHasConfigureFunction = true
    local strConfigureButtonText = "RareTracker"
    local tDependencies = {}

    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end

-----------------------------------------------------------------------------------------------
-- OnLoad
--
-- Called by the client to properly load the Addon into the game.
-- We use this opportunity to load our XML file and start building our form objects.
-----------------------------------------------------------------------------------------------
function RareTracker:OnLoad()
    self.xmlDoc = XmlDoc.CreateFromFile("RareTracker.xml")
    self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- OnDocLoaded
--
-- This event is called when the client has finished loading the XML document from he OnLoad
-- event. In this callback we build up the actual form objects.
-----------------------------------------------------------------------------------------------
function RareTracker:OnDocLoaded()
    if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
        self.wndMain = Apollo.LoadForm(self.xmlDoc, "RareTrackerForm", nil, self)

        if self.wndMain == nil then
            Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
            return
        end

        self.trackedRaresWindow = self.wndMain:FindChild("TrackedRaresList")
        self.wndMain:Show(false, true)
        self:LoadPosition()

        Apollo.RegisterSlashCommand("raretracker", "OnSlashCommand", self)
        Apollo.RegisterSlashCommand("rt", "OnSlashCommand", self)
        Apollo.RegisterEventHandler("UnitCreated", "OnUnitCreated", self)
        Apollo.RegisterEventHandler("UnitDestroyed", "OnUnitDestroyed", self)
        Apollo.RegisterEventHandler("WindowManagementReady", "OnWindowManagementReady", self)

        self.timer = ApolloTimer.Create(1/60, true, "OnTimer", self)
        self.rotationTimer = ApolloTimer.Create(1/5, true, "OnTimer", self)

        self.autoCloseTimer = ApolloTimer.Create(5, false, "OnAutoCloseTimer", self)
        self.autoCloseTimer:Stop()

        self:InitConfigOptions()
        self:InitTrackMaster()

        if not self.enableTracking then
            Apollo.RemoveEventHandler("UnitCreated", self)
        end

        self:InitRares()
    end
end

-----------------------------------------------------------------------------------------------
-- InitConfigOptions
--
-- Initializes the various configuration options of our Addon and sets them to their default
-- values if they have not been defined yet.
-----------------------------------------------------------------------------------------------
function RareTracker:InitConfigOptions()
    if self.minLevel == nil then
        self.minLevel = 1
    end

    if self.maxTrackingDistance == nil then
        self.maxTrackingDistance = 1000
    end

    if self.enableTracking == nil then
        self.enableTracking = true
    end

    if self.broadcastToParty == nil then
        self.broadcastToParty = true
    end

    if self.playSound == nil then
        self.playSound = true
    end

    if self.showIndicator == nil then
        self.showIndicator = true
    end

    if self.closeEmptyTracker == nil then
        self.closeEmptyTracker = true
    end

    if self.arCustomNames == nil then
        self.arCustomNames = {}
    end

    if (self.savedMajorVersion == nil or self.savedMinorVersion == nil or self.savedMajorVersion < self.nMajorVersion) and self.bNewRares and self.arRareNames ~= nil then
        self:ShowResetRareListPrompt()
    elseif self.savedMinorVersion ~= nil and self.savedMinorVersion < self.nMinorVersion and self.bNewRares and self.arRareNames ~= nil then
        self:ShowResetRareListPrompt()
    end

    if self.arRareNames == nil then
        self.arRareNames = self.arDefaultRareNames
    end

    if self.bTrackKilledRares == nil then
        self.bTrackKilledRares = false
    end
end

-----------------------------------------------------------------------------------------------
-- ShowResetRareListPrompt
--
-- Shows the prompt to reset the list of rares.
-- This helps people refresh their collection of rare mobs when we update the Addon and
-- new rares to our internal list.
-----------------------------------------------------------------------------------------------
function RareTracker:ShowResetRareListPrompt()
    self.resetWindow = Apollo.LoadForm("RareTracker.xml", "ResetConfirmationForm", nil, self)
end

-----------------------------------------------------------------------------------------------
-- OnResetRaresButton
--
-- When the user clicks the reset button, we rebuild the entire internal list of rare mobs
-- usng what is default in the default table.
-----------------------------------------------------------------------------------------------
function RareTracker:OnResetRaresButton()
    self.arRareNames = shallowcopy(self.arDefaultRareNames)
    if self.wndConfig ~= nil then
        self.wndConfig:Close()
    end
    self.resetWindow:Close()
end

-----------------------------------------------------------------------------------------------
-- OnResetWindowClose
--
-- This method is called when the user clicks on the close button of the reset window.
-- We simply close the window in this case.
-----------------------------------------------------------------------------------------------
function RareTracker:OnResetWindowClose()
    self.resetWindow:Close()
end

-----------------------------------------------------------------------------------------------
-- InitTrackMaster
--
-- Initializes our hooks for TrackMaster if the addon is loaded.
-- This allows our Addon to draw lines using the TrackMaster interface to the various rares
-- that have been discovered.
-----------------------------------------------------------------------------------------------
function RareTracker:InitTrackMaster()
    self.trackMaster = Apollo.GetAddon("TrackMaster")

    if self.trackMaster ~= nil then
        if self.trackMasterLine == nil then
            self.trackMasterLine = 1
        end

        if self.bTrackMasterEnabled == nil then
            self.bTrackMasterEnabled = true
        end

        self.trackMaster:AddToConfigMenu(self.trackMaster.Type.Track, "   RareTracker", {
            CanFire = false,
            CanEnable = true,
            IsChecked = self.bTrackMasterEnabled,
            OnEnableChanged = function(isEnabled)
                self.bTrackMasterEnabled = isEnabled
            end,
            LineNo = self.trackMasterLine,

            OnLineChanged = function(lineNo)
                self.trackMaster:SetTarget(nil, -1, self.trackMasterLine)

                if self.wndSelectedRare ~= nil then
                    self.wndSelectedRare:FindChild("Name"):SetTextColor(normalTextColor)
                    self.wndSelectedRare = nil
                end

                self.trackMasterLine = lineNo
            end
        })
    end
end

-----------------------------------------------------------------------------------------------
-- StorePositions
--
-- Stores the windows positions in the local table so it can be saved.
-----------------------------------------------------------------------------------------------
function RareTracker:StorePosition()
    self.tLocations = {
        tMainWindowLocation = self.wndMain and self.wndMain:GetLocation():ToTable(),
        tConfigWindowLocation = self.wndConfig and self.wndConfig:GetLocation():ToTable()
    }
end

-----------------------------------------------------------------------------------------------
-- LoadPositions
--
-- Restores the windows positions by reading out the location information from the table.
-----------------------------------------------------------------------------------------------
function RareTracker:LoadPosition()
    if self.tLocations and self.tLocations.tMainWindowLocation and self.wndMain then
        local tLocation = WindowLocation.new(self.tLocations.tMainWindowLocation)
        self.wndMain:MoveToLocation(tLocation)
    end

    if self.tLocations and self.tLocations.tConfigWindowLocation and self.wndConfig then
        local tLocation = WindowLocation.new(self.tLocations.tConfigWindowLocation)
        self.wndConfig:MoveToLocation(tLocation)
    end
end

-----------------------------------------------------------------------------------------------
-- OnSave
--
-- Callback from the Client when the Addon needs to save it's data.
-----------------------------------------------------------------------------------------------
function RareTracker:OnSave(eLevel)
    if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then
        return nil
    end

    local tSavedData = {}

    self:StorePosition()

    if (type(self.minLevel) == 'number') then
        tSavedData.minLevel = math.floor(self.minLevel)
    end

    if (type(self.maxTrackingDistance) == 'number') then
        tSavedData.maxTrackingDistance = math.floor(self.maxTrackingDistance)
    end

    tSavedData.enableTracking = self.enableTracking
    tSavedData.broadcastToParty = self.broadcastToParty
    tSavedData.playSound = self.playSound
    tSavedData.showIndicator = self.showIndicator
    tSavedData.closeEmptyTracker = self.closeEmptyTracker
    tSavedData.rareNames = self.arRareNames
    tSavedData.customNames = self.arCustomNames
    tSavedData.trackMasterLine = self.trackMasterLine
    tSavedData.trackMasterEnabled = self.bTrackMasterEnabled
    tSavedData.savedMinorVersion = self.nMinorVersion
    tSavedData.savedMajorVersion = self.nMajorVersion
    tSavedData.savedPatchVersion = self.nPatchVersion
    tSavedData.tLocations = self.tLocations
    tSavedData.bTrackRares = self.bTrackKilledRares

    return tSavedData
end

-----------------------------------------------------------------------------------------------
-- OnRestore
--
-- Callback from the client when the Addon has to restore any saved data.
-----------------------------------------------------------------------------------------------
function RareTracker:OnRestore(eLevel, tData)
    if eLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then
        return nil
    end

    if (tData.minLevel ~= nil) then
        self.minLevel = tData.minLevel
    end

    if (tData.maxTrackingDistance ~= nil) then
        self.maxTrackingDistance = tData.maxTrackingDistance
    end

    if (tData.playSound ~= nil) then
        self.playSound = tData.playSound
    end

    if (tData.showIndicator ~= nil) then
        self.showIndicator = tData.showIndicator
    end

    if (tData.enableTracking ~= nil) then
        self.enableTracking = tData.enableTracking
    end

    if (tData.broadcastToParty ~= nil) then
        self.broadcastToParty = tData.broadcastToParty
    end

    if (tData.closeEmptyTracker ~= nil) then
        self.closeEmptyTracker = tData.closeEmptyTracker
    end

    if (tData.rareNames ~= nil) then
        self.arRareNames = tData.rareNames
    end

    if (tData.customNames ~= nil) then
        self.arCustomNames = tData.customNames
    end

    if (tData.trackMasterLine ~= nil) then
        self.trackMasterLine = tData.trackMasterLine
    end

    if (tData.trackMasterEnabled ~= nil) then
        self.bTrackMasterEnabled = tData.trackMasterEnabled
    end

    if (tData.savedMajorVersion ~= nil) then
        self.savedMajorVersion = tData.savedMajorVersion
    end

    if (tData.savedMinorVersion ~= nil) then
        self.savedMinorVersion = tData.savedMinorVersion
    end

    if (tData.tLocations ~= nil) then
        self.tLocations = tData.tLocations
    end

    if (tData.bTrackRares ~= nil) then
        self.bTrackKilledRares = tData.bTrackRares
    end
end

-----------------------------------------------------------------------------------------------
-- OnWindowManagementReady
--
-- Callback event from the client to inform the Addon that the window management is ready
-- and can be used to handle window positions.
-- We use this opportunity to hook into it and let the client store our window positions.
-----------------------------------------------------------------------------------------------
function RareTracker:OnWindowManagementReady()
    Event_FireGenericEvent("WindowManagementRegister", {wnd = self.wndMain, strName = "RareTracker"})
    Event_FireGenericEvent("WindowManagementAdd", {wnd = self.wndMain, strName = "RareTracker"})
end

-----------------------------------------------------------------------------------------------
-- OnSlashCommand
--
-- Callback for every time the user types the slash command of our addon.
-- When this happens, we show the main window.
-----------------------------------------------------------------------------------------------
function RareTracker:OnSlashCommand()
    self.wndMain:Invoke()
    self:LoadPosition()
end

function RareTracker:OnClose()
    self:StorePosition()
    self.wndMain:Close()
end

function RareTracker:OnTimer()
    local trackObj, distance

    for idx,item in pairs(self.arRareMobs) do
        if item.inactive or item.unit == nil then
            if self:GetDistance(item.position) > self.maxTrackingDistance then
                trackObj = nil
                self:RemoveTrackedRare(item.wnd)
            else
                trackObj = item.position
            end

        elseif item.unit:IsDead() then
            trackObj = nil
            self:RemoveTrackedRare(item.wnd)
        else --alive and active
        trackObj = item.unit
        end

        if trackObj ~= nil then
            distance = self:GetDistance(trackObj)
            item.wnd:FindChild("Distance"):SetText(string.format("%d", distance) .. " m")
        end
    end
end

-----------------------------------------------------------------------------------------------
-- OnAutoCloseTimer
--
-- Callback for our timer function, which automatically closes the window when the 
-- timer expires
-----------------------------------------------------------------------------------------------
function RareTracker:OnAutoCloseTimer()
    if #self.trackedRaresWindow:GetChildren() == 0 and self.closeEmptyTracker then
        self:StorePosition()
        self.wndMain:Close()
    end
end

-----------------------------------------------------------------------------------------------
-- TrackableUnit
--
-- Determines whether the unit is to be tracked by the Addon or not.
-- When the unit is considered valid, alive, not a player and the level matches
-- the minimum level for tracking, then we consider this a trackable unit.
-----------------------------------------------------------------------------------------------
function RareTracker:TrackeableUnit(unit)
    return unit:IsValid() and not unit:IsDead() and not unit:IsACharacter() and ((unit:GetLevel() or self.minLevel) >= self.minLevel)
end

-----------------------------------------------------------------------------------------------
-- OnUnitCreated
--
-- Callback by the client whenever a new unit is created into the world.
-- We use this to determine if this is a rare mob we need to track and configure the popup
-- window when we have to.
-----------------------------------------------------------------------------------------------
function RareTracker:OnUnitCreated(unitCreated)
    -- We're going to ignore specific types for tracking.
    -- They are defined in the arIgnoredTypes variable.
    if table.find(unitCreated:GetType(), self.arIgnoredTypes) then return end

    local strUnitName = trim(unitCreated:GetName())

    -- If we already killed this mob, and user doesn't track killed rares
    -- then ignore it.
    if self.achievementEntries[strUnitName] and not self.bTrackKilledRares then return end

    -- If we track this unit, then display it!
    if self:TrackeableUnit(unitCreated) and (table.find(strUnitName, self.arRareNames) or table.find(strUnitName, self.arCustomNames)) then
        local unitRare = self.arRareMobs[unitCreated:GetName()]

        if not unitRare then
            self:AddTrackedRare(unitCreated)

            if self.playSound then
                Sound.Play(Sound.PlayUIExplorerScavengerHuntAdvanced)
            end

            if self.broadcastToParty and GroupLib.InGroup() then
                -- no quick way to party chat, need to find the channel first
                for _,channel in pairs(ChatSystemLib.GetChannels()) do
                    if channel:GetType() == ChatSystemLib.ChatChannel_Party then
                        channel:Send("Rare detected: " .. unitCreated:GetName())
                    end
                end
            end

            self.wndMain:Invoke()
        elseif unitRare.inactive then
            -- The mob was destroyed but has been found again
            self:ActivateUnit(unitRare, unitCreated)
        end
    end
end

-----------------------------------------------------------------------------------------------
-- OnUnitDestroyed
--
-- Callback from the client whenever a unit in the world is destroyed.
-- We will check if we tracked this unit, and remove it from our collection to reduce
-- memory consumption
-----------------------------------------------------------------------------------------------
function RareTracker:OnUnitDestroyed(unitDestroyed)
    local unitDestroyedRare = self.arRareMobs[unitDestroyed:GetName()]
    if unitDestroyedRare ~= nil then
        self:DeactivateUnit(unitDestroyedRare)
    end
end

-----------------------------------------------------------------------------------------------
-- AdddTrackedRare
--
-- Creates a new entry in our list to track the rare unit.
-----------------------------------------------------------------------------------------------
function RareTracker:AddTrackedRare(unitRare)
    local wndEntry = Apollo.LoadForm("RareTracker.xml", "TrackedRare", self.trackedRaresWindow, self)
    local strName = unitRare:GetName()

    self.arRareMobs[strName] = {
        wnd = wndEntry,
        position = unitRare:GetPosition(),
        name = strName
    }

    local wndName = wndEntry:FindChild("Name")
    local wndDistance = wndEntry:FindChild("Distance")
    local wndIcon = wndEntry:FindChild("AchievementIcon")

    if wndName then
        wndName:SetText(strName)
    end

    -- If we have added the Icon, show it depending on the kill status of Achievement
    if wndIcon then
        wndIcon:Show(self.achievementEntries[strName])
    end

    self.trackedRaresWindow:ArrangeChildrenVert()
    self:ActivateUnit(self.arRareMobs[strName], unitRare)
end

-----------------------------------------------------------------------------------------------
-- RemoveTrackedRare
--
-- Removes the tracked rare unit from the list.
-----------------------------------------------------------------------------------------------
function RareTracker:RemoveTrackedRare(wndControl)
    if wndControl == self.wndSelectedRare then
        self.wndSelectedRare = nil
    end

    self.arRareMobs[wndControl:GetData().name] = nil

    wndControl:Destroy()

    if self.trackMaster ~= nil then
        self.trackMaster:SetTarget(nil, -1, self.trackMasterLine)
    end

    if #self.trackedRaresWindow:GetChildren() == 0 then
        self.autoCloseTimer:Start()
    end

    self.trackedRaresWindow:ArrangeChildrenVert()
end

-----------------------------------------------------------------------------------------------
-- ActivateUnit
--
-- Activates a given unit, updating the position and name and colour of the tracking window
-----------------------------------------------------------------------------------------------
function RareTracker:ActivateUnit(tData, unitRare)
    local wndReference = tData.wnd

    tData.unit = unitRare
    tData.position = unitRare:GetPosition()
    tData.inactive = false

    tData.wnd:FindChild("Distance"):SetTextColor(activeTextColor)

    wndReference:SetData(tData)
end

-----------------------------------------------------------------------------------------------
-- DeactivateUnit
--
-- Deactivates a given unit, updating the position and name and colour of the tracking window
-----------------------------------------------------------------------------------------------
function RareTracker:DeactivateUnit(tData)
    local wndReference = tData.wnd

    tData.unit = nil
    tData.inactive = true

    -- if the selected unit is destroyed then deselect its list item if it's selected
    if tData.wnd == self.wndSelectedRare then
        self.wndSelectedRare = nil
        tData.wnd:FindChild("Name"):SetTextColor(normalTextColor)
    end

    tData.wnd:FindChild("Distance"):SetTextColor(inactiveTextColor)

    wndReference:SetData(tData)
end

-----------------------------------------------------------------------------------------------
-- OnTrackedRareClick
--
-- Callback for when the user clicks on one of the entry windows in the list.
-----------------------------------------------------------------------------------------------
function RareTracker:OnTrackedRareClick(windowHandler, windowControl, mouseButton)
    if windowHandler ~= windowControl then
        return
    end

    if mouseButton == GameLib.CodeEnumInputMouse.Left then
        if self.trackMaster ~= nil and self.bTrackMasterEnabled then
            -- change the old item's text color back to normal color
            local itemText
            if self.wndSelectedRare ~= nil then
                itemText = self.wndSelectedRare:FindChild("Name")
                itemText:SetTextColor(normalTextColor)
            end

            -- set new selected item's text color
            self.wndSelectedRare = windowControl
            itemText = self.wndSelectedRare:FindChild("Name")
            itemText:SetTextColor(selectedTextColor)
        end

        local unit = windowControl:GetData().unit
        local trackObj

        -- either track the unit or its original position
        if unit ~= nil then
            trackObj = unit

            if self.showIndicator then
                unit:ShowHintArrow()
            end
        else
            local pos = windowControl:GetData().position
            trackObj = Vector3.New(pos.x, pos.y, pos.z)
        end

        if self.trackMaster ~= nil and self.bTrackMasterEnabled then
            self.trackMaster:SetTarget(trackObj, -1, self.trackMasterLine)
        end
    elseif mouseButton == GameLib.CodeEnumInputMouse.Right then
        self:RemoveTrackedRare(windowControl)
    end
end

-----------------------------------------------------------------------------------------------
-- GetDistance
--
-- credit to Caedo for this function, taken from his TrackMaster addon
-- Gets the distance to the unit based on a vector calculation between our coordinates and
-- mob coordinates
-----------------------------------------------------------------------------------------------
function RareTracker:GetDistance(vectorTarget)
    if GameLib.GetPlayerUnit() ~= nil then
        local posPlayer = GameLib.GetPlayerUnit():GetPosition()
        local vectorPlayer = Vector3.New(posPlayer.x, posPlayer.y, posPlayer.z)
        if Vector3.Is(vectorTarget) then
            return (vectorPlayer - vectorTarget):Length()
        elseif Unit.is(vectorTarget) then
            local posTarget = vectorTarget:GetPosition()

            if posTarget == nil then
                return 0
            end

            local targetVec = Vector3.New(posTarget.x, posTarget.y, posTarget.z)

            return (vectorPlayer - targetVec):Length()
        else
            local targetVec = Vector3.New(vectorTarget.x, vectorTarget.y, vectorTarget.z)
            return (vectorPlayer - targetVec):Length()
        end
    else
        return 0
    end
end

-----------------------------------------------------------------------------------------------
-- OnConfigure
--
-- Callback from the client when the player clicks the config button from the main menu
-----------------------------------------------------------------------------------------------
function RareTracker:OnConfigure()
    if self.wndConfig ~= nil then
        self.wndConfig:Destroy()
        self.wndConfig = nil
    end

    self.wndConfig = Apollo.LoadForm("RareTracker.xml", "ConfigForm", nil, self)

    self:LoadPosition()

    self.configRaresList = self.wndConfig:FindChild("RareListContainer:RareList")

    self:AddAllUnits()

    self.wndConfig:FindChild("EnableTrackingContainer:RadioButton"):SetCheck(self.enableTracking)
    self.wndConfig:FindChild("BroadcastContainer:RadioButton"):SetCheck(self.broadcastToParty)
    self.wndConfig:FindChild("PlaySoundContainer:RadioButton"):SetCheck(self.playSound)
    self.wndConfig:FindChild("ShowHintArrowContainer:RadioButton"):SetCheck(self.showIndicator)
    self.wndConfig:FindChild("CloseEmptyTrackerContainer:RadioButton"):SetCheck(self.closeEmptyTracker)
    self.wndConfig:FindChild("MinLevelContainer:DaysContainer:minLevelInput"):SetText(self.minLevel or 1)
    self.wndConfig:FindChild("MaxTrackingDistanceContainer:DistanceContainer:maxDistanceInput"):SetText(self.maxTrackingDistance or 1000)
end

-----------------------------------------------------------------------------------------------
-- AddAllUnits
--
-- Adds all units based on the achievement list.
-- Marks killed units appropriately.
-----------------------------------------------------------------------------------------------
function RareTracker:AddAllUnits()
    self:InitRares()

    for _,item in pairs(self.arRareNames) do
        self:AddConfigRareItem(item, false)
    end

    for _,item in pairs(self.arCustomNames or {}) do
        self:AddConfigRareItem(item, true)
    end
end

-----------------------------------------------------------------------------------------------
-- Initializes the array of rareMobs that needs to be tracked through the Achievements.
-- Instead of coding all the names in the code, we're going to loop over the Achievements
-- and collect all the names of the mobs that need to be killed.
-----------------------------------------------------------------------------------------------
function RareTracker:InitRares()
    self.arRareNames = {}
    self.achievementEntries = {}

    local arrAchievements = AchievementsLib.GetAchievements()

    for _, achievement in pairs(arrAchievements) do
        if karrAchievements[self.strLocale][achievement:GetName()] then
            for _,entry in pairs(achievement:GetChecklistItems()) do
                table.insert(self.arRareNames, entry.strChecklistEntry)
                self.achievementEntries[entry.strChecklistEntry] = entry.bIsComplete
            end
        end
    end
end
-----------------------------------------------------------------------------------------------
-- AddConfigRare
--
-- Adds a new entry in the config window for tracking custom rares
-----------------------------------------------------------------------------------------------
function RareTracker:AddConfigRareItem(tData, bCustom)
    local wnd = Apollo.LoadForm("RareTracker.xml", "ConfigListItem", self.configRaresList, self)
    wnd:FindChild("Name"):SetText(tData)

    if bCustom then
        wnd:FindChild("Name"):SetTextColor(customUnitColor)
    else
        if self.achievementEntries[tData] then
            wnd:FindChild("AchievementIcon"):Show(true)
        end
    end

    wnd:SetData({isCustom = bCustom})

    self.configRaresList:ArrangeChildrenVert()
end

-----------------------------------------------------------------------------------------------
-- DeleteConfigRareItem
--
-- Removes a rare entry from the custom config options
-----------------------------------------------------------------------------------------------
function RareTracker:DeleteConfigRareItem(item, isCustom, listItemWindow)
    local name = listItemWindow:FindChild("Name"):GetText()
    local unitList

    if isCustom then
        unitList = self.arCustomNames
    else
        unitList = self.arRareNames
    end

    for idx,item in pairs(unitList) do
        if item == name then
            table.remove(unitList, idx)
            listItemWindow:Destroy()
            self.configRaresList:ArrangeChildrenVert()
            break
        end
    end
end

-----------------------------------------------------------------------------------------------
-- OnAddUnit
--
-- Callback when addin a unit.
-- Used for updating the input window
-----------------------------------------------------------------------------------------------
function RareTracker:OnAddUnit()
    local inputWindow = self.wndConfig:FindChild("RareListContainer:InputContainer:UnitInput")
    local unitName = inputWindow:GetText()
    if unitName ~= "Enter unit name..." then
        self:AddConfigRareItem(unitName, true)
        table.insert(self.arCustomNames, trim(unitName))
        inputWindow:SetText("Enter unit name...")
        self.configRaresList:SetVScrollPos(self.configRaresList:GetVScrollRange())
    end
end

-----------------------------------------------------------------------------------------------
-- OnDeleteUnit
--
-- Callback when deleting a unit.
-- Used for updating the input window.
-----------------------------------------------------------------------------------------------
function RareTracker:OnDeleteUnit(windowHandler, windowControl)
    local listItemWindow = windowHandler:GetParent()
    local isCustom = listItemWindow:GetData().isCustom

    self:DeleteConfigRareItem(item, isCustom, listItemWindow)
end

-----------------------------------------------------------------------------------------------
-- Button functions
-----------------------------------------------------------------------------------------------
function RareTracker:OnResetButton()
    self.configRaresList:DestroyChildren()
    self:AddAllUnits()
    self.configRaresList:SetVScrollPos(0)
end

function RareTracker:OnEnableTrackingCheck(windowHandler, windowControl)
    self.enableTracking = true
    Apollo.RegisterEventHandler("UnitCreated", "OnUnitCreated", self)
end

function RareTracker:OnEnableTrackingUncheck(windowHandler, windowControl)
    self.enableTracking = false
    Apollo.RemoveEventHandler("UnitCreated", self)
end

function RareTracker:OnBroadcastCheck(windowHandler, windowControl)
    self.broadcastToParty = true
end

function RareTracker:OnBroadcastUncheck(windowHandler, windowControl)
    self.broadcastToParty = false
end

function RareTracker:OnTrackKilledCheck(windowHandler, windowControl)
    self.bTrackKilledRares = true
end

function RareTracker:OnTrackKilledUncheck(windowHandler, windowControl)
    self.bTrackKilledRares = false
end

function RareTracker:OnPlaySoundCheck(windowHandler, windowControl)
    self.playSound = true
end

function RareTracker:OnPlaySoundUncheck(windowHandler, windowControl)
    self.playSound = false
end

function RareTracker:OnShowIndicatorCheck(windowHandler, windowControl)
    self.showIndicator = true
end

function RareTracker:OnShowIndicatorUncheck(windowHandler, windowControl)
    self.showIndicator = false
end

function RareTracker:OnAutoCloseEmptyTrackerCheck(windowHandler, windowControl)
    self.closeEmptyTracker = true
end

function RareTracker:OnAutoCloseEmptyTrackerUncheck(windowHandler, windowControl)
    self.closeEmptyTracker = false
end

function RareTracker:OnMinLevelChange(windowHandler, windowControl, strText)
    local minLevel = tonumber(strText)
    if minLevel ~= nil then
        self.minLevel = math.floor(minLevel)
    else
        self.minLevel = 1
    end
end

function RareTracker:OnMaxDistanceChange(windowHandler, windowControl, strText)
    local maxDistance = tonumber(strText)
    if maxDistance ~= nil then
        self.maxTrackingDistance = math.floor(maxDistance)
    else
        self.maxTrackingDistance = 1000
    end
end

function RareTracker:OnOptionsClose()
    self:StorePosition()
    self.wndConfig:Close()
end

-----------------------------------------------------------------------------------------------
-- RareTracker Instance
-----------------------------------------------------------------------------------------------
local RareTrackerInst = RareTracker:new()
RareTrackerInst:Init()
