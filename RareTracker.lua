-----------------------------------------------------------------------------------------------
-- Client Lua Script for RareTracker
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
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

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function RareTracker:new(o)
	o = o or {}
  	setmetatable(o, self)
  	self.__index = self

  	o.majorVersion = 1
  	o.minorVersion = 1
  	o.newRares = false
  	o.rareMobs = {}
  	local strCancelLocale = Apollo.GetString(1);
  	
    if strCancelLocale == "Cancel" then
    	o.defaultRareNames = {"Nomjin","Frostshard","Prodigy","Beastmaster Xix","Iiksy","Shadowfall","Leatherface","Stonepile","Stanch","Galegut","Gnawer",
		"Deadbough","Barebones","Wormwood the Wraithmaker","Wormwood Acolyte","Ashwin the Stormcrested","Claymore XT-9","AG5 Blitzbuster","Nym Maiden of Mercy",
		"Asteria","Acacia","Atethys","Mikolai the Malevolent","The Shadow Queen","XL-51 Goliath","Queen Bizzelt","Captain Fripeti","Groundswell Guardsman",
		"RG3 Blitzbuster","Brigadier Bellza","Black Besieger","Exterminator Cryvex","Veshra the Eye of the Storm","Slopper","Gravek the Swale-Striker","Veldrok the Vindicator",
		"Moreg the Mauler","Zersa the Betrothed","Kalifa","Cromlech the Kilnborn","Suul of the Silva","Meldrid the Decrepit","Blisterbane","Squall","Flamesurge","Rumble",
		"Doctor Rotthrall","Kryne the Tidebreaker","Quin Quickdraw","Andara the Seer","Crog the Smasher","ER-7 Explorer","AX-12 Defender","Torgal the Devastator","Scabclaw",
		"Gorax the Putrid","Old Scrappy","Dreadbone","Guardian Xeltos","Guardian Zelkix","Augmented Ragemaster","Flintrock","Gorignak","Granitefist","Dreich","Beelzebug","Whitefang",
		"Detritus","Lifegrazer","The Pink Pumera","The Queen","Blinky","Drifter","The Lobotomizer","Abyss","Deadpaws","Alpha Guard One","Alpha Guard Two","Strainblade","Vorgrim",
		"The Vultch","Deathgrazer","Purple Peep Eater","The Ravagist","Amorphomorph","King Grimrock","Scrabbles","Sgt. Garog","Excargo","Gorganoth Prime","The Floater","Weapon 24",
		"Ghostfin","Torrent","Whirlwind","Dreadmorel","Regulator 11","Auxiliary Probe","Sarod the Senseless","Aeacus","Silverhorn","Voresk Venomgill","The Terror of Bloodstone",
		"Zakan the Necroshaman","Wrath of Niwha","Felidax","Terminus Rex","Gavwyn the Verdant Defender","Steel Jaw","Arianna Wildgrass","Arianna's Sentry","Arianna's Assassin",
		"Subject: Rho","The Endless Hunger","Flamekin","Nakaz the Deadlord","Hotshot Braz","Bloodtail","Blightbeak","Deathpaw","Grudder","Quiggles","King Cruelclaw","Queen Kizzek",
		"Grovekeeper Fellia","Razorclaw","Chief Blackheart","Rondo","Rondo's Squad","XT-9 Alpha","Crystalback","Rashanna the Soul Drinker","The Embermaster","Rotfang","Spellmaster Verwyn",
		"Subject V - Tempest","Subject J - Fiend","Subject K - Brute","KE-27 Sentinel","KE-28 Energizer","Subject Tau","Grinder","Bugwit","Icefang","Frostbite","Grellus the Blight Queen",
		"Torvex the Crystal Titan","K9 Destroyer","Stormshell","FR2 Blitzer","Permafrost","Drud the Demented","Frosty the Snowtail","Skorga the Frigid","Warlord Nagvox","Shellshock",
		"Blubbergut","Frozenclaw","Stonegut","Savageclaw","Grug the Executioner","Blightfang","Basher Grogek","Flame-Binder Sorvel","Flame-Binder Trovin","Queen Tizzet","Dominator",
		"Infinimaw","Bloodmane","\"Hotshot\" Braz","The Bumbler","Aeroth the Sentinel","Wretch the Impure","Gnarly Hookfoot","Radical Hookfoot","Dramatic Skug Queen","Soultaker",
		"Bogus Fraz","Gnashing Cankertube Garr","The Stump","Fool's Gold","NG Protector One","Marmota","Ruga the Ageless","Lightback","Grace","Pusbelly","Randok","Tessa","Flood",
		"Flametongue","Slab","Final Flight","The Enlightened","Growth","Proliferator","Tainted Drone","Tainted Direweb","Deathbite","The Outsider"}
	elseif strCancelLocale == "Annuler" then
    	o.defaultRareNames = {}
    elseif strCancelLocale == "Abbrechen" then
    	o.defaultRareNames = {}
    else
		o.defaultRareNames = {}
	end

  	table.sort(o.defaultRareNames)
	o.selectedRareWindow = nil
  	return o
