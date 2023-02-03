-- Author      : rvadi
-- Create Date : 17.10.2022 19:11:49

--[[ Loading the addon ]]--

local AddOnName, ns = ...;

local WindowCombatLog = ns.WindowCombatLog;

local OUTPUT = "RAID"
local MIN_TANK_HP = 55000
local MIN_HEALER_MANA = 20000
local DIVINE_PLEA = false; 
local DIVINE_PLEA_ID = 54428 -- клятва привет Enoi
local sacredSacrifice = false;
local sacredSacrificeId = 64205 -- масс сакра
local debuggingMode = false;
local bot	 = "%s использует %s!"
local used	 = "%s использует %s!"
local sw	 = "%s спадает с %s!"
local cast	 = "%s использует %s на %s!"
local taunt	 = "%s использует %s на %s!"
local fade	 = "%s %s спадает с %s!"
local feast  = "%s готовит %s!"
local gs	 = "%s %s потребляет: %d лечение!"
local ad	 = "%s %s потребляются!"
local res	 = "%s %s воскрешен %s!"
local portal = "%s открыт %s!"
local create = "%s создает %s!"
local dispel = "%s %s не удалось рассеять %s's %s!"
local ss	 = "%s умирает от %s!"
local lanaTel	 = "Кровавая королева Лана'тель" 

local sacrifice  = {} -- сюда пойдут id юнитов с диванами и тд
local soulStones = {} -- сюда пойдут id юнитов с камнями души (лок рес)
local ad_heal	 = false

local HEROISM	= UnitFactionGroup("player") == "Horde" and 2825 or 32182	-- Героизм\жажда крови
local REBIRTH 	= GetSpellInfo(20484)										-- Возрождение
local HOP 		= GetSpellInfo(1022)										-- Длань защиты
local SOUL_STONE = GetSpellInfo(20707)										-- Воскрешение камнем души
local CABLES	= GetSpellInfo(54732)										-- Гномий дефибриллятор 


local deadeningPlague = "Мертвящая чума";
local deadeningPlagueIsEnabled = true;
local outputOfInformationDuringDebugging = false;


-- ритуалы
local rituals  = {}
local ritualsDefault  = {
	-- Маг
	[58659] = true, -- Обряд сотворения яств
	-- Лок
	[58887] = true, -- Ритуал душ
	[698]	= true,	-- Ритуал призыва
}

-- спелы применяемые на членов рейда
local spells = {
	-- Паладин
	[6940] 	= true,	-- Длань жертвенности
	[20233] = true, -- Возложение рук
	[20236] = true, -- Возложение рук
	[1044] = true, -- Длань свободы
	[1038] = true, -- Длань спасения
	[10278] = true, -- Длань защиты
	[71169] = true, -- жребий тьмы
	-- Priest
	[47788] = true, -- Оберегающий дух
	[33206] = true, -- Подавление боли
	[6346] = true, -- Защита от страха
	-- Hunter
	[34477] = true, -- Перенаправление
	[19801] = true, -- Усмиряющий выстрел
	[20736] = true, -- Отвлекающий выстрел
	-- рога
	[51722] = true, -- Долой оружие
	[57934] = true, -- Маленькие хитрости

	-- дк
	[49016] = true, -- Истерия
	-- вар
	[676] = true, -- Disarm
	--друид 
	[29166] = true, --Озарение

	[71726] = true, -- укус вампира
	[71729] = true, -- укус вампира
	[71727] = true, -- укус вампира
	[71728] = true, -- укус вампира
    [71475] = true, -- укус вампира
    [71476] = true, -- укус вампира
	[71477] = true, -- укус вампира
	[70946] = true, -- укус вампира
}

-- Taunts
local taunts = {}

local tauntsDefault = {
	[56222] = true, -- темная власть дк
	[49560] = true, -- хватка смерти дк
	[355] = true, -- Провокация вар
	[694] = true, -- Дразнящий удар вар
	[62124] = true, -- 	Длань возмездия пал
	[31790] = true, -- Праведная защита пал
	[49576] = true, -- хватка смерти
}

-- инженерка
local bots = {}
local botsDefault = {
	[22700] = true,
	[44389] = true,
	[67826] = true,
	[54710] = true,
	[54711] = true,
}

