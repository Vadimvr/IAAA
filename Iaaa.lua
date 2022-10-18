-- Author      : rvadi
-- Create Date : 17.10.2022 19:11:49

--[[ Loading the addon ]]--



local OUTPUT = "RAID"
local MIN_TANK_HP = 55000
local MIN_HEALER_MANA = 20000
local DIVINE_PLEA = false; 
local DIVINE_PLEA_ID = 54428 -- клятва привет еной
local sacredSacrifice = false;
local sacredSacrificeId = 64205 -- масс сакра

local bot	 = "%s%s использует %s!"
local used	 = "%s%s использует %s!"
local sw	 = "%s спадает с %s%s!"
local cast	 = "%s%s использует %s на %s%s!"
local taunt	 = "%s использует %s на %s!"
local fade	 = "%s%s %s спадает с %s%s!"
local feast  = "%s%s готовит %s!"
local gs	 = "%s%s %s потребляет: %d лечение!"
local ad	 = "%s%s %s потребляются!"
local res	 = "%s%s %s воскрешен %s%s!"
local portal = "%s%s открыт %s!"
local create = "%s%s создает %s!"
local dispel = "%s%s %s не удалось рассеять %s%s's %s!"
local ss	 = "%s умирает от %s!"
local lanatel	 = "Кровавая королева Лана'тель" 

local sacrifice  = {} -- сюда пойдут гуиды юнитов с диванами и тд
local soulstones = {} -- сюда пойдут гуиды юнитов с камнями души (локовский рес)
local ad_heal	 = false

local HEROISM	= UnitFactionGroup("player") == "Horde" and 2825 or 32182	-- Героизм\жажда крови
local REBIRTH 	= GetSpellInfo(20484)										-- Возрождение
local HOP 		= GetSpellInfo(1022)										-- Длань защиты
local SOULSTONE = GetSpellInfo(20707)										-- Воскрешение камнем души
local CABLES	= GetSpellInfo(54732)										-- Гномский дефиблирятор 


