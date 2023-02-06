 -- Author      : rvadi
 -- Create Date : 17.10.2022 19:11:49

 --[[ Loading the addon ]]--
 ---------------------------
local AddOnName, ns = ...;

local nicknameColors = {} -- цвет класса по нику


local Core = CreateFrame("Frame", AddOnName.."_Window", UIParent);
local _listWithLinksToAptitudeCheckButton = {}


ns.Core = Core;
Core:RegisterEvent("ADDON_LOADED");
Core:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end);

function Core:ADDON_LOADED(addOnName)
    if AddOnName ~= addOnName then return; end;
    Core:load()
    ns.WindowCombatLog:ADDON_LOADED(addOnName);
    ns.WindowSetting:ADDON_LOADED();
    Core:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Core:RegisterEvent("PLAYER_ENTERING_WORLD")
    
    Core:UnregisterEvent("ADDON_LOADED");
    Core:RegisterEvent("PLAYER_LOGOUT");
 
    ns:SetCommands()
    -- SlashCmdList["IAAA"] = IAAASlashCmd;
    -- SLASH_IAAA1 = "/ia";
    -- SLASH_IAAA2 = "/iaaa";
    print("|cff00FFFFInformation about the abilities|r");
    CreteGetGUIDButton()
    CreteGetGUIDButton1()
end

function Core:PLAYER_ENTERING_WORLD()
    local _, instance = IsInInstance();
    print(instance)
    if instance == "none" then
        Print("|cFFFF0000 отключен.")
    else
        Print("|cff00ff00 активирован.|r")
    end
end

function Core:load()
    if(InformationOnRaid_Config["NicknameColors"]) then 
        nicknameColors = InformationOnRaid_Config["NicknameColors"];
    else
        InformationOnRaid_Config["NicknameColors"] = {}
    end
    print("end []", InformationOnRaid_Config["NicknameColors"])

end


function Core:PLAYER_LOGOUT()
    print ("PLAYER_LOGIN")
    InformationOnRaid_Config["NicknameColors"] = nicknameColors

    for k,v in pairs(ns.listWithLinksToAptitudeCheckButton) do 
        InformationOnRaid_Config["_listWithLinksToAptitudeCheckButton"][k] = v:GetChecked();
    end
end

-- кнопки
 function CreteGetGUIDButton()
    if not GetGUID_TargetButton then
        local getGUID_TargetButton = CreateFrame("Button", "GetGUID_TargetButton", UIParent,"UIPanelButtonTemplate" )
        getGUID_TargetButton:SetPoint("TOPLEFT", 50, -80)
        getGUID_TargetButton:SetSize(40, 20)
        getGUID_TargetButton:SetText("Guid")
        getGUID_TargetButton:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                if( ns.WindowCombatLog:IsVisible()) then  ns.WindowCombatLog:Hide(); else  ns.WindowCombatLog:Show(); end
            elseif button == "RightButton" then
                if(ns.WindowSetting:IsVisible()) then ns.WindowSetting:Hide(); else ns.WindowSetting:Show(); end
            end
        end)
        getGUID_TargetButton:Show()
    end
 end
 function CreteGetGUIDButton1()
    if not GetGUID_TargetButton1 then
        local getGUID_TargetButton = CreateFrame("Button", "GetGUID_TargetButton1", UIParent,"UIPanelButtonTemplate" )
        getGUID_TargetButton:SetPoint("TOPLEFT", 50, -120)
        getGUID_TargetButton:SetSize(40, 20)
        getGUID_TargetButton:SetText("47476")
        getGUID_TargetButton:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
               --  ns.listWithLinksToAptitudeCheckButton[47476]:SetChecked(1);
               Core:PLAYER_LOGOUT();
            end
        end)
        getGUID_TargetButton:Show()
    end
 end
-- кнопки



local OUTPUT = "RAID"
local MIN_TANK_HP = 55000
local MIN_HEALER_MANA = 20000


local debuggingMode = true;
	 

local soulStones = {} -- сюда пойдут id юнитов с камнями души (лок рес)
local fails = {}      -- незнаю что

ns.zealousDefender  = 66233; 

local ad_heal	 = false

local deadeningPlague = "Мертвящая чума";
local deadeningPlagueIsEnabled = true;
local outputOfInformationDuringDebugging = false;