-- использование на себя
local use = {
	-- ДК
	[48707] = true,	-- Антимагический панцирь
	[48792] = true,	-- Незыблемость льда
	[55233] = true,	-- Кровь вампира

	-- Друид
	[22812] = true,	-- Дубовая кожа
	[22842] = true,	-- Неистовое восстановление
	[61336] = true,	-- Инстинкты выживания
	-- Паладин
	[498] 	= true, -- Диван
	-- Воин
	[12975] = true,	-- Ни шагу назад
	[12976] = true,	-- ни шагу назад спадение
	[871] 	= true,	-- глухая оборона
	-- Маг
	[45438] = true, -- Ледяная глыба
	-- Trinkets 
	[71638] = true, -- Клык
}

-- бонусы от комплектов
local bonus = {
	-- ДК
	[70654] = false, -- [4P T10]
	-- Друид
	[70725] = true, -- [4P T10]
}

-- Еда
local feasts = {}
local feastsDefault = {
	[57426] = true, -- Рыбный пир
	[57301] = true, -- "Пир на весь мир"
	[66476] = true, -- Богатый пир
}

-- плюшки на весь рейд
local special = {}

local specialDefault = {
	-- Paladin
	[31821] = true, -- Мастер аур
	-- Priest
	[64843] = true, -- Божественный гимн
}

--  порталы магов
local port = {};
local portDefault = {
	[53142] = true, -- Даларан
	[11419] = true, -- Дарнас
	[32266] = true, -- Экзодар
	[11416] = true, -- Стальгорн 
	[11417] = true, -- Огри 
	[33691] = true, -- Шатрат    
	[35717] = true, -- Шатрат  
	[32267] = true, -- Луносвет  
	[49361] = true, -- Каменор     
	[10059] = true, -- Шторм    
	[49360] = true, -- Терамор     
	[11420] = true, -- Громовой утес
	[11418] = true, -- Подгород   
}


local included = true;
local started = false;
local spamWhenInAGroup = false;
-- local IaaaWindow ;

--IaaaWindow:SetScript("OnLoad", функция(событие) print(событие); print(self.name); конец)



function IAAA_OnLoad()

    
    IaaaWindow:RegisterEvent("PLAYER_LOGIN")
    IaaaWindow:RegisterEvent("PLAYER_ENTERING_WORLD");
  --  IaaaWindow:RegisterEvent("UNIT_AURA")
    IaaaWindow:Hide();
    WindowCombatLog:ADDON_LOADED()
-- TODO авто тест надо удалить!!!
    IAAASlashCmd("test")
-- TODO авто тест надо удалить!!! end

    SlashCmdList["IAAA"] = IAAASlashCmd;
    SLASH_IAAA1 = "/ia";
    SLASH_IAAA2 = "/iaaa";
    Print("|cff00FFFFInformation about the abilities|r");
end

-- local plagueHop = GetSpellInfo(70338)
-- local plagueExpires = false
-- local plagueTimer = 0;
-- local lastPlague = nil;


-- function UNIT_AURA(arg)
--     if(arg == nil) then 
--         return;
--     else
--         local name = GetUnitName(arg, true)
--         if (not name) or (name == lastPlague) then return end
--         local _, _, _, _, _, _, expires, _, _, _, spellId = UnitDebuff(arg, plagueHop)
--         if not spellId or not expires then return end
--         if (spellId == 73787 or spellId == 70338 or spellId == 73785 or spellId == 73786) and expires > 0 and not plagueExpires then
--             Iaaa_PlagueCooldown:SetCooldown(GetTime(), 5);
--             plagueExpires = true;
--             name = lastPlague;
--         end
--     end;
-- end



--[[ AUTO INVITE EVENT HANDLER ]]--
function IAAA_On(self, event, ...)
    if(event == "PLAYER_ENTERING_WORLD") then
        IAAA_InitializeSetup();
    end
    if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
        COMBAT_LOG_EVENT_UNFILTERED(...);
    end
end

