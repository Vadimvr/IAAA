local AddOnName, ns = ...;


local WindowSetting = CreateFrame("Frame", AddOnName.."_WindowSetting", UIParent);
local width = 800;
local height = 900;
local distanceBetweenColumns = 60;
local labelSizeWight = 200;
local labelSizeHeight = 26;
local conversionRateOfTextToRealLength = 5;
local rowHeight = 30;

local _listWithLinksToAptitudeCheckButton = {};
ns.listWithLinksToAptitudeCheckButton = {} 
ns.WindowSetting  = WindowSetting;
function WindowSetting:ADDON_LOADED(addOnName)

    WindowSetting:CreateWindowsSetting()
    WindowSetting:CreateWindowsSettingElements()
    WindowSetting:CreateApplyButton(WindowSetting)
    WindowSetting:CreateTestButton(WindowSetting)
    WindowSetting:CreateHideButton(WindowSetting)
    LoadSavedSettings()
    SetValuesInSpellLists()
    WindowSetting:Show()
end

function LoadSavedSettings()
    if(not InformationOnRaid_Config) then InformationOnRaid_Config = {} end;

    if(InformationOnRaid_Config["_listWithLinksToAptitudeCheckButton"]) then 
        _listWithLinksToAptitudeCheckButton = InformationOnRaid_Config["_listWithLinksToAptitudeCheckButton"] ;
    else 
        InformationOnRaid_Config["_listWithLinksToAptitudeCheckButton"] = _listWithLinksToAptitudeCheckButton;
    end;

    for k,v in pairs(_listWithLinksToAptitudeCheckButton)do
       if(ns.listWithLinksToAptitudeCheckButton[k]) then
            ns.listWithLinksToAptitudeCheckButton[k]:SetChecked(1);
       end
    end

    for k,v in pairs(_listWithLinksToAptitudeCheckButton)do
        if(ns.listWithLinksToAptitudeCheckButton[k]) then
            ns.listWithLinksToAptitudeCheckButton[k]:SetChecked(1);
        end
    end
end

function SetValuesInSpellLists()
    SetValuesInSpellList(ns.rituals)
    SetValuesInSpellList(ns.spells )
    SetValuesInSpellList(ns.taunts) 
    SetValuesInSpellList(ns.bots)
    SetValuesInSpellList(ns.use)
    SetValuesInSpellList(ns.bonus) 
    SetValuesInSpellList(ns.feasts)  
    SetValuesInSpellList(ns.port)
    SetValuesInSpellList(ns.reborn)
end


function SetValuesInSpellList(array)
    for k,v in pairs(array)do
       -- print(k,v,ns.listWithLinksToAptitudeCheckButton[k])
        if(ns.listWithLinksToAptitudeCheckButton[k]and ns.listWithLinksToAptitudeCheckButton[k]:GetChecked() ) then
            array[k] = true;
        else
            array[k] = false;
        end
    end
    -- for k,v in pairs(array)do
    --     if(not v)then 
    --        local name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon     = GetSpellInfo(k)
   
    --         ns.WindowCombatLog:AddMessage(k.."   " ..GetSpellLink(k)    )
    --     end
    -- end
end

function  WindowSetting:CreateWindowsSetting()
    WindowSetting:SetPoint("TOPRIGHT",0,0)
   
    WindowSetting.width  = width
    WindowSetting.height = height
    WindowSetting:SetSize( WindowSetting.width,  WindowSetting.height)
    
    
    WindowSetting:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    
    WindowSetting:EnableMouse(true)

    -- Movable
    WindowSetting:SetMovable(true)
    WindowSetting:SetClampedToScreen(false)
  --  WindowSetting:SetHyperlinksEnabled(true)
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

    for i, d in pairs(ns.spellsNew1) do
        if type(d) == "table" then
            for a, b in pairs(d) do
                local name, rank = GetSpellInfo(a);
                n = string.len (name);
               
                if(n >stringLength)then 
                    stringLength = n; 
                end;
            end
        end
    end