end

function RareTracker:Init()
	local bHasConfigureFunction = true
	local strConfigureButtonText = "RareTracker"
	local tDependencies = {
	}
    
  Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end
 

function RareTracker:OnLoad()
	self.xmlDoc = XmlDoc.CreateFromFile("RareTracker.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

function RareTracker:OnDocLoaded()
	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
    self.mainWindow = Apollo.LoadForm(self.xmlDoc, "RareTrackerForm", nil, self)
    
	  if self.mainWindow == nil then
		  Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
		  return
	  end

  	self.trackedRaresWindow = self.mainWindow:FindChild("TrackedRaresList")
    self.mainWindow:Show(false, true)

  	Apollo.RegisterSlashCommand("raretracker", "OnRareTrackerOn", self)
    Apollo.RegisterSlashCommand("rt", "OnRareTrackerOn", self)
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
	end
end

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

  if self.customNames == nil then
    self.customNames = {}
  end

  if (self.savedMajorVersion == nil or self.savedMinorVersion == nil or self.savedMajorVersion < self.majorVersion) and self.newRares and self.rareNames ~= nil then
    self:ShowResetRareListPrompt()
  elseif self.savedMinorVersion ~= nil and self.savedMinorVersion < self.minorVersion and self.newRares and self.rareNames ~= nil then
    self:ShowResetRareListPrompt()
  end

  if self.rareNames == nil then
    self.rareNames = self.defaultRareNames
  end
end

function RareTracker:ShowResetRareListPrompt()
  self.resetWindow = Apollo.LoadForm(self.xmlDoc, "ResetConfirmationForm", nil, self)
end

function RareTracker:OnResetRaresButton()
  self.rareNames = table.shallow_copy(self.defaultRareNames)
  if self.configWindow ~= nil then
    self.configWindow:Close()
  end
  self.resetWindow:Close()
end

function RareTracker:OnResetWindowClose()
  self.resetWindow:Close()
end

function RareTracker:InitTrackMaster()
  self.trackMaster = Apollo.GetAddon("TrackMaster")

  if self.trackMaster ~= nil then
    if self.trackMasterLine == nil then
      self.trackMasterLine = 1
    end

    if self.trackMasterEnabled == nil then
      self.trackMasterEnabled = true
    end

    self.trackMaster:AddToConfigMenu(self.trackMaster.Type.Track, "   RareTracker", {
      CanFire = false,
      CanEnable = true,
      IsChecked = self.trackMasterEnabled,
      OnEnableChanged = function(isEnabled)
        self.trackMasterEnabled = isEnabled
      end,
      LineNo = self.trackMasterLine,
      OnLineChanged = function(lineNo)
        self.trackMaster:SetTarget(nil, -1, self.trackMasterLine)
        if self.selectedRareWindow ~= nil then
          self.selectedRareWindow:FindChild("Name"):SetTextColor(normalTextColor)    
          self.selectedRareWindow = nil
        end
        self.trackMasterLine = lineNo
      end
    })    
  end
end

-----------------------------------------------------------------------------------------------
-- Carbine Event Callbacks
-----------------------------------------------------------------------------------------------
function RareTracker:OnSave(saveLevel)
  if saveLevel ~= GameLib.CodeEnumAddonSaveLevel.Character then
    return nil
  end

  local savedData = {}

  if (type(self.minLevel) == 'number') then
    savedData.minLevel = math.floor(self.minLevel)
  end

  if (type(self.maxTrackingDistance) == 'number') then
    savedData.maxTrackingDistance = math.floor(self.maxTrackingDistance)
  end

  savedData.enableTracking = self.enableTracking
  savedData.broadcastToParty = self.broadcastToParty
  savedData.playSound = self.playSound
  savedData.showIndicator = self.showIndicator
  savedData.closeEmptyTracker = self.closeEmptyTracker
  savedData.rareNames = self.rareNames
  savedData.customNames = self.customNames
  savedData.trackMasterLine = self.trackMasterLine
  savedData.trackMasterEnabled = self.trackMasterEnabled
  savedData.savedMinorVersion = self.minorVersion
  savedData.savedMajorVersion = self.majorVersion

  return savedData
end

function RareTracker:OnRestore(saveLevel, savedData)
  if (savedData.minLevel ~= nil) then
    self.minLevel = savedData.minLevel
  end

  if (savedData.maxTrackingDistance ~= nil) then
    self.maxTrackingDistance = savedData.maxTrackingDistance
  end  

  if (savedData.playSound ~= nil) then
    self.playSound = savedData.playSound
  end

  if (savedData.showIndicator ~= nil) then
    self.showIndicator = savedData.showIndicator
  end

  if (savedData.enableTracking ~= nil) then
    self.enableTracking = savedData.enableTracking
  end

  if (savedData.broadcastToParty ~= nil) then
    self.broadcastToParty = savedData.broadcastToParty
  end

  if (savedData.closeEmptyTracker ~= nil) then
    self.closeEmptyTracker = savedData.closeEmptyTracker
  end

  if (savedData.rareNames ~= nil) then
    self.rareNames = savedData.rareNames
  end  

  if (savedData.customNames ~= nil) then
    self.customNames = savedData.customNames
  end

  if (savedData.trackMasterLine ~= nil) then
    self.trackMasterLine = savedData.trackMasterLine
  end

  if (savedData.trackMasterEnabled ~= nil) then
    self.trackMasterEnabled = savedData.trackMasterEnabled
  end

  if (savedData.savedMajorVersion ~= nil) then
    self.savedMajorVersion = savedData.savedMajorVersion
  end

  if (savedData.savedMinorVersion ~= nil) then
    self.savedMinorVersion = savedData.savedMinorVersion
  end    
end

function RareTracker:OnWindowManagementReady()
  Event_FireGenericEvent("WindowManagementAdd", {wnd = self.mainWindow, strName = "RareTracker"})
end

-----------------------------------------------------------------------------------------------
-- RareTracker Functions
-----------------------------------------------------------------------------------------------
function RareTracker:OnRareTrackerOn()
	self.mainWindow:Invoke()
end

function RareTracker:OnClose()
  self.mainWindow:Close()
end

function RareTracker:OnTimer()
  local trackObj, distance

  for idx,item in pairs(self.rareMobs) do
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

function RareTracker:OnAutoCloseTimer()
  if #self.trackedRaresWindow:GetChildren() == 0 and self.closeEmptyTracker then
    self.mainWindow:Close()
  end
end

function RareTracker:OnUnitCreated(unit)
  local disposition = unit:GetDispositionTo(GameLib.GetPlayerUnit())
  local unitName = trim(unit:GetName())

  if unit:IsValid() and not unit:IsDead() and not unit:IsACharacter() and 
     (unit:GetLevel() ~= nil and unit:GetLevel() >= self.minLevel) and
     (disposition == Unit.CodeEnumDisposition.Hostile or disposition == Unit.CodeEnumDisposition.Neutral) and
     (table.find(unitName, self.rareNames) or table.find(unitName, self.customNames)) then
    local item = self.rareMobs[unit:GetName()]
    if not item then
      self:AddTrackedRare(unit)

      if self.playSound then
        Sound.Play(Sound.PlayUIExplorerScavengerHuntAdvanced)  
      end

      if self.broadcastToParty and GroupLib.InGroup() then
        -- no quick way to party chat, need to find the channel first
        for _,channel in pairs(ChatSystemLib.GetChannels()) do
          if channel:GetType() == ChatSystemLib.ChatChannel_Party then
            channel:Send("Rare detected: " .. unit:GetName())
          end
        end
      end
      
      self.mainWindow:Invoke()
    elseif item.inactive then
      -- The mob was destroyed but has been found again
      self:ActivateUnit(item, unit)
    end
  end
end

function RareTracker:OnUnitDestroyed(unit)
  local unit = self.rareMobs[unit:GetName()]
  if unit ~= nil then
    self:DeactivateUnit(unit)
  end
end

function RareTracker:AddTrackedRare(unit)
  local wnd = Apollo.LoadForm(self.xmlDoc, "TrackedRare", self.trackedRaresWindow, self)

  local name = unit:GetName()

  self.rareMobs[name] = {
    wnd = wnd,
    position = unit:GetPosition(),
    name = name
  }

  local itemText = wnd:FindChild("Name")
  local wndItemDistanceText = wnd:FindChild("Distance")

  if itemText then
    itemText:SetText(name) 
  end

  self.trackedRaresWindow:ArrangeChildrenVert()
  self:ActivateUnit(self.rareMobs[name], unit)
end

function RareTracker:RemoveTrackedRare(windowControl)
  if windowControl == self.selectedRareWindow then
    self.selectedRareWindow = nil
  end

  self.rareMobs[windowControl:GetData().name] = nil

  windowControl:Destroy()

  if self.trackMaster ~= nil then
    self.trackMaster:SetTarget(nil, -1, self.trackMasterLine)
  end
    
  -- SendVarToRover("trackedrares", self.trackedRaresWindow)
  if #self.trackedRaresWindow:GetChildren() == 0 then
    self.autoCloseTimer:Start()
  end
  self.trackedRaresWindow:ArrangeChildrenVert()
end

function RareTracker:ActivateUnit(item, unit)
  local wnd = item.wnd

  item.unit = unit
  item.position = unit:GetPosition()
  item.inactive = false

  item.wnd:FindChild("Distance"):SetTextColor(activeTextColor)

  wnd:SetData(item)
end

function RareTracker:DeactivateUnit(item)
  local wnd = item.wnd

  item.unit = nil
  item.inactive = true

  -- if the selected unit is destroyed then deselect its list item if it's selected
  if item.wnd == self.selectedRareWindow then
    self.selectedRareWindow = nil
    item.wnd:FindChild("Name"):SetTextColor(normalTextColor)    
  end

  item.wnd:FindChild("Distance"):SetTextColor(inactiveTextColor)

  wnd:SetData(item)
end

function RareTracker:OnTrackedRareClick(windowHandler, windowControl, mouseButton)
  if windowHandler ~= windowControl then
    return
  end

  if mouseButton == GameLib.CodeEnumInputMouse.Left then
    if self.trackMaster ~= nil and self.trackMasterEnabled then
      -- change the old item's text color back to normal color
      local itemText
      if self.selectedRareWindow ~= nil then
        itemText = self.selectedRareWindow:FindChild("Name")
        itemText:SetTextColor(normalTextColor)
      end

      -- set new selected item's text color
      self.selectedRareWindow = windowControl
      itemText = self.selectedRareWindow:FindChild("Name")
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

    if self.trackMaster ~= nil and self.trackMasterEnabled then
      self.trackMaster:SetTarget(trackObj, -1, self.trackMasterLine)
    end
  elseif mouseButton == GameLib.CodeEnumInputMouse.Right then
    self:RemoveTrackedRare(windowControl)
  end
end

-- credit to Caedo for this function, taken from his TrackMaster addon
function RareTracker:GetDistance(target)
  if GameLib.GetPlayerUnit() ~= nil then
    local playerPos = GameLib.GetPlayerUnit():GetPosition()
    local playerVec = Vector3.New(playerPos.x, playerPos.y, playerPos.z)
    if Vector3.Is(target) then
      return (playerVec - target):Length()
    elseif Unit.is(target) then
      local targetPos = target:GetPosition()
      if targetPos == nil then
        return 0
      end
      local targetVec = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
      return (playerVec - targetVec):Length()
    else
      local targetVec = Vector3.New(target.x, target.y, target.z)
      return (playerVec - targetVec):Length()
    end
  else
    return 0
  end
end

-----------------------------------------------------------------------------------------------
-- Config Menu Functions
-----------------------------------------------------------------------------------------------
function RareTracker:OnConfigure()
  if self.configWindow ~= nil then
    self.configWindow:Destroy()
    self.configWindow = nil
  end

  self.configWindow = Apollo.LoadForm(self.xmlDoc, "ConfigForm", nil, self)
  self.configRaresList = self.configWindow:FindChild("RareListContainer:RareList")

  self:AddAllUnits()

  self.configWindow:FindChild("EnableTrackingContainer:RadioButton"):SetCheck(self.enableTracking)
  self.configWindow:FindChild("BroadcastContainer:RadioButton"):SetCheck(self.broadcastToParty)
  self.configWindow:FindChild("PlaySoundContainer:RadioButton"):SetCheck(self.playSound)
  self.configWindow:FindChild("ShowHintArrowContainer:RadioButton"):SetCheck(self.showIndicator)
  self.configWindow:FindChild("CloseEmptyTrackerContainer:RadioButton"):SetCheck(self.closeEmptyTracker)
  self.configWindow:FindChild("MinLevelContainer:DaysContainer:minLevelInput"):SetText(self.minLevel)
  self.configWindow:FindChild("MaxTrackingDistanceContainer:DistanceContainer:maxDistanceInput"):SetText(self.maxTrackingDistance)
end

function RareTracker:AddAllUnits()
  self:BuildAchievementList()

  for _,item in pairs(self.rareNames) do
    self:AddConfigRareItem(item, false)
  end

  for _,item in pairs(self.customNames) do
    self:AddConfigRareItem(item, true)
  end
end

function RareTracker:BuildAchievementList()
  local achievements = AchievementsLib.GetAchievements()

  self.achievementEntries = {}

  for _,achievement in pairs(achievements) do
    if string.find(achievement:GetName(), "I Like") then
      for _,item in pairs(achievement:GetChecklistItems()) do
        self.achievementEntries[item.strChecklistEntry] = item.bIsComplete
      end
    end
  end
end

function RareTracker:AddConfigRareItem(item, isCustom)
  local wnd = Apollo.LoadForm(self.xmlDoc, "ConfigListItem", self.configRaresList, self)
  wnd:FindChild("Name"):SetText(item)

  if isCustom then
    wnd:FindChild("Name"):SetTextColor(customUnitColor)
  else
    if self.achievementEntries[item] then
      wnd:FindChild("AchievementIcon"):Show(true)
    end
  end

  wnd:SetData({isCustom = isCustom})

  self.configRaresList:ArrangeChildrenVert()
end

function RareTracker:DeleteConfigRareItem(item, isCustom, listItemWindow)
  local name = listItemWindow:FindChild("Name"):GetText()
  local unitList

  if isCustom then
    unitList = self.customNames
  else
    unitList = self.rareNames
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

function RareTracker:OnAddUnit()
  local inputWindow = self.configWindow:FindChild("RareListContainer:InputContainer:UnitInput")
  local unitName = inputWindow:GetText()
  if unitName ~= "Enter unit name..." then
    self:AddConfigRareItem(unitName, true)
    table.insert(self.customNames, trim(unitName))
    inputWindow:SetText("Enter unit name...")
    self.configRaresList:SetVScrollPos(self.configRaresList:GetVScrollRange())
  end
end

function RareTracker:OnDeleteUnit(windowHandler, windowControl)
  local listItemWindow = windowHandler:GetParent()
  local isCustom = listItemWindow:GetData().isCustom

  self:DeleteConfigRareItem(item, isCustom, listItemWindow)
end

function RareTracker:OnResetButton()
  self.rareNames = table.shallow_copy(self.defaultRareNames)
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
  self.configWindow:Close()
end

-----------------------------------------------------------------------------------------------
-- RareTracker Instance
-----------------------------------------------------------------------------------------------
local RareTrackerInst = RareTracker:new()
RareTrackerInst:Init()
