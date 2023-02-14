local AddOnName, ns = ...;

local isMaxSize = true;
local lastHightMainWindow = 600;
local lastWidthMainWindow = 500;
local SliderGotoDown = true;
local buttonSize = 17;
local printLineSize = 12;
local MainWindow = CreateFrame("Frame", AddOnName .. "_WindowCombatLog_Frame", UIParent);
MainWindow.lines = 500;
local buffer = {}
local nexIndexBuffer = 1; -- индекс в буфере  куда будем вставлять элемент
local bufferSize = 100 -- MainWindow.lines; -- размер буфера;

ns.WindowCombatLog = MainWindow;

function MainWindow:ADDON_LOADED(addOnName)
    if AddOnName ~= addOnName then return; end

    MainWindow:CreateMainWindow();
    MainWindow:CreateButtons(self);
    CreateResizableButton(self);
    CreteScrollingMessageFrame(self);

    for x = 1, #ns.HistoryCombatLogBetweenSessions do
        MainWindow:AddMessage(ns.HistoryCombatLogBetweenSessions[x]);
    end

    MainWindow:AddMessage(ns:GetTimeHH_MM_SS() .. "|cff00ff00" .. ns.L["Successfully uploaded."] .. "|r");
    if (ns.ShowLog) then MainWindow:Show(); else MainWindow:Hide() end
    ns.MinimizeWindowsCombatLog:ADDON_LOADED(self, function(...) self:ShowHide() end);
end

function MainWindow:AddMessage(message)
    MainWindow:AddMessageInBuffer(message)
    MainWindow.messageFrame:AddMessage(message)
    local count = MainWindow.messageFrame:GetNumMessages(); -- устанавливаем  слайдер на последний элемент
    MainWindow.scroll:SetMinMaxValues(1, count)
    if SliderGotoDown then
        MainWindow.scroll:SetValue(count)
        MainWindow.messageFrame:ScrollToBottom()
    end
end

function MainWindow:Clear()
    buffer = {}
    nexIndexBuffer = 1;
    MainWindow.messageFrame:Clear();
    local count = MainWindow.messageFrame:GetCurrentLine();
    MainWindow.scroll:SetValue(count)
    MainWindow.scroll:SetMinMaxValues(0, MainWindow.messageFrame:GetNumMessages())
end

function MainWindow:AddMessageInBuffer(msg)
    if (nexIndexBuffer > bufferSize) then
        nexIndexBuffer = 1
    end
    -- print(nexIndexBuffer, msg)
    buffer[nexIndexBuffer] = msg;
    nexIndexBuffer = nexIndexBuffer + 1;
end

