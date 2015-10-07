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
	self.nMinorVersion = 0
	self.bNewRares = false
	self.arRareMobs = {}
	
	local strCancelLocale = Apollo.GetString("CRB_Cancel");
  	
  if strCancelLocale == "Cancel" then
	 self.arDefaultRareNames = {"Nomjin","Frostshard","Prodigy","Beastmaster Xix","Iiksy","Shadowfall","Leatherface","Stonepile","Stanch","Galegut","Gnawer",
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
		"Flametongue","Slab","Final Flight","The Enlightened","Growth","Proliferator","Tainted Drone","Tainted Direweb","Deathbite","The Outsider","SCS Adjutant","Tharge the Waterseeker","Lazy Lenny"}
	elseif strCancelLocale == "Annuler" then
	 self.arDefaultRareNames = {"Nomjin","Éclat de givre","Prodige","Dompteur Xix","Iiksy","Ombrechute","Leatherface","Tas de pierres","Endigueur","Souffletripe","Rongeur",
		"Mortebranche","Ossanu","Verbois le Courrouceur","Acolytes verbois","Ashwin le Crêtetempête","Claymore XT-9","AG5 Blitzbuster","Nym, vierge de la pitié",
		"Asteria","Acacia","Atethys","Mikolai le malfaisant","La reine des ombres","Goliath XL-51","Reine Bizzbizze","Captaine Fripeti","Garde du Tellurixe",
		"Bombardeur RG3","Brigadier Bellza","Assiégeant noir","Exterminateur Cryvex","Veshra l'œil du cyclone","Renverseur","Gravek le Frappefosse","Veldrok le Vengeur",
		"Moreg le Déchiqueteur","Zersa la Promise","Kalifa","Cromlech l'Enfourné","Âme sylvaine","Meldrid la Décatie","Cloquepoil","Squall","Retour de flamme","Rumble",
		"Docteur Vilserf","Kryne le Brisemarée","Quin fine gâchette","Andara le Devin","Crog le Fracasseur","Explorateur ER-7","Défenseur AX-12","Torgal le Dévasteur","Corrugriffe",
		"Gorax le Putride","Vieux tas de ferraille","Épouvantos","Gardien Xeltos","Gardien Zelkix","Maîtrerage augmenté","Silex","Gorignak","Poing de granit","Dreich","Bourdard","Croblanc",
		"Détritus","Viverelle","The Pink Pumera","La reine","Cligneur","Flotteur","Le Lobotomiseur","Abîme","Donnemorts","Garde Alpha 1","Garde Alpha 2","Souille-lame","Vorgrim",
		"Le Vautour","Morterelle","Purple Peep Eater","Le Ravageur","Amorphomorphe","Roi Sinistreroche","Scrabbles","Sergent Garog","Excargo","Primo Gorganoth","Le Flotteur","Arme 24",
		"Spectraileron","Torrent","Tourbillon","Effroimorille","Régulateur 11","Sonde auxiliaire","Sarod l'Insensé","Aeacus","Cornargent","Voresk Branchivenin","La Terreur de Rochesang",
		"Zakan le Nécrochaman","Courroux du Niwha","Felidax","Terminus Rex","Gavwyn le Défenseur verdoyant","Mâchoire d'acier","Arianna Herbefolle","Sentinelle d'Arianna","Assassin d'Arianna",
		"Sujets : Rho","La faim sans fin","Soucheflamme","Nakaz le Seigneur mort","Hotshot Braz","Sanguifouet","Rouillebec","Griffemort","Grapace","Grouillis","Roi Lacérace","Reine Kizzek",
		"Garde-bosquet Fellia","Acèregriffe","Chef de Noircœur","Rondo","Équipe de Rondo","Alpha XT-9","Marbredos","Rashanna la Buveuse d'âmes","Le Maître des braises","Putrecroc","Maître des sorts Verwyn",
		"Sujet V : tempête","Sujet J : démon","Sujet K : brute","Sentinelle KE-27","Source d'énergie KE-28","Sujet Tau","Broyeur","Bugwit","Croc-de-glace","Moglace","Grellus, la reine de la Rouille",
		"Torvex le Titan de cristal","Destructeur K9","Coquetempête","Pilonneur FR2","Permafrost","Drud le Dément","Frosty the Snowtail","Skorga le Glacé","Seigneur de guerre Nagvox","Shellshock",
		"Tripesuif","Griffegel","Tripes de pierre","Brutegriffe","Grug le bourreau","Rouillecroc","Dérouilleur Grogek","Attache-Flamme Sorvel","Attache-Flamme Trovin","Reine Tizzet","Dominateur",
		"Mâchenéant","Sanguicrin","Cador Braz","L'Empoté","Aeroth la Sentinelle","Wretch l'Impur","Croche-pattes ratatiné","Croche-pattes radical","Reine skug dramatique","Mange-âme",
		"Faux Friz","Garr chancretube grinçant","La Souche","L'or du fou","NG Premier Protecteur","Marmota","Ruga l'Éternel","Allègedos","Gracieux","Suppustule","Randok","Tessa","Inondation",
		"Langueflamme","Bloc de pierre","Vol final","L'Illuminé","Croissance","Proliférateur","Frelon corrompu","Sinistoile impure","Crofuneste","L'Étranger","Instructuer SSC","Tharge le Sourcier","Lenny le Fainéant"}
  elseif strCancelLocale == "Abbrechen" then
	 self.arDefaultRareNames = {"Nomjin","Frostscherbe","Wunderkind","Bestienmeisterin Xix","Iiksy","Schattenfall","Leatherface","Steinhaufen","Stehmann","Orkanbauch","Kauer",
		"Totzweig","Blankknochen","Wurmholz der Geistermacher","Wurmholz-Akolyth","Ashwin der Sturmbedeckte","Claymore XT-9","Blitzjäger AG5","Nym Jungfrau der Gnade",
		"Asteria","Acacia","Atethys","Mikolai der Grausame","Die Schattenkönigin","XL-51 Goliath","Königin Bizzelt","Captain Fripeti","Schwellgrund-Wachmann",
		"RG3-Blitzjäger","Brigadekommandeur Bellza","Schwarzer Belagerer","Exterminator Cryvex","Veshra, das Auge des Sturms","Schwapper","Gravek der Muldenschläger","Veldrok der Verteidiger",
		"Moreg der Malmer","Zersa die Verlobte","Kalifa","Cromlech der Brennofengeborene","Seele der Silva","Meldrid die Altersschwache","Blasenfluch","Squall","Flammenwoge","Rumble",
		"Doktor Faulsklave","Kryne der Wellenbrecher","Quin Flinkhand","Andara die Seherin","Crog der Zertrümmerer","ER-7 Kundschafter","AX-12 Verteidiger","Torgal der Verwüster","Schorfklaue",
		"Gorax der Verweser","Alte Rumpelkiste","Schreckensknochen","Wächter Xeltos","Wächter Zelkix","Augmentierter Zornmeister","Feuerstein","Gorignak","Granitfaust","Dreich","Summuel","Weißzahn",
		"Geröll","Lebensgraser","The Pink Pumera","Die Königin","Blinzli","Gammler","Der Lobotomisierer","Abgrund","Totepfoten","Alphawache Eins","Alphawache Zwei","Transmutationsklinge","Vorgrimm",
		"Der Vultch","Todgraser","Purple Peep Eater","Der Verwüstologe","Amorphomorph","König Grimmfels","Scrabbles","Sgt. Garog","Exfracht","Gorganoth der Erste","Der Schweber","Waffe 24",
		"Geistflosse","Strömung","Wirbelwind","Furchtmorchel","Regulator 11","Hilfssonde","Sarod der Sinnlose","Aeacus","Silberhorn","Voresk Giftkiemen","Der Schrecken von Blutstein",
		"Zakan der Nekroschamane","Zorn von Niwha","Felidax","Terminus Rex","Gavwyn der Grüne Verteidiger","Stahlkiefer","Arianna Wildgras","Ariannas Wachposten","Ariannas Assassinin",
		"Subjekt: Rho","Der unstillbare Hunger","Flammensippe","Nakaz der Totenherr","Hotshot Braz","Blutschwanz","Faulschnabel","Todespfote","Grudder","Kringel","König Gräuelklaue","Königin Kizzek",
		"Hainhüterin Fellia","Scharfkralle","Häuptling Schwarzherz","Rondo","Rondos Trupp","XT-9-Alpha","Kristallrücken","Rashanna die Seelentrinkerin","Der Glutmeister","Faulzahn","Spruchmeister Verwyn",
		"Subjekt V – Sturm","Subjekt J – Scheusal","Subjekt K – Widerling","Wache KE-27","Auflader KE-28","Objekt: Tau","Schleifer","Kleinsinn","Eiszahn","Frostbiss","Grellus die Fäulniskönigin",
		"Torvex der Kristalltitan","K9 Zerstörer","Sturmpanzer","FR2 Blitzer","Permafrost","Drud der Verrückte","Frosty the Snowtail","Skorga der Frostige","Kriegsherr Nagvox","Shellshock",
		"Speckbauch","Frostklaue","Steingedärm","Wildklaue","Grug der Scharfrichter","Faulzahn","Spalter Grogek","Flammenbinder Sorvel","Flammenbinder Trovin","Königin Tizzet","Dominator",
		"Endlosschlund","Blutmähne","\"„Teufelskerl“\" Braz","Der Summser","Aeroth der Wachhabende","Teufel der Unreine","Knorriger Hakenfuß","Radikaler Hakenfuß","Dramatische Skugkönigin","Seelennehmer",
		"Bogus Fraz","Knirschender Wucher-Garr","Der Stumpf","Narrengold","NG-Protektor Eins","Marmota","Ruga der Alterslose","Leichtschulter","Liebreiz","Eiterbauch","Randok","Tessa","Flut",
		"Flammenzunge","Steinplatte","Finalflug","Der Erleuchtete","Wuchs","Vermehrer","Verdorbene Drohne","Finsternetz-Verdorbener","Todesbiss","Der Außenseiter","SKS-Adjutant","Wassersucher Tharge","Fauler Lenny"}
  else
		self.arDefaultRareNames = {}
	end

	table.sort(self.arDefaultRareNames)
  self.wndSelectedRare = nil
	return o
