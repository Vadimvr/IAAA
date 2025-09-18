local AddOnName, ns                      = ...;
local L                                  = ns.L
local WindowSetting                      = CreateFrame("Frame", AddOnName .. "_WindowSetting", UIParent);
local width                              = 800;
local height                             = 750;
local distanceBetweenColumns             = 60;
local labelSizeWight                     = 200;
local labelSizeHeight                    = 26;
local conversionRateOfTextToRealLength   = 5;
local rowHeight                          = 30;

local listWithLinksToAptitudeCheckButton = {}
ns.WindowSetting                         = WindowSetting;
ns.SpellsAndPatterns                     = {}

function WindowSetting:ADDON_LOADED()
    WindowSetting:CreateWindowsSetting();
    WindowSetting:CreateWindowsSettingElements();
    WindowSetting:CreateButtons(WindowSetting);
    WindowSetting:LoadSavedSettings();
    SetValuesInSpellLists();
    if (ns.ShowSetting) then WindowSetting:Show(); else WindowSetting:Hide() end
end

function GetSpellInfo_local(spellID)
    return ns:GetSpellInfo_local(spellID)
end  
-- function GetSpellInfo_local(spellID)
--     if (spellID == 99999) then
--         Print(L["DIED"])
--         return L["DIED"]
--     else
--         local name , rank = GetSpellInfo(spellID)
--         return name;
--     end
-- end

function WindowSetting:ShowHide()
    if (WindowSetting:IsVisible()) then WindowSetting:Hide(); else WindowSetting:Show(); end
    ns.ShowSetting = WindowSetting:IsVisible() == 1;
end

function WindowSetting:LoadSavedSettings()
    for k, v in pairs(ns.TrackedSpells) do
        if (listWithLinksToAptitudeCheckButton[v]) then
            listWithLinksToAptitudeCheckButton[v]:SetChecked(1);
        end
    end
end

function SetValuesInSpellLists()
    ns.TrackedSpells = {}
    ns.SpellsAndPatterns={}
    for k, v in pairs(listWithLinksToAptitudeCheckButton) do
        if (listWithLinksToAptitudeCheckButton[k]:GetChecked() == 1) then
            local name = GetSpellInfo_local(k)
            if(name == nil)then
                Print(k);
            end
            ns.TrackedSpells[name] = k;
            if(k<0)then
                Print( ns.TrackedSpells[name])
            end
        end
    end

    for i = 1, #ns.NamedCategories do
        local isSpells = ns.spellsAll[ns.NamedCategories[i][1]]

        for j = 1, #isSpells do
            local record = isSpells[j]
            if (ns.SpellsAndPatterns[record.event] == nil) then
                ns.SpellsAndPatterns[record.event] = {}
            end
            -- if(record.id < 0)then
            --     print(record.id)
            -- end
         --   print(record.name)
            if (ns.TrackedSpells[record.name]) then
                if (ns.SpellsAndPatterns[record.event][record.id] == nil) then
                    ns.SpellsAndPatterns[record.event][record.id] = record.message
                end
            end
        end
    end
end

function WindowSetting:CreateWindowsSetting()
    WindowSetting:SetPoint("TOPRIGHT", 0, 0)
    WindowSetting.width  = width
    WindowSetting.height = height
    WindowSetting:SetSize(WindowSetting.width, WindowSetting.height)


    WindowSetting:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    WindowSetting:SetBackdropBorderColor(0, .44, .87, 0.5);
    WindowSetting:EnableMouse(true)

    -- Movable
    WindowSetting:SetMovable(true)
    WindowSetting:SetClampedToScreen(false)
    WindowSetting:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            WindowSetting:StartMoving()
        end
    end)

    WindowSetting:SetScript("OnMouseUp", WindowSetting.StopMovingOrSizing)
end