function IAAA_InitializeSetup()
    if(InformationOnRaid_Config == nil) then  
        InformationOnRaid_Config = {};
    end;
    if(InformationOnRaid_Config["Included"])then 
        Included:SetChecked(1);
    end;
    if(InformationOnRaid_Config["Group"])then Group:SetChecked(1); end;
    if(InformationOnRaid_Config["MagicPortals"])then MagicPortals:SetChecked(1); end;
    if(InformationOnRaid_Config["Rituals"])then Rituals:SetChecked(1); end;
    if(InformationOnRaid_Config["TheHandOfSacrifice"])then TheHandOfSacrifice:SetChecked(1); end;
    if(InformationOnRaid_Config["LayOnHands"])then LayOnHands:SetChecked(1); end;
    if(InformationOnRaid_Config["LayOnHands"])then LayOnHands:SetChecked(1); end;
    if(InformationOnRaid_Config["HandOfFreedom"])then HandOfFreedom:SetChecked(1); end;
    if(InformationOnRaid_Config["HandOfSalvation"])then HandOfSalvation:SetChecked(1); end;
    if(InformationOnRaid_Config["HandOfProtection"])then HandOfProtection:SetChecked(1); end;
    if(InformationOnRaid_Config["FateOfShadow"])then FateOfShadow:SetChecked(1); end;
    if(InformationOnRaid_Config["GuardianSpirit"])then GuardianSpirit:SetChecked(1); end;
    if(InformationOnRaid_Config["PainSuppression"])then PainSuppression:SetChecked(1); end;
    if(InformationOnRaid_Config["FearWard"])then FearWard:SetChecked(1); end;
    if(InformationOnRaid_Config["Redirection"])then Redirection:SetChecked(1); end;
    if(InformationOnRaid_Config["TranquilizingShot"])then TranquilizingShot:SetChecked(1); end;
    if(InformationOnRaid_Config["DistractingShot"])then DistractingShot:SetChecked(1); end;
    if(InformationOnRaid_Config["DismantleRogue"])then DismantleRogue:SetChecked(1); end;
    if(InformationOnRaid_Config["TricksRogue"])then TricksRogue:SetChecked(1); end;
    if(InformationOnRaid_Config["Hysteria"])then Hysteria:SetChecked(1); end;
    if(InformationOnRaid_Config["Disarm"])then Disarm:SetChecked(1); end;
    if(InformationOnRaid_Config["Insight"])then Insight:SetChecked(1); end;
    if(InformationOnRaid_Config["VampireBite"])then VampireBite:SetChecked(1); end;
    if(InformationOnRaid_Config["Engineer"])then Engineer:SetChecked(1); end;
    if(InformationOnRaid_Config["AntiMagicShell"])then AntiMagicShell:SetChecked(1); end;
    if(InformationOnRaid_Config["IceboundFortitude"])then IceboundFortitude:SetChecked(1); end;
    if(InformationOnRaid_Config["VampireBlood"])then VampireBlood:SetChecked(1); end;
    if(InformationOnRaid_Config["BarkSkin"])then BarkSkin:SetChecked(1); end;
    if(InformationOnRaid_Config["FrenziedRegeneration"])then FrenziedRegeneration:SetChecked(1); end;
    if(InformationOnRaid_Config["SurvivalInstincts"])then SurvivalInstincts:SetChecked(1); end;
    if(InformationOnRaid_Config["Sofa"])then Sofa:SetChecked(1); end;
    if(InformationOnRaid_Config["LastStand"])then LastStand:SetChecked(1); end;
    if(InformationOnRaid_Config["LastStandEnd"])then LastStandEnd:SetChecked(1); end;
    if(InformationOnRaid_Config["ShieldWall"])then ShieldWall:SetChecked(1); end;
    if(InformationOnRaid_Config["IceBlock"])then IceBlock:SetChecked(1); end;
    if(InformationOnRaid_Config["FlawlessFangOfSindragosa"])then FlawlessFangOfSindragosa:SetChecked(1); end;
    if(InformationOnRaid_Config["Meal"])then Meal:SetChecked(1); end;
    if(InformationOnRaid_Config["MassBuff"])then MassBuff:SetChecked(1); end;
    if(InformationOnRaid_Config["Taunts"])then Taunts:SetChecked(1); end;
    if(InformationOnRaid_Config["SacredSacrifice"])then SacredSacrifice:SetChecked(1); end;
    if(InformationOnRaid_Config["HolyOath"])then HolyOath:SetChecked(1); end;
    SetVariableValues();
end

