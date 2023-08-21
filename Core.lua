-- Author      : rvadi
-- Create Date : 17.10.2022 19:11:49

---------------------------
local AddOnName, ns = ...;

local Core = CreateFrame("Frame", AddOnName .. "_Window", UIParent);
local _listWithLinksToAptitudeCheckButton = {}
local level = 200;


ns.Core = Core;
Core:RegisterEvent("ADDON_LOADED");
Core:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end);
local debuggingMode = true;

local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("IAAA", {
    type = "data source",
    text = "Iaaa",
    icon = [[Interface\Icons\Ability_Rogue_ShadowDance]],
})
local icon = LibStub("LibDBIcon-1.0")

function Core:ADDON_LOADED(addOnName)
    if AddOnName ~= addOnName then return; end

    ns:Init()
    icon:Register("Iaaa", ldb, ns.MinimapIcon)

    ns.WindowSetting:ADDON_LOADED();
    ns.WindowCombatLog:ADDON_LOADED(addOnName);
    -- ns.WindowSetting:Hide();
    Core:RegisterEvent("PLAYER_ENTERING_WORLD")

    Core:UnregisterEvent("ADDON_LOADED");
    Core:RegisterEvent("PLAYER_LOGOUT");

    ns:SetCommands()
    ns.WindowSetting:SetFrameLevel(level + 300);
    print("|cff00FFFF" .. ns.L["Information about the abilities"] .. "|r");
end

function Core:PLAYER_ENTERING_WORLD()
    ns.WindowCombatLog:Pos()
    ns.WindowSetting:SetFrameLevel(level + 300);
    local _, instance = IsInInstance();
    if instance == "none" then
        Print("|cFFFF0000" .. ns.L["turned off"] .. "|r")
        Core:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        Core:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        debuggingMode = true
        Print("|cff00ff00 " .. ns.L["turned on"] .. "|r")
    end
end

function ldb:OnTooltipShow()
    GameTooltip:AddLine("Iaaa", 1, .8, 0)
    GameTooltip:AddLine("Left-Click " .. ns.L["Show or hide log window."])
    GameTooltip:AddLine("Shift + Left-Click " .. ns.L["Show or hide setting window."])
end

function ldb:OnClick(button)
    if button == "LeftButton" then
        if IsShiftKeyDown() then
            ns.WindowSetting:ShowHide();
        else
            ns.WindowCombatLog:ShowHide();
        end
    end
end

function Core:PLAYER_LOGOUT()
    ns.WindowCombatLog.SaveHistoryBetweenSessions();
    ns:Exit()
end

local soulStones = {} -- сюда пойдут id юнитов с камнями души (лок рес)
local fails      = {} -- незнаю что

local ad_heal    = false
local SOUL_STONE = GetSpellInfo(20707) -- Воскрешение камнем души

function Print(...)
    return print("|cff00AAFFIAAA|r:", ...)
end

function ns:GetTimeHH_MM_SS()
    local time = time();
    local h, m = GetGameTime();
    local s    = floor(mod(time, 60))
    return (string.format("|cFF9393a8[%02d:%02d:%02d]|r  ", h, m, s))
end

local function send(msg)
    if ns.inChat then
        Print(msg);
    elseif ns.inRaidChat then
        SendChatMessage(msg, "RAID")
    end
    ns.WindowCombatLog:AddMessage(ns:GetTimeHH_MM_SS() .. msg)
end

function ns:Send(msg)
    send(msg)
end