function MainWindow:SaveHistoryBetweenSessions()
    ns.HistoryCombatLogBetweenSessions = {}
    local temIndex = nexIndexBuffer - 1; -- вернуться на 1 назад
    for i = 1, bufferSize do
        if buffer[temIndex] ~= nil then
            ns.HistoryCombatLogBetweenSessions[i] = buffer[temIndex];
        else
            break;
        end
        temIndex = temIndex - 1;
        if (temIndex == 0) then
            temIndex = bufferSize; -- если индекс становиться 0 то мы переключаемся на последний элемент буфера
        end
    end

    local j = #ns.HistoryCombatLogBetweenSessions;
    for i = 1, #ns.HistoryCombatLogBetweenSessions / 2 do
        ns.HistoryCombatLogBetweenSessions[i], ns.HistoryCombatLogBetweenSessions[j] =
            ns.HistoryCombatLogBetweenSessions[j], ns.HistoryCombatLogBetweenSessions[i];
        j = j - 1;
    end

    ns.HistoryCombatLogBetweenSessions[#ns.HistoryCombatLogBetweenSessions + 1] = ns:GetTimeHH_MM_SS() .. "End session";
end

function MainWindow:PrintBuffer()
    local temIndex = nexIndexBuffer - 1; -- вернуться на 1 назад
    --    print("#buffer",#buffer)
    for i = 1, #buffer do
        print("temIndex = ", temIndex, "  i = ", i, buffer[temIndex])
        temIndex = temIndex - 1;
        if (temIndex == 0) then
            temIndex = #buffer; -- если индекс становиться 0 то мы переключаемся на последний элемент буфера
        end
    end
    local cur_val = MainWindow.scroll:GetValue()
    local min_val, max_val = MainWindow.scroll:GetMinMaxValues()
    print("cur_val = ", cur_val, "  min_val = ", min_val, "  max_val = ", max_val)
end

function MainWindow:PrintInChat()
    local cur_val = MainWindow.scroll:GetValue()
    local min_val, max_val = MainWindow.scroll:GetMinMaxValues()


    if (max_val - cur_val > bufferSize) then -- так как в буфере только bufferSize элементов
        print("Индекс за пределами буфера")
        return;
    end



    local count      = 10;
    local startIndex = max_val - cur_val; -- индекс с которого начнем это число не будет больше bufferSize так как в начале сделали проверку.
    local arrIndex   = math.min((#buffer - startIndex), printLineSize, #buffer); -- количество элементов которые возможно извлечь из массива
    local temIndex   = nexIndexBuffer - 1;
    local res        = {}
    -- print("startIndex", startIndex, "temIndex ", temIndex, "#buffer", #buffer, "bufferSize - startIndex",
    --     math.min((bufferSize - startIndex), printLineSize))
    --local temIndex = nexIndexBuffer - 1; -- вернуться на 1 назад

    temIndex         = temIndex - startIndex;
    --print(temIndex, #buffer)

    if temIndex == 0 then
        temIndex = #buffer;
    elseif temIndex < 0 then
        temIndex = #buffer + temIndex;
    else
        temIndex = temIndex;
    end
    --print(temIndex, #buffer)

    for i = startIndex, #buffer do
        --print(i, buffer[i])
        if (i >= startIndex and arrIndex >= 1) then
            res[arrIndex] = buffer[temIndex];
            arrIndex = arrIndex - 1;
        end
        temIndex = temIndex - 1;
        if (temIndex == 0) then
            temIndex = #buffer; -- если индекс становиться 0 то мы переключаемся на последний элемент буфера
        end
    end

    local Print;
    if (UnitInRaid("player")) then
        Print = function(msg)
            SendChatMessage(msg, "RAID")
        end
    elseif (UnitInParty("party1")) then
        Print = function(msg)
            SendChatMessage(msg, "PARTY")
        end
    end
    local msg
    for i = 1, #res do
        msg = res[i]
        if Print and msg then --сли
            msg = msg:gsub("|c[%w][%w][%w][%w][%w][%w][%w][%w]", "") -- удаляем цвета в сообщении |сFFdd15dd
                :gsub("|r", "") -- удаляем цвета в сообщении |r
                :gsub("|Hspell:", "|cff71d5ff|Hspell:") -- Восстанавливаем цвет для GetSpellLink()
                :gsub("]|h", "]|h|r") -- Восстанавливаем цвет для  GetSpellLink()
            Print(msg)
        else
            print(msg)
        end
    end
end

function MainWindow:ShowHide()
    if (ns.WindowCombatLog:IsVisible()) then
        ns.WindowCombatLog:Hide();
    else
        ns.WindowCombatLog:Show();
        ns.MinimizeWindowsCombatLog:Hide();
    end
    ns.ShowLog = (ns.WindowCombatLog:IsVisible() == 1);
    ns.ShowLogMineralize = (ns.MinimizeWindowsCombatLog:IsVisible() == 1)
end

-- font size and background alpha
local bg = 0.3
function MainWindow:BgPlus()
    if (ns.AlphaBackGround + 0.05 < 1) then
        ns.AlphaBackGround = ns.AlphaBackGround + 0.05;
        MainWindow:SetBackdropColor(0.5, 0.5, 0.5, ns.AlphaBackGround)
    end
end

function MainWindow:BgMinus()
    if (ns.AlphaBackGround - 0.05 > 0) then
        ns.AlphaBackGround = ns.AlphaBackGround - 0.05;
        MainWindow:SetBackdropColor(0.5, 0.5, 0.5, ns.AlphaBackGround)
    end
end

function MainWindow:FontPlus()
    if (ns.FontSizeWindowLog + 1 < 30) then
        ns.FontSizeWindowLog = ns.FontSizeWindowLog + 1
        MainWindow.messageFrame:SetFont("Fonts\\ARIALN.ttf", ns.FontSizeWindowLog)
    end
end

function MainWindow:FontMinus()
    if (ns.FontSizeWindowLog - 1 > 5) then
        ns.FontSizeWindowLog = ns.FontSizeWindowLog - 1
        MainWindow.messageFrame:SetFont("Fonts\\ARIALN.ttf", ns.FontSizeWindowLog)
    end
end

--
-- MainWindow:CreateMainWindow()
function MainWindow:CreateMainWindow()
    isMaxSize = true;
    MainWindow:SetPoint("CENTER", 0, 0)

    MainWindow.width  = 500
    MainWindow.height = 250
    MainWindow:SetSize(MainWindow.width, MainWindow.height)


    MainWindow:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    MainWindow:SetBackdropColor(0.5, 0.5, 0.5, ns.AlphaBackGround)
    --MainWindow:SetAlpha(0.1)
    MainWindow:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
    MainWindow:EnableMouse(true)
    -- Movable
    MainWindow:SetMovable(true)
    MainWindow:SetClampedToScreen(false)
    --MainWindow:SetHyperlinksEnabled(true)
    MainWindow:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            MainWindow:StartMoving()
        end
    end)
    MainWindow:SetScript("OnMouseUp", function(...)
        MainWindow:StopMovingOrSizing()
        MainWindow:Pos()
    end)
    -- Movable
    MainWindow:EnableMouseWheel(true)
end

--
-- ScrollingMessageFrame
function CreteScrollingMessageFrame(frame)
    local messageFrame = CreateFrame("ScrollingMessageFrame", nil, frame)
    messageFrame:SetPoint("TOP", frame, "TOP", -50, -20)
    messageFrame:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
    messageFrame:SetPoint("BOTTOM", frame, "BOTTOM", -20, 20)
    messageFrame:SetPoint("LEFT", frame, "LEFT", 20, 20)
    messageFrame:SetFontObject(GameFontNormal)
    messageFrame:SetTextColor(1.00, 0.49, 0.04, 1) -- default color
    messageFrame:SetJustifyH("LEFT")
    messageFrame:SetHyperlinksEnabled(true)
    messageFrame:SetScript("OnHyperlinkClick", function(self, link, text, button)
        SetItemRef(link, text, button, self)
    end)
    messageFrame:SetFading(false)
    messageFrame:SetMaxLines(MainWindow.lines)
    messageFrame:SetFont("Fonts\\ARIALN.ttf", ns.FontSizeWindowLog)
    frame.messageFrame = messageFrame

    -- ScrollingMessageFrame end
    -- Scroll bar

    local scrollBar = CreateFrame("Slider", nil, frame, "UIPanelScrollBarTemplate")
    scrollBar:SetPoint("RIGHT", frame, "RIGHT", -15, 0)
    scrollBar:SetPoint("TOP", frame, "TOP", 0, -50)
    scrollBar:SetPoint("BOTTOM", frame, "BOTTOM", 10, 40)
    scrollBar:SetMinMaxValues(1, 1)
    scrollBar:SetValueStep(1)
    scrollBar.scrollStep = 1
    -- если нажали "В низ" то разрешаем установку на последний элемент.
    IAAA_WindowCombatLog_FrameScrollDownButton:SetScript("OnMouseDown", function(self, button)
        SliderGotoDown = true;
    end)
    scrollBar:SetScript("OnValueChanged", function(self, value)
        frame.messageFrame:SetScrollOffset(select(2, scrollBar:GetMinMaxValues()) - value)
    end)

    scrollBar:SetValue(select(2, scrollBar:GetMinMaxValues()))

    frame.scroll = scrollBar

    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(self, delta)
        SliderGotoDown = false -- если покрутили слайдер, то запрещаем установку на последний элемент
        ineNum = frame.messageFrame:GetCurrentLine()
        local cur_val = frame.scroll:GetValue()
        local min_val, max_val = frame.scroll:GetMinMaxValues()
        if delta < 0 and cur_val < max_val then
            cur_val = math.min(max_val, cur_val + 1)
            frame.scroll:SetValue(cur_val)
        elseif delta > 0 and cur_val > min_val then
            cur_val = math.max(min_val, cur_val - 1)
            if (cur_val == 0) then cur_val = 1; end
            frame.scroll:SetValue(cur_val)
        end
    end)
end

--


function MainWindow:CreateButtons(frame)
    local offset_x = -14
    local offset_y = -14
    CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-close.tga",
        function(...)
            frame:ShowHide()
        end) -- close window
    offset_x = offset_x - ns.sizeButtons * 1.3
    CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-hide.tga",
        function(...)
            ns.MinimizeWindowsCombatLog:Show();
            frame:ShowHide();
        end) -- minimize window
    offset_x = offset_x - ns.sizeButtons * 1.3
    CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-setting.tga",
        function(...)
            ns.WindowSetting:ShowHide();
        end)
    offset_x = offset_x - ns.sizeButtons * 1.3

    CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-print.tga",
        function(...)
            MainWindow:PrintInChat();
        end)

    offset_x = offset_x - ns.sizeButtons * 1.3

    CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-clear.tga",
        function(...)
            MainWindow:Clear();
        end)
    -- offset_x = offset_x - ns.sizeButtons * 1.3

    -- CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-setting.tga",
    --     function(...)
    --         MainWindow:PrintBuffer();
    --     end)
    -- offset_x = offset_x - ns.sizeButtons * 1.3
    -- CreateButton(frame, ns.sizeButtons, offset_x, offset_y, "Interface\\Addons\\IAAA\\Textures\\icon-move.tga",
    --     function(...)
    --         ns:Send("Новое сообщение")
    --     end)
    -- offset_x = offset_x - ns.sizeButtons * 1.3