--
    stringLength = stringLength*conversionRateOfTextToRealLength


    for i, d in pairs(ns.spellsNew1) do

        local columnName = WindowSetting:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        columnName:SetPoint("TOPLEFT", x,y);
        columnName:SetSize (labelSizeWight, labelSizeHeight)
        columnName:SetText(ns:GetColor(i)..i.."|r")
        columnName:SetJustifyH("LEFT")
        columnName:SetJustifyV("TOP")
        columnName:SetFont("Fonts\\ARIALN.ttf", 18)
        y = y - rowHeight;
       
       
        if((y < (height - rowHeight)*-1))then 
            y = -rowHeight
            x = x + stringLength;
            rowLengthOfTheLastColumn = 0
            columnName:SetPoint("TOPLEFT", x,y);
            y = y - rowHeight;
        end

        if type(d) == "table" then
            for k,v in pairs(d) do  
                local name, rank = GetSpellInfo(k)
                ns.listWithLinksToAptitudeCheckButton[k] = CreateFrame("CheckButton", WindowSetting:GetName().. "_"..k.."_CheckButton", WindowSetting,"ChatConfigCheckButtonTemplate")
                ns.listWithLinksToAptitudeCheckButton[k]:SetSize(32,32);
                ns.listWithLinksToAptitudeCheckButton[k]:SetPoint("TOPLEFT", x - 32, y+7 );
                local FontString = WindowSetting:CreateFontString(nil, "OVERLAY", "GameFontNormal");
                FontString:SetPoint("TOPLEFT", x,y);
                FontString:SetSize (labelSizeWight, labelSizeHeight)
                FontString:SetText(name.. " " .. k)
                FontString:SetJustifyH("LEFT")
                FontString:SetJustifyV("TOP")
                FontString:SetFont("Fonts\\ARIALN.ttf", 16)

                n = string.len (name);
                if(n >rowLengthOfTheLastColumn)then 
                    rowLengthOfTheLastColumn = n; 
                end;

                y = y - rowHeight;
                if(y < (height - rowHeight)*-1)then 
                    y = -rowHeight
                    x = x + stringLength;
                    rowLengthOfTheLastColumn = 0
                end
            end
        end
        if(x > width)then 
            WindowSetting:SetSize(x +rowLengthOfTheLastColumn* conversionRateOfTextToRealLength, height )
        end
    end
end

local msg = "dssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"


function WindowSetting:CreateTestButton(frame)
    local button = CreateFrame("Button", nil, frame,"UIPanelButtonTemplate" )
    button:SetPoint("BOTTOMRIGHT", -25, 50)
    button:SetSize(60, 30)
    button:SetText("Test")
    button:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            SetValuesInSpellLists();
            for i = 1, #ns.data2 do
                local a = ns.data2[i];
                ns.Core:COMBAT_LOG_EVENT_UNFILTERED(a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15],a[16],a[17],a[18],a[19]);
            end
            ns.WindowCombatLog:AddMessage("Тест") 
        elseif button == "RightButton" then 
            print("RightButton")
            print(#ns.data2)
            for i = 1, #ns.data2 do
                local a = ns.data2[i];
                ns.Core:COMBAT_LOG_EVENT_UNFILTERED(a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15],a[16],a[17],a[18],a[19]);
            end
        end
    end)
    button:Show()
end

function WindowSetting:CreateApplyButton(frame)
    local button = CreateFrame("Button", nil, frame,"UIPanelButtonTemplate" )
    button:SetPoint("BOTTOMRIGHT", -25, 25)
    button:SetSize(60, 30)
    button:SetText("Apply")
    button:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            SetValuesInSpellLists();
            ns.WindowCombatLog:AddMessage("заклинания обновлены") 
        end
    end)
    button:Show()
end
function WindowSetting:CreateHideButton(frame)
    local button = CreateFrame("Button", nil, frame,"UIPanelButtonTemplate" )
    button:SetPoint("BOTTOMRIGHT", -90, 25)
    button:SetSize(60, 30)
    button:SetText("Hide")
    button:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            frame:Hide();
        end
    end)
    button:Show()
end