function SetVariableValues()

    if(Included:GetChecked()) then 
        InformationOnRaid_Config["included"] = true; 
        started = true; 
    else 
        InformationOnRaid_Config["included"] = false; 
        started = false;
    end

    if(Group:GetChecked()) then 
        InformationOnRaid_Config["Group"] = true; 
        spamWhenInAGroup = true; 
    else 
        InformationOnRaid_Config["Group"] = false; 
        spamWhenInAGroup = false;
    end
    
    if(MagicPortals:GetChecked()) then 
        InformationOnRaid_Config["MagicPortals"] = true; 
        portal = portDefault; 
    else 
        InformationOnRaid_Config["MagicPortals"] = false; 
        portal = {};
    end
    
    if(Rituals:GetChecked()) then 
        InformationOnRaid_Config["Rituals"] = true; 
        rituals = ritualsDefault; 
    else 
        InformationOnRaid_Config["Rituals"] = false; 
        rituals = {};
    end

    -- TheHandOfSacrifice
    spells[6940]  = TheHandOfSacrifice:GetChecked() == 1	-- Длань жертвенности
    -- LayOnHands
	spells[20233] = LayOnHands:GetChecked() == 1 -- Возложение рук
    -- LayOnHands
	spells[20236] = LayOnHands1:GetChecked() == 1 -- Возложение рук
    -- HandOfFreedom
	spells[1044]  = HandOfFreedom:GetChecked() == 1 -- Длань свободы
    -- HandOfSalvation
	spells[1038]  = HandOfSalvation:GetChecked() == 1 -- Длань спасения
    -- HandOfProtection
	spells[10278] = HandOfProtection:GetChecked() == 1 -- Длань защиты
    -- FateOfShadow
	spells[71169] = FateOfShadow:GetChecked() == 1 -- жребий тьмы
	-- Priest
    -- GuardianSpirit
	spells[47788] = GuardianSpirit:GetChecked() == 1 -- Оберегающий дух
    -- PainSuppression
	spells[33206] = PainSuppression:GetChecked() == 1 -- Подавление боли
    -- FearWard
	spells[6346]  = FearWard:GetChecked() == 1 -- Защита от страха
	-- Охотник
    -- Misdirection
	spells[34477] = Redirection:GetChecked() == 1 -- Перенаправление
    -- TranquilizingShot
	spells[19801] = TranquilizingShot:GetChecked() == 1 -- Усмиряющий выстрел
    -- DistractingShot
	spells[20736] = DistractingShot:GetChecked() == 1 -- Отвлекающий выстрел
	-- рога
    -- DismantleRogue
	spells[51722] = DismantleRogue:GetChecked() == 1 -- Долой оружие
    -- TricksRogue
	spells[57934] = TricksRogue:GetChecked() == 1 -- Маленькие хитрости

	-- дк
    -- Hysteria
	spells[49016] = Hysteria:GetChecked() == 1 -- Истерия
	-- вар
    -- Disarm
	spells[676] = Disarm:GetChecked() == 1 -- Disarm
	--друид 
    -- Insight
	spells[29166] = Insight:GetChecked() == 1 --Озарение
    -- VampireBite
	spells[71726] = VampireBite:GetChecked() == 1 -- укус вампира
	spells[71729] = VampireBite:GetChecked() == 1 -- укус вампира
	spells[71727] = VampireBite:GetChecked() == 1 -- укус вампира
	spells[71728] = VampireBite:GetChecked() == 1 -- укус вампира
    spells[71475] = VampireBite:GetChecked() == 1 -- укус вампира
    spells[71476] = VampireBite:GetChecked() == 1 -- укус вампира
	spells[71477] = VampireBite:GetChecked() == 1 -- укус вампира
	spells[70946] = VampireBite:GetChecked() == 1 -- укус вампира

    -- Engineer
    if(Engineer:GetChecked())then 
        bots = botsDefault;  
        InformationOnRaid_Config["Engineer"] = true; 
    else
         bots = {};  
         InformationOnRaid_Config["Engineer"] = false; 
    end;
    -- dk
    -- AntiMagicShell
    use[48707] = AntiMagicShell:GetChecked() == 1;	-- Антимагический панцирь
    -- IceboundFortitude
	use[48792] = IceboundFortitude:GetChecked() == 1;	-- Незыблемость льда
    -- VampireBlood
	use[55233] = VampireBlood:GetChecked() == 1;	-- Кровь вампира

	-- Друид
    -- BarkSkin
	use[22812] = BarkSkin:GetChecked() == 1;	-- Дубовая кожа
    -- FrenziedRegeneration
	use[22842] = FrenziedRegeneration:GetChecked() == 1;	-- Неистовое восстановление
    -- SurvivalInstincts
	use[61336] = SurvivalInstincts:GetChecked() == 1;	-- Инстинкты выживания
	-- Паладин
    -- Sofa
	use[498]= Sofa:GetChecked() == 1; -- Диван
	-- Воин
    -- LastStand
	use[12975] = LastStand:GetChecked() == 1;	-- Ни шагу назад
    -- LastStandEnd
	use[12976] = LastStandEnd:GetChecked() == 1;	-- ни шагу назад спадение
    -- ShieldWall
	use[871] 	= ShieldWall:GetChecked() == 1;	-- глухая оборона
	-- Маг
    -- IceBlock
	use[45438] = IceBlock:GetChecked() == 1; -- Ледяная глыба
	-- Аксессуары 
    -- FlawlessFangOfSindragosa
	use[71638] = FlawlessFangOfSindragosa:GetChecked() == 1; -- Клык
    -- Meal
    if( Meal:GetChecked() ) then
         feasts= feastsDefault;
          InformationOnRaid_Config["Meal"] = true;
    else 
        feast = {};InformationOnRaid_Config["Meal"] = false; 
    end;
    -- MassBuff
    if( MassBuff:GetChecked() ) then 
        special= specialDefault; 
        InformationOnRaid_Config["MassBuff"] = true; 
    else 
        special = {};
        InformationOnRaid_Config["MassBuff"] = false; 
    end;

    -- Таунты в Ланалель

    if( Taunts:GetChecked() ) then 
        taunts= tauntsDefault; 
        InformationOnRaid_Config["Taunts"] = true; 
    else 
        taunts = {};
        InformationOnRaid_Config["Taunts"] = false; 
    end;

    sacredSacrifice = SacredSacrifice:GetChecked()==1;
    DIVINE_PLEA = HolyOath:GetChecked() == 1;
    Test();