local REBIRTH 	= GetSpellInfo(20484)										-- Возрождение
local CABLES	= GetSpellInfo(54732)										-- Гномий дефибриллятор 
local SOUL_STONE = GetSpellInfo(20707)										-- Воскрешение камнем души


local included = true;
local started = false;
local spamWhenInAGroup = false;

local isMinHPandMP = false;

function IAAASlashCmd1(iaaaSubcommand)
    local t = iaaaSubcommand;
    if(t == "") then 
        if( ns.WindowSetting:IsVisible()) then  ns.WindowSetting:Hide(); else  ns.WindowSetting:Show(); end
    elseif(t == "log")then
        if( ns.WindowCombatLog:IsVisible()) then  ns.WindowCombatLog:Hide(); else  ns.WindowCombatLog:Show(); end
    elseif(t == "chat")then
        if(ns.inChat) then
            Print("|cFFFF0000Вывод сообщений отключен|r чтобы включить |cff00ff00/ia chat.|r.")
        else
            Print("|cff00ff00Вывод сообщений активирован|r чтобы отключить |cFFFF0000/ia chat.|r.")
        end
       ns.inChat =ns.inChat== false;
    elseif(t == "raid")then
        local _, instance = IsInInstance();
        if not ns.inRaidChat and instance == "raid" then
            Print("|cff00ff00Вывод сообщений в raid активирован|r чтобы отключить |cFFFF0000/ia raid.|r.")
            ns.inRaidChat = true;
        else
            Print("|cFFFF0000Вывод сообщений в raid отключен|r чтобы включить |cff00ff00/ia raid.|r.")
            ns.inRaidChat =false
        end
    else
        Print("/ia /iaaa    - Открывает настройки аддона.");
        Print("/ia log      - Открывает окно логов.");
        Print("/ia chat     - Вывод сообщений в чат");
        Print("/ia raid     - Вывод сообщений в райд чат")
    end
end

function Print(...)
	return print("|cff00AAFFIAAA|r:", ...)
end

local function send(msg)
    if ns.inChat then 
        Print(msg);
    elseif ns.inRaidChat then
        SendChatMessage(msg, "RAID")
    end
    ns.WindowCombatLog:AddMessage( msg )
end

