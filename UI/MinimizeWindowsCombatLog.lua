local AddOnName, ns = ...;

local MinimizeWindowsCombatLog = CreateFrame("Frame", AddOnName .. "MinimizeWindowsCombatLog", UIParent);
ns.MinimizeWindowsCombatLog = MinimizeWindowsCombatLog

function MinimizeWindowsCombatLog:ADDON_LOADED(frameShow, func)
    MinimizeWindowsCombatLog:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    MinimizeWindowsCombatLog:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
    MinimizeWindowsCombatLog:SetBackdropColor(0.5, 0.5, 0.5, ns.AlphaBackGround)
    MinimizeWindowsCombatLog:SetSize(55, ns.sizeButtons)
    MinimizeWindowsCombatLog:EnableMouse(true)

    local offset_x = 0;
    local offset_y = 0;
    MinimizeWindowsCombatLog.buttonClose = CreateButton(self, ns.sizeButtons, offset_x, offset_y,
        "Interface\\Addons\\IAAA\\Textures\\icon-close.tga",
        function(...)
            self:Hide();
            ns.ShowLogMineralize = false;
        end)
    offset_x = offset_x - ns.sizeButtons * 1.3
    MinimizeWindowsCombatLog.buttonShow = CreateButton(self, ns.sizeButtons, offset_x, offset_y,
        "Interface\\Addons\\IAAA\\Textures\\icon-show.tga", func)
    offset_x = offset_x - ns.sizeButtons * 1.3

    -- Move
    MinimizeWindowsCombatLog:SetMovable(true)
    MinimizeWindowsCombatLog:SetClampedToScreen(true)

    MinimizeWindowsCombatLog.buttonMove = CreateButton(self, ns.sizeButtons, offset_x, offset_y,
        "Interface\\Addons\\IAAA\\Textures\\icon-move.tga", func)

    --MainWindow:SetHyperlinksEnabled(true)
    MinimizeWindowsCombatLog.buttonMove:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            MinimizeWindowsCombatLog:StartMoving()
        end
    end)
    MinimizeWindowsCombatLog.buttonMove:SetScript("OnMouseUp", function(...)
        MinimizeWindowsCombatLog:StopMovingOrSizing()
        MinimizeWindowsCombatLog:Pos()
    end)

    MinimizeWindowsCombatLog:SetTooltip();


    if (ns.ShowLogMineralize) then
        self:Show()
    else
        self:Hide();
    end
end

function MinimizeWindowsCombatLog:SetTooltip()
    -- MinimizeWindowsCombatLog.buttonClose:SetScript("OnEnter", function()
    --     GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --     GameTooltip:AddLine("Закрыть")
    --     GameTooltip:Show()
    -- end)
    -- MinimizeWindowsCombatLog.buttonClose:SetScript("OnLeave", function()
    --     GameTooltip:Hide()
    -- end)

    -- MinimizeWindowsCombatLog.buttonShow:SetScript("OnEnter", function()
    --     GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --     GameTooltip:AddLine("Открыть комат лог")
    --     GameTooltip:Show()
    -- end)
    -- MinimizeWindowsCombatLog.buttonShow:SetScript("OnLeave", function()
    --     GameTooltip:Hide()
    -- end)


    -- MinimizeWindowsCombatLog.buttonMove:SetScript("OnEnter", function()
    --     GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
    --     GameTooltip:AddLine("Переместить")
    --     GameTooltip:Show()
    -- end)
    -- MinimizeWindowsCombatLog.buttonMove:SetScript("OnLeave", function()
    --     GameTooltip:Hide()
    -- end)
end

function MinimizeWindowsCombatLog:CreateButton(frame, size, offset_x, offset_y, pathToTextures, func)
    local button = CreateFrame("Button", nil, frame)
    button:SetNormalTexture(pathToTextures)
    button:SetHighlightTexture(pathToTextures)
    button:SetPushedTexture(pathToTextures)

    button:SetPoint("LEFT", offsetButtonsByX, 0)
    button:SetSize(size, size)
    button:SetScript("OnMouseDown", func)
    button:Show()
    offset = offset + size * 2
end

function MinimizeWindowsCombatLog:NewPosition(point, relativeTo, relativePoint, xOfs, yOfs, height, width)
    -- print(point,  math.ceil(xOfs),math.ceil(yOfs) , math.ceil(height), math.ceil(width))

    xOfs = xOfs - ns.X_Offset_WindowsCombatLog;
    yOfs = yOfs - ns.Y_Offset_WindowsCombatLog;
    MinimizeWindowsCombatLog:ClearAllPoints()
    if point == "TOPLEFT" then
        MinimizeWindowsCombatLog:SetPoint("TOPLEFT", xOfs + width, yOfs)
    elseif point == "LEFT" then
        MinimizeWindowsCombatLog:SetPoint("LEFT", xOfs + width,
            yOfs + (height / 2 - MinimizeWindowsCombatLog:GetHeight() / 2))
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "BOTTOMLEFT" then
        MinimizeWindowsCombatLog:SetPoint("BOTTOMLEFT", xOfs + width,
            yOfs + height - MinimizeWindowsCombatLog:GetHeight())
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "TOP" then
        MinimizeWindowsCombatLog:SetPoint("TOP", xOfs + width / 2 + MinimizeWindowsCombatLog:GetWidth() / 2, yOfs)
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "CENTER" then
        MinimizeWindowsCombatLog:SetPoint("CENTER", xOfs + width / 2 + MinimizeWindowsCombatLog:GetWidth() / 2,
            yOfs + height / 2 - MinimizeWindowsCombatLog:GetHeight() / 2)
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "BOTTOM" then
        MinimizeWindowsCombatLog:SetPoint("BOTTOM", xOfs + width / 2 + MinimizeWindowsCombatLog:GetWidth() / 2,
            yOfs + height - MinimizeWindowsCombatLog:GetHeight())
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "TOPRIGHT" then
        MinimizeWindowsCombatLog:SetPoint("TOPRIGHT", xOfs + MinimizeWindowsCombatLog:GetWidth(), yOfs)
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "RIGHT" then
        MinimizeWindowsCombatLog:SetPoint("RIGHT", xOfs + MinimizeWindowsCombatLog:GetWidth(),
            yOfs + height / 2 - MinimizeWindowsCombatLog:GetHeight() / 2)
        MinimizeWindowsCombatLog:GetThisPosition()
    elseif point == "BOTTOMRIGHT" then
        MinimizeWindowsCombatLog:SetPoint("BOTTOMRIGHT", xOfs + MinimizeWindowsCombatLog:GetWidth(),
            yOfs + height - MinimizeWindowsCombatLog:GetHeight())
        MinimizeWindowsCombatLog:GetThisPosition()
    end
end

function MinimizeWindowsCombatLog:Pos()
    local point, relativeTo, relativePoint, xOfs, yOfs = MinimizeWindowsCombatLog:GetPoint(1)
    ns.WindowCombatLog:NewPosition(point, relativeTo, relativePoint, xOfs, yOfs, MinimizeWindowsCombatLog:GetHeight(),
        MinimizeWindowsCombatLog:GetWidth())
end

function MinimizeWindowsCombatLog:GetThisPosition()
    -- local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint(1)
    -- print(point, math.ceil(xOfs),math.ceil(yOfs) )
end