end

function IAAA_ApplySettings()
   
    InformationOnRaid_Config["Included"] = Included:GetChecked()==1;
    InformationOnRaid_Config["Group"] = Group:GetChecked()==1;
    InformationOnRaid_Config["MagicPortals"] = MagicPortals:GetChecked()==1;
    InformationOnRaid_Config["Rituals"] = Rituals:GetChecked()==1;
    InformationOnRaid_Config["TheHandOfSacrifice"] = TheHandOfSacrifice:GetChecked()==1;    
    InformationOnRaid_Config["LayOnHands"] = LayOnHands:GetChecked()==1;
    InformationOnRaid_Config["LayOnHands1"] = LayOnHands:GetChecked()==1;
    InformationOnRaid_Config["HandOfFreedom"] = HandOfFreedom:GetChecked()==1;
    InformationOnRaid_Config["HandOfSalvation"] = HandOfSalvation:GetChecked()==1;
    InformationOnRaid_Config["HandOfProtection"] = HandOfProtection:GetChecked()==1;
    InformationOnRaid_Config["FateOfShadow"] = FateOfShadow:GetChecked()==1;
    InformationOnRaid_Config["GuardianSpirit"] = GuardianSpirit:GetChecked()==1;
    InformationOnRaid_Config["PainSuppression"] = PainSuppression:GetChecked()==1;
    InformationOnRaid_Config["FearWard"] = FearWard:GetChecked()==1;
    InformationOnRaid_Config["Redirection"] = Redirection:GetChecked()==1;
    InformationOnRaid_Config["TranquilizingShot"] = TranquilizingShot:GetChecked()==1;
    InformationOnRaid_Config["DistractingShot"] = DistractingShot:GetChecked()==1;
    InformationOnRaid_Config["DismantleRogue"] = DismantleRogue:GetChecked()==1;
    InformationOnRaid_Config["TricksRogue"] = TricksRogue:GetChecked()==1;
    InformationOnRaid_Config["Hysteria"] = Hysteria:GetChecked()==1;
    InformationOnRaid_Config["Disarm"] = Disarm:GetChecked()==1;
    InformationOnRaid_Config["Insight"] = Insight:GetChecked()==1;
    InformationOnRaid_Config["VampireBite"] = VampireBite:GetChecked()==1;
    InformationOnRaid_Config["Engineer"] = Engineer:GetChecked()==1;
    InformationOnRaid_Config["TricksRogue"] = TricksRogue:GetChecked()==1;
    InformationOnRaid_Config["IceboundFortitude"] = IceboundFortitude:GetChecked()==1;
    InformationOnRaid_Config["VampireBlood"] = VampireBlood:GetChecked()==1;
    InformationOnRaid_Config["BarkSkin"] = BarkSkin:GetChecked()==1;
    InformationOnRaid_Config["FrenziedRegeneration"] = FrenziedRegeneration:GetChecked()==1;
    InformationOnRaid_Config["SurvivalInstincts"] = SurvivalInstincts:GetChecked()==1;
    InformationOnRaid_Config["Sofa"] = Sofa:GetChecked()==1;
    InformationOnRaid_Config["LastStand"] = LastStand:GetChecked()==1;
    InformationOnRaid_Config["LastStandEnd"] = LastStandEnd:GetChecked()==1;
    InformationOnRaid_Config["ShieldWall"] = ShieldWall:GetChecked()==1;
    InformationOnRaid_Config["IceBlock"] = IceBlock:GetChecked()==1;
    InformationOnRaid_Config["FlawlessFangOfSindragosa"] = FlawlessFangOfSindragosa:GetChecked()==1;
    InformationOnRaid_Config["Meal"] = Meal:GetChecked()==1;
    InformationOnRaid_Config["MassBuff"] = MassBuff:GetChecked()==1;
    InformationOnRaid_Config["Taunts"] = Taunts:GetChecked()==1;
    InformationOnRaid_Config["SacredSacrifice"] = SacredSacrifice:GetChecked()==1;
    InformationOnRaid_Config["HolyOath"] = HolyOath:GetChecked()==1;