function Core:COMBAT_LOG_EVENT_UNFILTERED(
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
--
    -- if(true) then
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
    --   print(debuggingMode)
	-- end
   -- print("COMBAT_LOG_EVENT_UNFILTERED")
--
	if UnitInRaid(destName) or UnitInParty(destName) or debuggingMode then
     
		if spellName == SOUL_STONE and event == "SPELL_AURA_REMOVED" then
			if not soulStones[destName] then soulStones[destName] = {} end
			soulStones[destName].time = GetTime()
		elseif spellID == 27827 and event == "SPELL_AURA_APPLIED" then
			soulStones[destName] = {}
			soulStones[destName].SoR = true
		elseif event == "UNIT_DIED" and soulStones[destName] and not UnitIsFeignDeath(destName) then
			if not soulStones[destName].SoR and (GetTime() - soulStones[destName].time) < 2 then
				send(ns.ss:format(GetColor(destGUID, destName), GetSpellLink(6203)))
				--SendChatMessage(ns.ss:format(destName, GetSpellLink(6203)), "RAID_WARNING")
			end
			soulStones[destName] = nil
		end
    end
    -- Проверку на бой
	if UnitInRaid(srcName) or UnitInParty(srcName) or debuggingMode then

        if event == "SPELL_CAST_SUCCESS"  then
            if ns.spells[spellID] then
                send(ns.cast:format( GetColor(srcGUID,srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
            elseif ns.use[spellID] then
                send(ns.used:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
            elseif ns.bots[spellID] then 
                send(ns.bot:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
            elseif ns.rituals[spellID] then
                send(ns.create:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
            end
            
        elseif event == "SPELL_AURA_APPLIED" then
            if ns.taunts[spellID] then  -- 31789
                send(ns.taunt:format( GetColor(srcGUID,srcName), GetSpellLink(spellID),  GetColor(destGUID, destName)))
            elseif ns.bonus[spellID] then
                send(ns.used:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
            elseif ns.bots[spellID] then 
                send(ns.bot:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
			elseif spellName == SOUL_STONE then
				local _, class = UnitClass(srcName)
				if class == "WARLOCK" then
					send(ns.cast:format( GetColor(srcGUID,srcName), GetSpellLink(6203), GetColor(destGUID, destName)))
				end
            elseif ns.reborn[spellID]  then
                if not ad_heal then
                    send(ns.ad:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
                end
                ad_heal = false
            end

        elseif event == "SPELL_HEAL" then
            if ns.reborn[spellID] then
                local amount = ...
                ad_heal = true
                send(ns.gs:format( GetColor(srcGUID,srcName), GetSpellLink(spellID), amount))
            end
        elseif event == "SPELL_RESURRECT" then
			if ns.spells[spellID] then
				send(ns.cast:format( GetColor(srcGUID,srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
            end
        elseif event == "SPELL_MISSED" then
			if ns.taunts[spellID] then  -- 31789
                send(ns.tauntMissed:format( GetColor(srcGUID,srcName), GetSpellLink(spellID),  GetColor(destGUID, destName)))
            end
        elseif event == "SPELL_CREATE" then
			if ns.port[spellID] then
				send(ns.portal:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
			-- elseif toys[spellID] then
			-- 	send(ns.bot 	 :format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
			end
        elseif event == "SPELL_CAST_START" then
			if ns.feasts[spellID] then
				send(ns.feast:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
			end
        end

        
		-- if event == "SPELL_CAST_SUCCESS" then
        --     if ns.bots[spellID] then 
		-- 		send(ns.bot:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
		-- 	elseif ns.rituals[spellID] then
		-- 		send(ns.create:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
		-- 	end
			
		-- else
      --  if event == "SPELL_AURA_APPLIED" then
            -- if ns.bots[spellID] then 
            --     send(ns.bot:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
			-- elseif spellName == SOUL_STONE then
			-- 	local _, class = UnitClass(srcName)
			-- 	if class == "WARLOCK" then
			-- 		send(ns.cast:format( GetColor(srcGUID,srcName), GetSpellLink(6203), GetColor(destGUID, destName)))
			-- 	end
			-- end
			
		-- if event == "SPELL_CREATE" then
		-- 	if ns.port[spellID] then
		-- 		send(ns.portal:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
		-- 	-- elseif toys[spellID] then
		-- 	-- 	send(ns.bot 	 :format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
		-- 	end
			
		-- elseif event == "SPELL_CAST_START" then
		-- 	if ns.feasts[spellID] then
		-- 		send(ns.feast:format( GetColor(srcGUID,srcName), GetSpellLink(spellID)))
		-- 	end
			
		-- elseif event == "SPELL_RESURRECT" then
		-- 	if spellName == REBIRTH then
		-- 		send(ns.cast:format( GetColor(srcGUID,srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
		-- 	elseif spellName == CABLES then
		-- 		send(ns.res:format( GetColor(srcGUID,srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
		-- 	end	
			
		-- elseif event == "SPELL_DISPEL_FAILED" then
		-- 	local extraID, extraName = ...
        --     print(extraID, extraName)
		-- 	local target = fails[extraName]
		-- 	if target or destName == target then
		-- 		send(ns.dispel:format( GetColor(srcGUID,srcName), GetSpellLink(spellID), GetColor(destGUID, destName), GetSpellLink(extraID)))
		-- 	end
		-- end
	end
end

function GetColor(guid, name)
    if(nicknameColors[guid] == nil)then
        local locClass, classFilename =  GetPlayerInfoByGUID(tostring(guid))
        local color = ns:GetColor(classFilename)
        nicknameColors[guid] = color.. name.. "|r";
    end
    
    return nicknameColors[guid];
end

function ns:GetColor(classFilename)

        local color = "|cFFFFFFFF";
        if (classFilename =="DEATHKNIGHT")then
            color = "|cFFC41E3A"; 
        elseif (classFilename =="WARLOCK")then
            color = "|cFF8788EE";
        elseif (classFilename =="DRUID")then
            color = "|cFFFF7C0A";
        elseif (classFilename =="MAGE")then
            color = "|cFF3FC7EB";
        elseif (classFilename =="HUNTER")then
            color = "|cFFAAD372";
        elseif (classFilename =="PALADIN")then
            color = "|cFFF48CBA";
        elseif (classFilename =="WARRIOR")then
            color = "|cFFC69B6D";
        elseif (classFilename =="ROGUE")then
            color = "|cFFFFF468";
        elseif (classFilename =="SHAMAN")then
            color = "|cFf0070DD";
        elseif (classFilename =="PRIEST")then
            color = "|cFFFFFFFF"
        end
    return color;
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