end

function RareTracker:Init()
	local bHasConfigureFunction = true
	local strConfigureButtonText = "RareTracker"
	local tDependencies = {
	}
    
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

  if self.customNames == nil then
    self.customNames = {}
  end

  if (self.savedMajorVersion == nil or self.savedMinorVersion == nil or self.savedMajorVersion < self.nMajorVersion) and self.bNewRares and self.arRareNames ~= nil then
    self:ShowResetRareListPrompt()
  elseif self.savedMinorVersion ~= nil and self.savedMinorVersion < self.nMinorVersion and self.bNewRares and self.arRareNames ~= nil then
    self:ShowResetRareListPrompt()
  end

  if self.arRareNames == nil then
    self.arRareNames = self.arDefaultRareNames
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
  tSavedData.customNames = self.customNames
  tSavedData.trackMasterLine = self.trackMasterLine
  tSavedData.trackMasterEnabled = self.bTrackMasterEnabled
  tSavedData.savedMinorVersion = self.nMinorVersion
  tSavedData.savedMajorVersion = self.nMajorVersion
  tSavedData.tLocations = self.tLocations

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
    self.customNames = tData.customNames
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
-- OnUnitCreated
-- 
-- Callback by the client whenever a new unit is created into the world.
-- We use this to determine if this is a rare mob we need to track and configure the popup
-- window when we have to.
-----------------------------------------------------------------------------------------------
function RareTracker:OnUnitCreated(unitCreated)
  local tDisposition = unitCreated:GetDispositionTo(GameLib.GetPlayerUnit())
  local strUnitName = trim(unitCreated:GetName())

  if unitCreated:IsValid() and not unitCreated:IsDead() and not unitCreated:IsACharacter() and 
     (unitCreated:GetLevel() ~= nil and unitCreated:GetLevel() >= self.minLevel) and
     (table.find(strUnitName, self.arRareNames) or table.find(strUnitName, self.customNames)) then
    
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

  if wndName then
    wndName:SetText(strName) 
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
  self:BuildAchievementList()
  self.arRareNames = shallowcopy(self.arDefaultRareNames)
  
  for _,item in pairs(self.arRareNames) do
    self:AddConfigRareItem(item, false)
  end

  for _,item in pairs(self.customNames or {}) do
    self:AddConfigRareItem(item, true)
  end
end

-----------------------------------------------------------------------------------------------
-- BuildAchievementList
-- 
-- Builds the list of achievements so we can properly mark killed mobs.
-----------------------------------------------------------------------------------------------
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
    unitList = self.customNames
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
    table.insert(self.customNames, trim(unitName))
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
  self.arRareNames = table.shallow_copy(self.arDefaultRareNames)
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
  self:StorePosition()
  self.wndConfig:Close()
end

-----------------------------------------------------------------------------------------------
-- RareTracker Instance
-----------------------------------------------------------------------------------------------
local RareTrackerInst = RareTracker:new()
RareTrackerInst:Init()