end

function Apply()
    IAAA_ApplySettings()
	SetVariableValues();
    IAAA_ShowMainWindow();
   -- Print( "function Apply()"..tostring( use[48707]))
end
   --[[ SLASH COMMAND FUNCTION ]]--

local isMinHPandMP = false;
function IAAASlashCmd(iaaaSubcommand)
    local t = iaaaSubcommand;
    if(t == "") then 
       IAAA_ShowMainWindow();
    elseif(t == "test")then
        debuggingMode = debuggingMode == false;
        if(debuggingMode)then
            IaaaWindow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            isCOMBAT_LOG_EVENT_UNFILTERED = true;
		    Print("|cff00ff00активирован RegisterEvent(\"COMBAT_LOG_EVENT_UNFILTERED\").|r")
            MIN_HEALER_MANA = 2000
            MIN_TANK_HP = 2000
            deadeningPlague = "Великое благословение мудрости";
            Print(" test is on")    
        else          
            IaaaWindow:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            isCOMBAT_LOG_EVENT_UNFILTERED = false;
            Print("|cff00ff00активирован UnregisterEvent(\"COMBAT_LOG_EVENT_UNFILTERED\").|r")
            MIN_HEALER_MANA =20000
            MIN_TANK_HP =55000
            deadeningPlague = "Мертвящая чума";
            Print ("Test is off")
        end
    elseif(t == "info")then
        outputOfInformationDuringDebugging = outputOfInformationDuringDebugging == false;
        if(outputOfInformationDuringDebugging) then
		    Print("Вывод информации активен")
        else
		    Print("|cff00ff00 Вывод информации отключен.|r")
        end
    elseif(t  == "min")then
        isMinHPandMP = isMinHPandMP == false;
        if(isMinHPandMP)then
            MIN_HEALER_MANA = 2000
            MIN_TANK_HP = 2000
            Print(" Min xp = 2000 min mp = 2000")    
        else
            MIN_HEALER_MANA =20000
            MIN_TANK_HP =55000
            Print (" Min xp = 55000 min mp = 2000")
        end
    else
        Print("/ia  /iaaa - Открывает настройки аддона.");
        Print("/ia test    - Отладка приложения.");
        Print("/ia info    - Вывод информации в системные сообщения.");
        Print("/ia min     - Устанавливает минимальные значения для ХПи МП.");
    end
end

function IAAA_ShowMainWindow()
    if not (AI_CloseButton) then
        local b = CreateFrame("Button", "AI_CloseButton", IaaaWindow, "UIPanelCloseButton");
        b:SetPoint("TOPRIGHT", -3, -3);
        b:Show();
	end
	IaaaWindow:SetScale(1.2);
	if(IaaaWindow:IsVisible()) then IaaaWindow:Hide(); else IaaaWindow:Show(); end
end

function IAAA_Debag()
    print ( "IAAA_Debag"..tostring(UISpecialFrames[0]));
end

local isCOMBAT_LOG_EVENT_UNFILTERED = true;

--[[ Спамер ]]--

function Test()
	local _, instance = IsInInstance();
	if started and (instance == "raid" or (instance == "party" and spamWhenInAGroup))then
		if instance=="raid" then OUTPUT = "RAID" end
		if instance=="party" then OUTPUT = "PARTY" end
		IaaaWindow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        isCOMBAT_LOG_EVENT_UNFILTERED = true;
		Print("|cff00ff00активирован.|r")
	else
		IaaaWindow:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        isCOMBAT_LOG_EVENT_UNFILTERED = false;
        if not (started)then
            Print(" |cFFFF0000Вывод сообщений отключен|r")
        elseif (instance == "none") then
		    Print(" |cFFFF0000Вы покинули подземелье вывод сообщений остановлен.|r")
        else
		    Print(" |cFFFF0000деактивирован.|r")
        end
	end