end

function CreateButton(frame, size, offset_x, offset_y, pathToTextures, func)
    local button = CreateFrame("Button", nil, frame)
    button:SetNormalTexture(pathToTextures)
    button:SetHighlightTexture(pathToTextures)
    button:SetPushedTexture(pathToTextures)
    button:SetPoint("TOPRIGHT", offset_x, offset_y)
    button:SetSize(size, size)
    button:SetScript("OnMouseDown", func)
    button:Show()
    return button;
end

-- Resize button
function CreateResizableButton(frame)
    frame:SetMinResize(100, 100)
    frame:SetResizable(true)
    local rb = CreateFrame("Button", nil, frame)
    rb:SetPoint("BOTTOMRIGHT", -6, 7)
    rb:SetSize(16, 16)

    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    rb:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            frame:StartSizing("BOTTOMRIGHT")
            self:GetHighlightTexture():Hide() -- more noticeable
        end
    end)
    rb:SetScript("OnMouseUp", function(self, button)
        frame:StopMovingOrSizing()
        self:GetHighlightTexture():Show()
        frame.width, frame.height = frame:GetSize();
        MainWindow:Pos();
    end)
end

function MainWindow:NewPosition(point, relativeTo, relativePoint, xOfs, yOfs, height, width)
    -- print("bl" ,point,  math.ceil(xOfs),math.ceil(yOfs) , math.ceil(height), math.ceil(width))

    xOfs = xOfs + ns.X_Offset_WindowsCombatLog;
    yOfs = yOfs + ns.Y_Offset_WindowsCombatLog;
    MainWindow:ClearAllPoints()
    if point == "TOPLEFT" then
        MainWindow:SetPoint("TOPLEFT", xOfs - MainWindow:GetWidth(), yOfs)
        MainWindow:GetThisPosition()
    elseif point == "LEFT" then
        MainWindow:SetPoint("LEFT", xOfs - MainWindow:GetWidth(), yOfs + (height / 2 - MainWindow:GetHeight() / 2))
        MainWindow:GetThisPosition()
    elseif point == "BOTTOMLEFT" then
        MainWindow:SetPoint("BOTTOMLEFT", xOfs - MainWindow:GetWidth(), yOfs + height - MainWindow:GetHeight())
        MainWindow:GetThisPosition()
    elseif point == "TOP" then
        MainWindow:SetPoint("TOP", xOfs - width / 2 - MainWindow:GetWidth() / 2, yOfs)
        MainWindow:GetThisPosition()
    elseif point == "CENTER" then
        MainWindow:SetPoint("CENTER", xOfs - width / 2 - MainWindow:GetWidth() / 2,
            yOfs + height / 2 - MainWindow:GetHeight() / 2)
        MainWindow:GetThisPosition()
    elseif point == "BOTTOM" then
        MainWindow:SetPoint("BOTTOM", xOfs - width / 2 - MainWindow:GetWidth() / 2,
            yOfs + height - MainWindow:GetHeight())
        MainWindow:GetThisPosition()
    elseif point == "TOPRIGHT" then
        MainWindow:SetPoint("TOPRIGHT", xOfs - width, yOfs)
        MainWindow:GetThisPosition()
    elseif point == "RIGHT" then
        MainWindow:SetPoint("RIGHT", xOfs - width, yOfs + height / 2 - MainWindow:GetHeight() / 2)
        MainWindow:GetThisPosition()
    elseif point == "BOTTOMRIGHT" then
        MainWindow:SetPoint("BOTTOMRIGHT", xOfs - width, yOfs + height - MainWindow:GetHeight())
        MainWindow:GetThisPosition()
    end
end

function MainWindow:Pos()
    local point, relativeTo, relativePoint, xOfs, yOfs = MainWindow:GetPoint(1)
    ns.MinimizeWindowsCombatLog:NewPosition(point, relativeTo, relativePoint, xOfs, yOfs, MainWindow:GetHeight(),
        MainWindow:GetWidth())
end

function MainWindow:GetThisPosition()
    -- local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
    -- print("WL",point, math.ceil(xOfs),math.ceil(yOfs) )
end