function Core:COMBAT_LOG_EVENT_UNFILTERED(
    timestamp,      -- время применения
    event,          -- тип события
    srcGUID,        -- GUID источника
    srcName,        -- имя источника
    srcFlags,       -- флаги
    destGUID,       -- GUID получившего каст
    destName,       -- имя получившего каст
    destFlags,      -- флаги
    spellID,        -- id спела
    spellName,      -- название спела
    school,         -- маска школы
    idScattering,   -- ид при рассеивании
    nameScattering, -- заклинание которое рассеяли
    ...)            -- остальные аргументы
    --
    -- if(true) then
    --     Print("COMBAT_LOG_EVENT_UNFILTERED")
    --     Print(tostring(timestamp).." время применения")
    --     Print(tostring(event ).." тип события")
    --     Print(tostring(srcGUID ).." GUID источника")
    --     Print(tostring(srcName ).." имя источника")
    --     Print(tostring(srcFlags ).." флаги
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
            end
            soulStones[destName] = nil
        end
    end
    -- Проверку на бой
    if UnitInRaid(srcName) or UnitInParty(srcName) or debuggingMode then
        if event == "SPELL_CAST_SUCCESS" then
            if ns.spells[spellID] then
                send(ns.cast:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
            elseif ns.icc[spellID] then
                send(ns.castICC:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
            elseif ns.use[spellID] then
                send(ns.used:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            elseif ns.bots[spellID] then
                send(ns.bot:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            elseif ns.rituals[spellID] then
                send(ns.create:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            end
        elseif event == "SPELL_AURA_APPLIED" then
            if ns.taunts[spellID] then -- 31789
                send(ns.taunt:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
            elseif ns.bonus[spellID] then
                send(ns.used:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            elseif ns.bots[spellID] then
                send(ns.bot:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            elseif spellName == SOUL_STONE then
                local _, class = UnitClass(srcName)
                if class == "WARLOCK" then
                    send(ns.cast:format(GetColor(srcGUID, srcName), GetSpellLink(6203), GetColor(destGUID, destName)))
                end
            elseif ns.reborn[spellID] then
                if not ad_heal then
                    send(ns.ad:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
                end
                ad_heal = false
            end
        elseif event == "SPELL_HEAL" then
            if ns.reborn[spellID] then
                local amount = ...
                ad_heal = true
                send(ns.gs:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), amount))
            end
        elseif event == "SPELL_RESURRECT" then
            if ns.spells[spellID] then
                send(ns.cast:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName)))
            end
        elseif event == "SPELL_MISSED" then
            if ns.taunts[spellID] then -- 31789
                send(ns.tauntMissed:format(GetColor(srcGUID, srcName), GetSpellLink(spellID),
                    GetColor(destGUID, destName)))
            end
        elseif event == "SPELL_CREATE" then
            if ns.port[spellID] then
                send(ns.portal:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            end
        elseif event == "SPELL_CAST_START" then
            if ns.feasts[spellID] then
                send(ns.feast:format(GetColor(srcGUID, srcName), GetSpellLink(spellID)))
            end
        elseif event == "SPELL_DISPEL" then
            -- print("SPELL_DISPEL",ns.dispels, spellID)
            if ns.dispels[spellID] then
                send(ns.dispel:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetSpellLink(idScattering),
                    GetColor(destGUID, destName)))
            end
        elseif event == "UNIT_DIED" then
            --print("UNIT_DIED",destGUID, destName)
            if (destGUID == nil) then
                return "====================error destGUID is nil"
            end
            if (destName == nil) then
                return "====================error destName is nil"
            end
            local _, classFilename = GetPlayerInfoByGUID(tostring(destGUID))
           
            if (classFilename ~= nil) then
                send(ns.died:format(GetColor(destGUID, destName)));
            end
        end

        -- ns.dispel           = "%s %s рассеивает %s с %s!"
        -- ns.dispelFail       = "%s %s не удалось рассеять %s's %s!"
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
    if (ns.NicknameColors[guid] == nil) then
        local _, classFilename = GetPlayerInfoByGUID(tostring(guid))
        local color = ns:GetColor(classFilename)
        ns.NicknameColors[guid] = color .. name .. "|r";
    end

    return ns.NicknameColors[guid];
end

function ns:GetColor(classFilename)
    local color = "|cFFFFFFFF";
    if (classFilename == "DEATHKNIGHT") then
        color = "|cFFC41E3A";
    elseif (classFilename == "WARLOCK") then
        color = "|cFF8788EE";
    elseif (classFilename == "DRUID") then
        color = "|cFFFF7C0A";
    elseif (classFilename == "MAGE") then
        color = "|cFF3FC7EB";
    elseif (classFilename == "HUNTER") then
        color = "|cFFAAD372";
    elseif (classFilename == "PALADIN") then
        color = "|cFFF48CBA";
    elseif (classFilename == "WARRIOR") then
        color = "|cFFC69B6D";
    elseif (classFilename == "ROGUE") then
        color = "|cFFFFF468";
    elseif (classFilename == "SHAMAN") then
        color = "|cFf0070DD";
    elseif (classFilename == "PRIEST") then
        color = "|cFFFFFFFF"
    end
    return color;
end

-- function KethoEditBox_Show(text)
--     if not KethoEditBox then
--         local f = CreateFrame("Frame", "KethoEditBox", UIParent, "DialogBoxFrame")
--         f:SetPoint("CENTER")
--         f:SetSize(600, 500)

--         f:SetBackdrop({
--             bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
--             edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
--             edgeSize = 16,
--             insets = { left = 8, right = 6, top = 8, bottom = 8 },
--         })
--         f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue

--         -- Movable
--         f:SetMovable(true)
--         f:SetClampedToScreen(true)
--         f:SetScript("OnMouseDown", function(self, button)
--             if button == "LeftButton" then
--                 self:StartMoving()
--             end
--         end)
--         f:SetScript("OnMouseUp", f.StopMovingOrSizing)

--         -- ScrollFrame
--         local sf = CreateFrame("ScrollFrame", "KethoEditBoxScrollFrame", KethoEditBox, "UIPanelScrollFrameTemplate")
--         sf:SetPoint("LEFT", 16, 0)
--         sf:SetPoint("RIGHT", -32, 0)
--         sf:SetPoint("TOP", 0, -16)
--         sf:SetPoint("BOTTOM", KethoEditBoxButton, "TOP", 0, 0)

--         -- EditBox
--         local eb = CreateFrame("EditBox", "KethoEditBoxEditBox", KethoEditBoxScrollFrame)
--         eb:SetSize(sf:GetSize())
--         eb:SetMultiLine(true)
--         eb:SetHistoryLines(1000);
--         eb:SetAutoFocus(false) -- dont automatically focus
--         eb:SetFontObject("ChatFontNormal")
--         eb:SetScript("OnEscapePressed", function() f:Hide() end)
--         sf:SetScrollChild(eb)

--         -- Resizable
--         f:SetResizable(true)
--         f:SetMinResize(150, 100)

--         local rb = CreateFrame("Button", "KethoEditBoxResizeButton", KethoEditBox)
--         rb:SetPoint("BOTTOMRIGHT", -6, 7)
--         rb:SetSize(16, 16)

--         rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
--         rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
--         rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

--         rb:SetScript("OnMouseDown", function(self, button)
--             if button == "LeftButton" then
--                 f:StartSizing("BOTTOMRIGHT")
--                 self:GetHighlightTexture():Hide() -- more noticeable
--             end
--         end)
--         rb:SetScript("OnMouseUp", function(self, button)
--             f:StopMovingOrSizing()
--             self:GetHighlightTexture():Show()
--             eb:SetWidth(sf:GetWidth())
--         end)
--         f:Show()
--     end

--     if text then
--         KethoEditBoxEditBox:SetText(text)
--     end
--     KethoEditBox:Show()
-- end