function WindowSetting:CreateWindowsSettingElements()
    local x = 60;
    local y = -30;
    local stringLength = 0;
    local rowLengthOfTheLastColumn = 0;
    --local n;
    for i, d in pairs(ns.spellsAll) do
        if type(d) == "table" then
            for a = 1, #d do
                if (type(d[a].id) == "number") then
                    local name = GetSpellInfo_local(d[a].id);
                    n = string.len(name);
                else
                    n = string.len(d[a].id);
                end
                if (n > stringLength) then
                    stringLength = n;
                end
                ;
            end
        end
    end

    stringLength = stringLength * conversionRateOfTextToRealLength
    local singleButton = {}
    for i = 1, #ns.NamedCategories do
        local nameColum = string.lower(ns.NamedCategories[i][2]);
        -- nameColum =  ns.NamedCategories[i][1]:sub(1,1)..nameColum:sub(2)
        local columnName = WindowSetting:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        columnName:SetPoint("TOPLEFT", x, y);
        columnName:SetSize(labelSizeWight, labelSizeHeight)
        columnName:SetText(ns:GetColor(ns.NamedCategories[i][1]) .. ns.NamedCategories[i][2] .. "|r")
        columnName:SetJustifyH("LEFT")
        columnName:SetJustifyV("TOP")
        columnName:SetFont("Fonts\\ARIALN.ttf", 18)
        y = y - rowHeight;


        if ((y < (height - rowHeight) * -1)) then
            y = -rowHeight
            x = x + stringLength;
            rowLengthOfTheLastColumn = 0
            columnName:SetPoint("TOPLEFT", x, y);
            y = y - rowHeight;
        end

        local isSpells = ns.spellsAll[ns.NamedCategories[i][1]]
        for j = 1, #isSpells do
            local k = isSpells[j].id
            local name = GetSpellInfo_local(k)
            if (singleButton[name] == nil  ) then
                singleButton[name] = 1;
                listWithLinksToAptitudeCheckButton[k] = CreateFrame("CheckButton",
                    WindowSetting:GetName() .. "_" .. k .. "_CheckButton", WindowSetting, "ChatConfigCheckButtonTemplate")
                listWithLinksToAptitudeCheckButton[k]:SetSize(32, 32);
                listWithLinksToAptitudeCheckButton[k]:SetPoint("TOPLEFT", x - 32, y + 7);
                listWithLinksToAptitudeCheckButton[k]:SetScript("OnMouseDown", function(self, button)
                    if (button == "RightButton") then
                        if (name ~= nil and k < 99999) then
                            SetItemRef(GetSpellLink(k))
                            local w, h = ItemRefTooltip:GetSize()
                            ItemRefTooltip:SetSize(w, h + 20)
                            ItemRefTooltip:AddLine("|cFFab1f5e" .. k .. "|r")
                        end
                    end
                end)
                listWithLinksToAptitudeCheckButton[k]:SetScript("OnLeave", function()
                    ItemRefTooltip:Hide();
                end)
                listWithLinksToAptitudeCheckButton[k]:SetScript("OnMouseUp", function()
                    ItemRefTooltip:Hide();
                end)
                local FontString = WindowSetting:CreateFontString(nil, "OVERLAY", "GameFontNormal");
                FontString:SetPoint("TOPLEFT", x, y);
                FontString:SetSize(labelSizeWight, labelSizeHeight)
                if (name ~= nil) then
                    FontString:SetText("|cFF7d7e8c" .. name .. "|r")
                    n = string.len(name);
                else
                    FontString:SetText("|cFF7d7e8c" .. k .. "|r")
                    n = string.len(k);
                end
                FontString:SetJustifyH("LEFT")
                FontString:SetJustifyV("TOP")
                FontString:SetFont("Fonts\\ARIALN.ttf", 16)


                if (n > rowLengthOfTheLastColumn) then
                    rowLengthOfTheLastColumn = n;
                end
                ;

                y = y - rowHeight;
                if (y < (height - rowHeight) * -1) then
                    y = -rowHeight
                    x = x + stringLength;
                    rowLengthOfTheLastColumn = 0
                end
            end
        end

        if (x > width) then
            WindowSetting:SetSize(x + 10 + rowLengthOfTheLastColumn * conversionRateOfTextToRealLength, height)
        end
    end
end

local PaddingRight      = 25;
local GapBetweenButtons = 10;
local buttonWight       = 80
function WindowSetting:CreateButtons(frame)
    frame:SetHeight(frame:GetHeight() + 50)
    WindowSetting:CreateButton(frame, ns.L["Apply"], buttonWight, function(self, button)
        if button == "LeftButton" then
            SetValuesInSpellLists();
            ns.WindowCombatLog:AddMessage("заклинания обновлены")
        end
    end)

    WindowSetting:CreateButton(frame, ns.L["Hide"], buttonWight, function(self, button)
        if button == "LeftButton" then
            frame:ShowHide();
        end
    end)

    WindowSetting:CreateButton(frame, ns.L["Select All"], buttonWight, function(self, button)
        if (self.isCheckAll == nil) then
            self.isCheckAll = true;
        end
        if button == "LeftButton" then
            if (self.isCheckAll) then
                self:SetText(ns.L["Hide All"])
                for k, v in pairs(listWithLinksToAptitudeCheckButton) do
                    v:SetChecked(1);
                end
            else
                self:SetText(ns.L["Select All"])
                for k, v in pairs(listWithLinksToAptitudeCheckButton) do
                    v:SetChecked(0);
                end
            end
            self.isCheckAll = self.isCheckAll == false
        end
    end)

    WindowSetting:CreateButton(frame, ns.L["Test"], buttonWight, function(self, button)
        SetValuesInSpellLists()
        if button == "LeftButton" then
            for i = 1, #ns.data2 do
                local a = ns.data2[i];
                ns.Core:COMBAT_LOG_EVENT_UNFILTERED(a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11],
                    a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19]);
            end
            ns.WindowCombatLog:AddMessage(ns.L["Test"])
        elseif button == "RightButton" then
            for i = 1, #ns.data2 do
                local a = ns.data2[i];
                ns.Core:COMBAT_LOG_EVENT_UNFILTERED(a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11],
                    a[12], a[13], a[14], a[15], a[16], a[17], a[18], a[19]);
            end
        end
    end)


    WindowSetting:CreateButton(frame, ns.L["BG +"], buttonWight, function(self, button)
        if button == "LeftButton" then
            ns.WindowCombatLog:BgPlus();
        end
    end)
    WindowSetting:CreateButton(frame, ns.L["BG -"], buttonWight, function(self, button)
        if button == "LeftButton" then
            ns.WindowCombatLog:BgMinus();
        end
    end)

    WindowSetting:CreateButton(frame, ns.L["Font +"], buttonWight, function(self, button)
        if button == "LeftButton" then
            ns.WindowCombatLog:FontPlus();
        end
    end)
    WindowSetting:CreateButton(frame, ns.L["Font -"], buttonWight, function(self, button)
        if button == "LeftButton" then
            ns.WindowCombatLog:FontMinus();
        end
    end)
end

function WindowSetting:CreateButton(frame, name, wightButton, func)
    local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    button:SetPoint("BOTTOMRIGHT", -PaddingRight, 20)
    button:SetSize(wightButton, 30)
    button:SetText(name)
    button:SetScript("OnMouseDown", func)
    button:Show()
    PaddingRight = PaddingRight + wightButton + GapBetweenButtons;
end