-- ритуалы
local rituals  = {}
local ritualsDefault  = {
	-- Маг
	[58659] = true, -- Обряд сотворения яств
	-- Варлок
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
	-- Прист
	[47788] = true, -- Оберегающий дух
	[33206] = true, -- Подавление боли
	[6346] = true, -- Защита от страха
	-- Хант
	[34477] = true, -- Перенаправление
	[19801] = true, -- Усмиряющий выстрел
	[20736] = true, -- Отвлекающий выстрел
	-- рога
	[51722] = true, -- Долой оружие
	[57934] = true, -- Маленькие хитрости

	-- дк
	[49016] = true, -- Истерия
	-- вар
	[676] = true, -- Дизарм
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

-- Таунты
local taunst = {}

local taunstDefault = {
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
	-- Инжа , дживсы и тд
	[22700] = true,
	[44389] = true,
	[67826] = true,
	[54710] = true,
	[54711] = true,
}

-- использование на себя
local use = {
	-- ДК
	[48707] = true,	-- Антимагический манцирь
	[48792] = true,	-- Незыблемость льда
	[55233] = true,	-- Кровь вампира

	-- Друид
	[22812] = true,	-- Дубовая кожа
	[22842] = true,	-- Неистовое восстановление
	[61336] = true,	-- Инстинкты выживания
	-- Пелодин
	[498] 	= true, -- Диван
	-- Воин
	[12975] = true,	-- Нишагу назад
	[12976] = true,	-- нишагу назад спадение
	[871] 	= true,	-- глухая оборона
	-- Маг
	[45438] = true, -- Ледяная глыба
	-- трини
	[71635] = true, -- Клык
}

-- бонусы от комплектов
local bonus = {
	-- ДК
	[70654] = false, -- [4P T10]
	-- Друль
	[70725] = true, -- [4P T10]
}

-- хавчик
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

local port = {};
local portDefault = { -- маговские порталы
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
function IAAA_OnLoad()
    IaaaWindow:RegisterEvent("PLAYER_LOGIN")
    -- IaaaWindow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    IaaaWindow:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- IaaaWindow:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
    -- Set Scale, Hide Main Window
    IaaaWindow:SetScale(UIParent:GetEffectiveScale());
    tinsert(UISpecialFrames,IaaaWindow:GetName());

    -- Slash Command Setup
    SlashCmdList["IAAA"] = IAAASlashCmd;
    SLASH_IAAA1 = "/ia";
    SLASH_IAAA2 = "/iaaa";
    Print("|cff00FFFFInformation about the abilities|r");
end

--[[ AUTO INVITE EVENT HANDLER ]]--
function IAAA_OnComms(self, event, ...)
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
    if(InformationOnRaid_Config["Magicportals"])then Magicportals:SetChecked(1); end;
    if(InformationOnRaid_Config["Rituals"])then Rituals:SetChecked(1); end;
    if(InformationOnRaid_Config["TheHandofSacrifice"])then TheHandofSacrifice:SetChecked(1); end;
    if(InformationOnRaid_Config["Layingonofhands"])then Layingonofhands:SetChecked(1); end;
    if(InformationOnRaid_Config["Layingonofhands"])then Layingonofhands:SetChecked(1); end;
    if(InformationOnRaid_Config["TheHandofFreedom"])then TheHandofFreedom:SetChecked(1); end;
    if(InformationOnRaid_Config["TheHandofSalvation"])then TheHandofSalvation:SetChecked(1); end;
    if(InformationOnRaid_Config["Durationofprotection"])then Durationofprotection:SetChecked(1); end;
    if(InformationOnRaid_Config["TheLotofDarkness"])then TheLotofDarkness:SetChecked(1); end;
    if(InformationOnRaid_Config["Protectingspirit"])then Protectingspirit:SetChecked(1); end;
    if(InformationOnRaid_Config["Painsuppression"])then Painsuppression:SetChecked(1); end;
    if(InformationOnRaid_Config["Protectionfromfear"])then Protectionfromfear:SetChecked(1); end;
    if(InformationOnRaid_Config["Redirection"])then Redirection:SetChecked(1); end;
    if(InformationOnRaid_Config["Apacifyingshot"])then Apacifyingshot:SetChecked(1); end;
    if(InformationOnRaid_Config["Adistractingshot"])then Adistractingshot:SetChecked(1); end;
    if(InformationOnRaid_Config["Downwiththeweapons"])then Downwiththeweapons:SetChecked(1); end;
    if(InformationOnRaid_Config["Littletricks"])then Littletricks:SetChecked(1); end;
    if(InformationOnRaid_Config["Hysteria"])then Hysteria:SetChecked(1); end;
    if(InformationOnRaid_Config["Disarm"])then Disarm:SetChecked(1); end;
    if(InformationOnRaid_Config["Insight"])then Insight:SetChecked(1); end;
    if(InformationOnRaid_Config["VampireBite"])then VampireBite:SetChecked(1); end;
    if(InformationOnRaid_Config["Engineer"])then Engineer:SetChecked(1); end;
    if(InformationOnRaid_Config["AntimagicArmor"])then AntimagicArmor:SetChecked(1); end;
    if(InformationOnRaid_Config["Theinviolabilityofice"])then Theinviolabilityofice:SetChecked(1); end;
    if(InformationOnRaid_Config["VampireBlood"])then VampireBlood:SetChecked(1); end;
    if(InformationOnRaid_Config["Oakleather"])then Oakleather:SetChecked(1); end;
    if(InformationOnRaid_Config["FranticRecovery"])then FranticRecovery:SetChecked(1); end;
    if(InformationOnRaid_Config["Survivalinstincts"])then Survivalinstincts:SetChecked(1); end;
    if(InformationOnRaid_Config["Sofa"])then Sofa:SetChecked(1); end;
    if(InformationOnRaid_Config["Notastepback"])then Notastepback:SetChecked(1); end;
    if(InformationOnRaid_Config["notastepbackfall"])then notastepbackfall:SetChecked(1); end;
    if(InformationOnRaid_Config["deafdefense"])then deafdefense:SetChecked(1); end;
    if(InformationOnRaid_Config["IceBlock"])then IceBlock:SetChecked(1); end;
    if(InformationOnRaid_Config["Fang"])then Fang:SetChecked(1); end;
    if(InformationOnRaid_Config["Meal"])then Meal:SetChecked(1); end;
    if(InformationOnRaid_Config["Massbuff"])then Massbuff:SetChecked(1); end;
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
    
    if(Magicportals:GetChecked()) then 
        InformationOnRaid_Config["Magicportals"] = true; 
        portal = portDefault; 
    else 
        InformationOnRaid_Config["Magicportals"] = false; 
        portal = {};
    end
    
    if(Rituals:GetChecked()) then 
        InformationOnRaid_Config["Rituals"] = true; 
        rituals = ritualsDefault; 
    else 
        InformationOnRaid_Config["Rituals"] = false; 
        rituals = {};
    end

    -- TheHandofSacrifice
    spells[6940]  = TheHandofSacrifice:GetChecked() == 1	-- Длань жертвенности
    -- Layingonofhands
	spells[20233] = Layingonofhands:GetChecked() == 1 -- Возложение рук
    -- Layingonofhands
	spells[20236] = Layingonofhands1:GetChecked() == 1 -- Возложение рук
    -- TheHandofFreedom
	spells[1044]  = TheHandofFreedom:GetChecked() == 1 -- Длань свободы
    -- TheHandofSalvation
	spells[1038]  = TheHandofSalvation:GetChecked() == 1 -- Длань спасения
    -- Durationofprotection
	spells[10278] = Durationofprotection:GetChecked() == 1 -- Длань защиты
    -- TheLotofDarkness
	spells[71169] = TheLotofDarkness:GetChecked() == 1 -- жребий тьмы
	-- Прист
    -- Protectingspirit
	spells[47788] = Protectingspirit:GetChecked() == 1 -- Оберегающий дух
    -- Painsuppression
	spells[33206] = Painsuppression:GetChecked() == 1 -- Подавление боли
    -- Protectionfromfear
	spells[6346]  = Protectionfromfear:GetChecked() == 1 -- Защита от страха
	-- Хант
    -- Redirection
	spells[34477] = Redirection:GetChecked() == 1 -- Перенаправление
    -- Apacifyingshot
	spells[19801] = Apacifyingshot:GetChecked() == 1 -- Усмиряющий выстрел
    -- Adistractingshot
	spells[20736] = Adistractingshot:GetChecked() == 1 -- Отвлекающий выстрел
	-- рога
    -- Downwiththeweapons
	spells[51722] = Downwiththeweapons:GetChecked() == 1 -- Долой оружие
    -- Littletricks
	spells[57934] = Littletricks:GetChecked() == 1 -- Маленькие хитрости

	-- дк
    -- Hysteria
	spells[49016] = Hysteria:GetChecked() == 1 -- Истерия
	-- вар
    -- Disarm
	spells[676] = Disarm:GetChecked() == 1 -- Дизарм
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
    -- AntimagicArmor
    use[48707] = AntimagicArmor:GetChecked() == 1;	-- Антимагический манцирь
    -- Theinviolabilityofice
	use[48792] = Theinviolabilityofice:GetChecked() == 1;	-- Незыблемость льда
    -- VampireBlood
	use[55233] = VampireBlood:GetChecked() == 1;	-- Кровь вампира

	-- Друид
    -- Oakleather
	use[22812] = Oakleather:GetChecked() == 1;	-- Дубовая кожа
    -- FranticRecovery
	use[22842] = FranticRecovery:GetChecked() == 1;	-- Неистовое восстановление
    -- Survivalinstincts
	use[61336] = Survivalinstincts:GetChecked() == 1;	-- Инстинкты выживания
	-- Пелодин
    -- Sofa
	use[498]= Sofa:GetChecked() == 1; -- Диван
	-- Воин
    -- Notastepback
	use[12975] = Notastepback:GetChecked() == 1;	-- Нишагу назад
    -- notastepbackfall
	use[12976] = notastepbackfall:GetChecked() == 1;	-- нишагу назад спадение
    -- deafdefense
	use[871] 	= deafdefense:GetChecked() == 1;	-- глухая оборона
	-- Маг
    -- IceBlock
	use[45438] = IceBlock:GetChecked() == 1; -- Ледяная глыба
	-- трини
    -- Fang
	use[71635] = Fang:GetChecked() == 1; -- Клык
    -- Meal
    if( Meal:GetChecked() ) then
         feasts= feastsDefault;
          InformationOnRaid_Config["Meal"] = true;
    else 
        feast = {};InformationOnRaid_Config["Meal"] = false; 
    end;
    -- Massbuff
    if( Massbuff:GetChecked() ) then 
        special= specialDefault; 
        InformationOnRaid_Config["Massbuff"] = true; 
    else 
        special = {};
        InformationOnRaid_Config["Massbuff"] = false; 
    end;

    -- Таунты в ланалель

    if( Taunts:GetChecked() ) then 
        taunst= taunstDefault; 
        InformationOnRaid_Config["Taunts"] = true; 
    else 
        taunst = {};
        InformationOnRaid_Config["Taunts"] = false; 
    end;

    sacredSacrifice = SacredSacrifice:GetChecked()==1;
    DIVINE_PLEA = HolyOath:GetChecked() == 1;
    Test();
end

function IAAA_CheckBoxes()
   
    InformationOnRaid_Config["Included"] = Included:GetChecked()==1;
    InformationOnRaid_Config["Group"] = Group:GetChecked()==1;
    InformationOnRaid_Config["Magicportals"] = Magicportals:GetChecked()==1;
    InformationOnRaid_Config["Rituals"] = Rituals:GetChecked()==1;
    InformationOnRaid_Config["TheHandofSacrifice"] = TheHandofSacrifice:GetChecked()==1;    
    InformationOnRaid_Config["Layingonofhands"] = Layingonofhands:GetChecked()==1;
    InformationOnRaid_Config["Layingonofhands1"] = Layingonofhands:GetChecked()==1;
    InformationOnRaid_Config["TheHandofFreedom"] = TheHandofFreedom:GetChecked()==1;
    InformationOnRaid_Config["TheHandofSalvation"] = TheHandofSalvation:GetChecked()==1;
    InformationOnRaid_Config["Durationofprotection"] = Durationofprotection:GetChecked()==1;
    InformationOnRaid_Config["TheLotofDarkness"] = TheLotofDarkness:GetChecked()==1;
    InformationOnRaid_Config["Protectingspirit"] = Protectingspirit:GetChecked()==1;
    InformationOnRaid_Config["Painsuppression"] = Painsuppression:GetChecked()==1;
    InformationOnRaid_Config["Protectionfromfear"] = Protectionfromfear:GetChecked()==1;
    InformationOnRaid_Config["Redirection"] = Redirection:GetChecked()==1;
    InformationOnRaid_Config["Apacifyingshot"] = Apacifyingshot:GetChecked()==1;
    InformationOnRaid_Config["Adistractingshot"] = Adistractingshot:GetChecked()==1;
    InformationOnRaid_Config["Downwiththeweapons"] = Downwiththeweapons:GetChecked()==1;
    InformationOnRaid_Config["Littletricks"] = Littletricks:GetChecked()==1;
    InformationOnRaid_Config["Hysteria"] = Hysteria:GetChecked()==1;
    InformationOnRaid_Config["Disarm"] = Disarm:GetChecked()==1;
    InformationOnRaid_Config["Insight"] = Insight:GetChecked()==1;
    InformationOnRaid_Config["VampireBite"] = VampireBite:GetChecked()==1;
    InformationOnRaid_Config["Engineer"] = Engineer:GetChecked()==1;
    InformationOnRaid_Config["AntimagicArmor"] = AntimagicArmor:GetChecked()==1;
    InformationOnRaid_Config["Theinviolabilityofice"] = Theinviolabilityofice:GetChecked()==1;
    InformationOnRaid_Config["VampireBlood"] = VampireBlood:GetChecked()==1;
    InformationOnRaid_Config["Oakleather"] = Oakleather:GetChecked()==1;
    InformationOnRaid_Config["FranticRecovery"] = FranticRecovery:GetChecked()==1;
    InformationOnRaid_Config["Survivalinstincts"] = Survivalinstincts:GetChecked()==1;
    InformationOnRaid_Config["Sofa"] = Sofa:GetChecked()==1;
    InformationOnRaid_Config["Notastepback"] = Notastepback:GetChecked()==1;
    InformationOnRaid_Config["notastepbackfall"] = notastepbackfall:GetChecked()==1;
    InformationOnRaid_Config["deafdefense"] = deafdefense:GetChecked()==1;
    InformationOnRaid_Config["IceBlock"] = IceBlock:GetChecked()==1;
    InformationOnRaid_Config["Fang"] = Fang:GetChecked()==1;
    InformationOnRaid_Config["Meal"] = Meal:GetChecked()==1;
    InformationOnRaid_Config["Massbuff"] = Massbuff:GetChecked()==1;
    InformationOnRaid_Config["Taunts"] = Taunts:GetChecked()==1;
    InformationOnRaid_Config["SacredSacrifice"] = SacredSacrifice:GetChecked()==1;
    InformationOnRaid_Config["HolyOath"] = HolyOath:GetChecked()==1;
    SetVariableValues();
end

function Apply()
	
end
   --[[ SLASH COMMAND FUNCTION ]]--
function IAAASlashCmd(aicmdtxt)
    local t = aicmdtxt;
    if(t == "") then IAAA_toggle(); end
    if(t == "?") then IAAA_Debag(); end
end

function IAAA_toggle()
    if not (AI_CloseButton) then
        local b = CreateFrame("Button", "AI_CloseButton", IaaaWindow, "UIPanelCloseButton");
        b:SetPoint("TOPRIGHT", -3, -3);
        b:Show();
	end
	IaaaWindow:SetScale(UIParent:GetEffectiveScale());
	if(IaaaWindow:IsVisible()) then IaaaWindow:Hide(); else IaaaWindow:Show(); end
end

function IAAA_Debag()
    print (tostring(UISpecialFrames[0]));
end


--[[ Спамер ]]--

function Test()
	local _, instance = IsInInstance();
    print(tostring(instance))
	if started and (instance == "raid" or (instance == "party" and spamWhenInAGroup))then
		if instance=="raid" then OUTPUT = "RAID" end
		if instance=="party" then OUTPUT = "PARTY" end
		IaaaWindow:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		Print("|cff00ff00активирован.|r")
	else
		IaaaWindow:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
	SendChatMessage(msg, OUTPUT)
end

local function icon(name)
	local n = GetRaidTargetIndex(name)
	return n and format("{rt%d}", n) or ""
end

function COMBAT_LOG_EVENT_UNFILTERED(
	timestamp, -- время применения
	event, -- тип события
	srcGUID, -- GUID кастера
	srcName, -- имя кастера
	srcFlags, -- флаги (можно борнуть для получения инфы врга\друг)
	destGUID,  -- GUID получившего каст
	destName,  -- имя получившего каст
	destFlags, -- флаги
	spellID,  -- айди спела
	spellName,  -- название спела
	school,  -- маска школы
	...)  -- остальные аргументы
	-- аргументы закончились

	-- Проверки на смерть с камнем души
    print("COMBAT_LOG_EVENT_UNFILTERED")
    print(tostring(timestamp).." время применения")
	print(tostring(event ).." тип события")
	print(tostring(srcGUID ).." GUID кастера")
	print(tostring(srcName ).." имя кастера")
	print(tostring(srcFlags ).." флаги (можно борнуть для получения инфы врга\друг)")
	print(tostring(destGUID  ).." GUID получившего каст")
	print(tostring(destName  ).." имя получившего каст")
	print(tostring(destFlags ).." флаги")
	print(tostring(spellID  ).." айди спела")
	print(tostring(spellName  ).." название спела")
	print(tostring(school  ).." маска школы")
	
	if UnitInRaid(destName) or UnitInParty(destName) then
		if spellName == SOULSTONE and event == "SPELL_AURA_REMOVED" then
			if not soulstones[destName] then soulstones[destName] = {} end
			soulstones[destName].time = GetTime()
		elseif spellID == 27827 and event == "SPELL_AURA_APPLIED" then
			soulstones[destName] = {}
			soulstones[destName].SoR = true
		elseif event == "UNIT_DIED" and soulstones[destName] and not UnitIsFeignDeath(destName) then
			if not soulstones[destName].SoR and (GetTime() - soulstones[destName].time) < 2 then
				send(ss:format(destName, GetSpellLink(6203)))
				SendChatMessage(ss:format(destName, GetSpellLink(6203)), "RAID_WARNING")
			end
			soulstones[destName] = nil
		end
	end
	
	if UnitInRaid(srcName) or UnitInParty(srcName) then
		if true then -- Проверка на бой UnitAffectingCombat(srcName) or spellID == 49016
			if event == "SPELL_CAST_SUCCESS"  then
				if spells[spellID] then
					send(cast:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				elseif spellID == 19752 then
					send(cast:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				elseif use[spellID] and UnitHealthMax(srcName) >= MIN_TANK_HP then
					send(used:format(icon(srcName), srcName, GetSpellLink(spellID)))
				elseif spellID == sacredSacrificeId and sacredSacrifice then
					send(used:format(icon(srcName), srcName, GetSpellLink(spellID)))
					sacrifice[srcGUID] = true
				elseif special[spellID] then
					send(used:format(icon(srcName), srcName, GetSpellLink(spellID)))
				elseif DIVINE_PLEA and spellID == DIVINE_PLEA_ID and UnitManaMax(srcName) >= MIN_HEALER_MANA then
					send(used:format(icon(srcName), srcName, GetSpellLink(spellID)))
					-- elseif taunst[spellID] and destName == lanatel then  -- 31789
					-- 		send(taunt:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				end
				
			elseif event == "SPELL_AURA_APPLIED" then
				if spellID == 20233 or spellID == 20236 then
					send(cast:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				elseif bonus[spellID] then
					send(used:format(icon(srcName), srcName, GetSpellLink(spellID)))
				elseif spellID == 66233 then
					if not ad_heal then
						send(ad:format(icon(srcName), srcName, GetSpellLink(spellID)))
					end
					ad_heal = false
				elseif spellName == HOP and UnitHealthMax(destName) >= MIN_TANK_HP then
					send(cast:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
				elseif taunst[spellID] and destName == lanatel then  -- 31789
					send(taunt:format( srcName, GetSpellLink(spellID),  destName))
				end

			elseif event == "SPELL_HEAL" then
				if spellID == 48153 or spellID == 66235 then
					local amount = ...
					ad_heal = true
					send(gs:format(icon(srcName), srcName, GetSpellLink(spellID), amount))
				end
			end
		end
		-- мое
		

		if event == "SPELL_CAST_SUCCESS" then
			if spellID == HEROISM then
				send(used:format(icon(srcName), srcName, GetSpellLink(spellID)))
            elseif bots[spellID] then 
				send(bot:format(icon(srcName), srcName, GetSpellLink(spellID)))
			elseif rituals[spellID] then
				send(create:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
			
		elseif event == "SPELL_AURA_APPLIED" then
            if bots[spellID] then 
                send(bot:format(icon(srcName), srcName, GetSpellLink(spellID)))
			elseif spellName == SOULSTONE then
				local _, class = UnitClass(srcName)
				if class == "WARLOCK" then
					send(cast:format(icon(srcName), srcName, GetSpellLink(6203), icon(destName), destName))
				end
			end
			
		elseif event == "SPELL_CREATE" then
			if port[spellID] then
				send(portal:format(icon(srcName), srcName, GetSpellLink(spellID)))
			elseif toys[spellID] then
				send(bot:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
			
		elseif event == "SPELL_CAST_START" then
			if feasts[spellID] then
				send(feast:format(icon(srcName), srcName, GetSpellLink(spellID)))
			end
			
		elseif event == "SPELL_RESURRECT" then
			if spellName == REBIRTH then
				send(cast:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			elseif spellName == CABLES then
				send(res:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName))
			end	
			
		elseif event == "SPELL_DISPEL_FAILED" then
			local extraID, extraName = ...
			local target = fails[extraName]
			if target or destName == target then
				send(dispel:format(icon(srcName), srcName, GetSpellLink(spellID), icon(destName), destName, GetSpellLink(extraID)))
			end
		end
	end
end