end

function Print(...)
	return print("|cff00AAFFIAAA|r:", ...)
end

local function send(msg)
    if(debuggingMode)then 
        Print(msg);
        --  KethoEditBox_Show(allHIstory)
    else
       -- SendChatMessage(msg, OUTPUT);
    end
    WindowCombatLog:AddMessage( msg )
end

-- Иконка в для рейда 
-- local function icon(name)
-- 	local n = GetRaidTargetIndex(name)
-- 	return n and format("{rt%d} ", n) or ""
-- end


function COMBAT_LOG_EVENT_UNFILTERED(
	timestamp, -- время применения
	event, -- тип события
	srcGUID, -- GUID источника
	srcName, -- имя источника
	srcFlags, -- флаги ( для получения инфы враг\\друг)
	destGUID,  -- GUID получившего каст
	destName,  -- имя получившего каст
	destFlags, -- флаги
	spellID,  -- id спела
	spellName,  -- название спела
	school,  -- маска школы
	idScattering, -- ид при рассеивании
    nameScattering, -- заклинание которое рассеяли
    ...)  -- остальные аргументы
	
	if UnitInRaid(destName) or UnitInParty(destName) or debuggingMode then
		if spellName == SOUL_STONE and event == "SPELL_AURA_REMOVED" then
			if not soulStones[destName] then soulStones[destName] = {} end
			soulStones[destName].time = GetTime()
		elseif spellID == 27827 and event == "SPELL_AURA_APPLIED" then
			soulStones[destName] = {}
			soulStones[destName].SoR = true
		elseif event == "UNIT_DIED" and soulStones[destName] and not UnitIsFeignDeath(destName) then
			if not soulStones[destName].SoR and (GetTime() - soulStones[destName].time) < 2 then
				send(ss:format(destName, GetSpellLink(6203)))
				SendChatMessage(ss:format(destName, GetSpellLink(6203)), "RAID_WARNING")
			end
			soulStones[destName] = nil
		end
    end
	
	if UnitInRaid(srcName) or UnitInParty(srcName) or debuggingMode then
		--if true then -- Проверка на бой UnitAffectingCombat(srcName) or spellID == 49016
			if event == "SPELL_CAST_SUCCESS"  then
				if spells[spellID] then
					send(cast:format( srcName, GetSpellLink(spellID), destName))
				elseif spellID == 19752 then
					send(cast:format( srcName, GetSpellLink(spellID), destName))
				elseif use[spellID] and UnitHealthMax(srcName) >= MIN_TANK_HP then
                    Print("Имя"..tostring(srcName).."HP"..tostring(UnitHealthMax(srcName)))
					send(used:format( srcName, GetSpellLink(spellID)))
				elseif spellID == sacredSacrificeId and sacredSacrifice then
					send(used:format( srcName, GetSpellLink(spellID)))
					sacrifice[srcGUID] = true
				elseif special[spellID] then
					send(used:format( srcName, GetSpellLink(spellID)))
				elseif DIVINE_PLEA and spellID == DIVINE_PLEA_ID and UnitManaMax(srcName) >= MIN_HEALER_MANA then
					send(used:format( srcName, GetSpellLink(spellID)))
					-- elseif taunts[spellID] and destName == lanaTel then  -- 31789
					-- 		send(taunt:format( srcName, GetSpellLink(spellID), destName))
				end
				
			elseif event == "SPELL_AURA_APPLIED" then
				if spellID == 20233 or spellID == 20236 then
					send(cast:format( srcName, GetSpellLink(spellID), destName))
				elseif bonus[spellID] then
					send(used:format( srcName, GetSpellLink(spellID)))
				elseif spellID == 66233 then
					if not ad_heal then
						send(ad:format( srcName, GetSpellLink(spellID)))
					end
					ad_heal = false
				elseif spellName == HOP and UnitHealthMax(destName) >= MIN_TANK_HP then
					send(cast:format( srcName, GetSpellLink(spellID), destName))
				elseif taunts[spellID] then  -- 31789
					send(taunt:format( srcName, GetSpellLink(spellID),  destName))
				end

			elseif event == "SPELL_HEAL" then
				if spellID == 48153 or spellID == 66235 then
					local amount = ...
					ad_heal = true
					send(gs:format( srcName, GetSpellLink(spellID), amount))
				end
			end
		--end
		-- мое
		

		if event == "SPELL_CAST_SUCCESS" then
			if spellID == HEROISM then
				send(used:format( srcName, GetSpellLink(spellID)))
            elseif bots[spellID] then 
				send(bot:format( srcName, GetSpellLink(spellID)))
			elseif rituals[spellID] then
				send(create:format( srcName, GetSpellLink(spellID)))
			end
			
		elseif event == "SPELL_AURA_APPLIED" then
            if bots[spellID] then 
                send(bot:format( srcName, GetSpellLink(spellID)))
			elseif spellName == SOUL_STONE then
				local _, class = UnitClass(srcName)
				if class == "WARLOCK" then
					send(cast:format( srcName, GetSpellLink(6203), destName))
				end
			end
			
		elseif event == "SPELL_CREATE" then
			if port[spellID] then
				send(portal:format( srcName, GetSpellLink(spellID)))
			-- elseif toys[spellID] then
			-- 	send(bot:format( srcName, GetSpellLink(spellID)))
			end
			
		elseif event == "SPELL_CAST_START" then
			if feasts[spellID] then
				send(feast:format( srcName, GetSpellLink(spellID)))
			end
			
		elseif event == "SPELL_RESURRECT" then
			if spellName == REBIRTH then
				send(cast:format( srcName, GetSpellLink(spellID), destName))
			elseif spellName == CABLES then
				send(res:format( srcName, GetSpellLink(spellID), destName))
			end	
			
		elseif event == "SPELL_DISPEL_FAILED" then
			local extraID, extraName = ...
			local target = fails[extraName]
			if target or destName == target then
				send(dispel:format( srcName, GetSpellLink(spellID), destName, GetSpellLink(extraID)))
			end
		end
	end
