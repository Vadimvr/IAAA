-- Author      : rvadi
-- Create Date : 17.10.2022 19:11:49

---------------------------
local AddOnName, ns = ...;
local L = ns.L
local Core = CreateFrame("Frame", AddOnName .. "_Window", UIParent);
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

function Print(...) return ns:Print(...) end

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


local src;
local dest;
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
    idScattering,   -- ид при рассеивании или урон от спела
    nameScattering, -- заклинание которое рассеяли
    ...)            -- остальные аргументы
    if(false) then
        Print("COMBAT_LOG_EVENT_UNFILTERED")
        Print(tostring(timestamp).." время применения")
        Print(tostring(event ).." тип события")
        Print(tostring(srcGUID ).." GUID источника")
        Print(tostring(srcName ).." имя источника")
        Print(tostring(srcFlags ).." флаги")
        Print(tostring(destGUID  ).." GUID получившего каст")
        Print(tostring(destName  ).." имя получившего каст")
        Print(tostring(destFlags ).." флаги")
        Print(tostring(spellID  ).." id спела")
        Print(tostring(spellName  ).." название спела")
        Print(tostring(school  ).." маска школы")
        Print(tostring(idScattering  ).." ид при рассеивании")
        print(debuggingMode)
    end

    if UnitInRaid(srcName) or UnitInParty(srcName) or debuggingMode then
        if (ns.SpellsAndPatterns[event]) then
            if (ns.SpellsAndPatterns[event][spellID]) then
                send(ns.SpellsAndPatterns[event][spellID](srcGUID, srcName, spellID, destGUID, destName, idScattering));
            elseif(event == "UNIT_DIED" and ns:UnitIsPlayer_local(destGUID) )then
                if (ns.SpellsAndPatterns[event][99999]) then
                    send(ns.SpellsAndPatterns[event][99999](srcGUID, srcName, 99999, destGUID, destName, idScattering));
                end
            end
        end
    end
end