end


function KethoEditBox_Show(text)
    if not KethoEditBox then
        local f = CreateFrame("Frame", "KethoEditBox", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(600, 500)
        
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
        
        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)
        
        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "KethoEditBoxScrollFrame", KethoEditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", KethoEditBoxButton, "TOP", 0, 0)
        
        -- EditBox
        local eb = CreateFrame("EditBox", "KethoEditBoxEditBox", KethoEditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetHistoryLines(1000);
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        
        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)
        
        local rb = CreateFrame("Button", "KethoEditBoxResizeButton", KethoEditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)
        
        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end
    
    if text then
        KethoEditBoxEditBox:SetText(text)
    end
    KethoEditBox:Show()
end



-- аргументы закончились

    -- if(outputOfInformationDuringDebugging) then
    --     Print("COMBAT_LOG_EVENT_UNFILTERED")
    --     Print(tostring(timestamp).." время применения")
    --     Print(tostring(event ).." тип события")
    --     Print(tostring(srcGUID ).." GUID источника")
    --     Print(tostring(srcName ).." имя источника")
    --     Print(tostring(srcFlags ).." флаги ( для получения инфы враг\\друг)")
    --     Print(tostring(destGUID  ).." GUID получившего каст")
    --     Print(tostring(destName  ).." имя получившего каст")
    --     Print(tostring(destFlags ).." флаги")
    --     Print(tostring(spellID  ).." id спела")
    --     Print(tostring(spellName  ).." название спела")
    --     Print(tostring(school  ).." маска школы")
	-- end
    -- print (tostring(nameScattering))
    -- if(spellName == deadeningPlague or nameScattering ==  deadeningPlague) then 
    --     if(event == "SPELL_CAST_SUCCESS") then
    --         lastPlague = destName;
    --         Print ("чума " .. destName)
    --         plagueTimer = GetTime();
    --         Iaaa_PlagueCooldown:SetCooldown(GetTime(), 5)
    --     elseif(event == "SPELL_DISPEL") then
    --         lastPlague = nil
    --         plagueTimer = 0;
    --         Print(srcName .."  dispel ".. destName )
    --         plagueExpires = false;
    --         Iaaa_PlagueCooldown:SetCooldown(0, 0)
    --     end
    -- end
    -- if(event == "UNIT_DIED")then 
    --     if(lastPlague == destName and GetTime()- plagueTimer <= 6)then
    --         lastPlague = nil
    --         plagueTimer = 0;
    --         plagueExpires = false;
    --         Iaaa_PlagueCooldown:SetCooldown(0, 0)
    --     end
    -- end
    --print("combat log")