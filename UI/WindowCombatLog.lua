local AddOnName, ns = ...;

local isMaxSize = true;
local lastHightMainWindow = 600;
local lastWidthMainWindow = 500;

local buttonSize = 17;

local MainWindow = CreateFrame("Frame",AddOnName.."_WindowCombatLog_Frame", UIParent);
MainWindow.lines = 500;
ns.WindowCombatLog = MainWindow;

function MainWindow:ADDON_LOADED( addOnName )
    if AddOnName ~= addOnName then return; end;
    MainWindow:CreateMainWindow();
    CreateHideButton(MainWindow);
    CreateSettingButton(MainWindow)
    CreateResizableButton(MainWindow) 
    CreteScrollingMessageFrame (MainWindow)
    MainWindow:AddMessage( " |cff00ff00 Успешно загружен.|r")
    if(ns.ShowLog)then MainWindow:Show(); else MainWindow:Hide() end;
    print(" MainWindow:ADDON_LOADED( addOnName )")
end

function MainWindow:AddMessage( msg)
    local time = time();
    local h , m  =GetGameTime();
    local s = floor(mod(time, 60))
    MainWindow.messageFrame:AddMessage( string.format("|cFF9393a8[%02d:%02d:%02d]|r  ", h,m,s) .. msg )
    local count = MainWindow.messageFrame:GetNumMessages();
    MainWindow.scroll:SetValue(count)
    MainWindow.scroll:SetMinMaxValues(0, count)
    MainWindow.messageFrame:ScrollToBottom()
end

function MainWindow:ShowHide()
    if( ns.WindowCombatLog:IsVisible()) then  ns.WindowCombatLog:Hide(); else  ns.WindowCombatLog:Show(); end
    ns.ShowLog =(ns.WindowCombatLog:IsVisible() == 1);
    print(ns.WindowCombatLog:IsVisible(),ns.ShowLog)
end

local bg = 0.3
function MainWindow:BgPlus()
    if(ns.AlphaBackGround  + 0.05 <1) then
        ns.AlphaBackGround  = ns.AlphaBackGround  + 0.05;
        MainWindow:SetBackdropColor(0.5, 0.5, 0.5,ns.AlphaBackGround )
    end
end

function MainWindow:BgMinus()
    if(ns.AlphaBackGround  - 0.05 >0) then
        ns.AlphaBackGround  = ns.AlphaBackGround  - 0.05;
        MainWindow:SetBackdropColor(0.5, 0.5, 0.5,ns.AlphaBackGround )
    end
end


function MainWindow:FontPlus()
    if(ns.FontSizeWindowLog + 1 <30) then
        ns.FontSizeWindowLog = ns.FontSizeWindowLog + 1
        MainWindow.messageFrame:SetFont("Fonts\\ARIALN.ttf", ns.FontSizeWindowLog)
    end
end

function MainWindow:FontMinus()
    if(ns.FontSizeWindowLog - 1 >5) then
        ns.FontSizeWindowLog = ns.FontSizeWindowLog - 1
        MainWindow.messageFrame:SetFont("Fonts\\ARIALN.ttf", ns.FontSizeWindowLog)
    end
end

-- Window
function MainWindow:CreateMainWindow()
    isMaxSize = true;
    MainWindow:SetPoint("CENTER",0,0)
   
    MainWindow.width  = 500
    MainWindow.height = 250
    MainWindow:SetSize( MainWindow.width,  MainWindow.height)
    
    
    MainWindow:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    MainWindow:SetBackdropColor(0.5, 0.5, 0.5,ns.AlphaBackGround )
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
    MainWindow:SetScript("OnMouseUp", MainWindow.StopMovingOrSizing)
    -- Movable
    MainWindow:EnableMouseWheel(true)
end

-- ScrollingMessageFrame 
function CreteScrollingMessageFrame (frame)
    local messageFrame = CreateFrame("ScrollingMessageFrame", nil, frame)
    messageFrame:SetPoint("TOP", frame, "TOP", -50, -20)
    messageFrame:SetPoint("RIGHT", frame, "RIGHT", -20, 0)
    messageFrame:SetPoint("BOTTOM", frame, "BOTTOM", -20, 20)
    messageFrame:SetPoint("LEFT", frame, "LEFT", 20, 20)
    messageFrame:SetFontObject(GameFontNormal)
    messageFrame:SetTextColor( 1.00, 0.49, 0.04,1) -- default color
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
    
    local scrollBar = CreateFrame("Slider", nil, frame,"UIPanelScrollBarTemplate")
    scrollBar:SetPoint("RIGHT", frame, "RIGHT", -15, 0)
    scrollBar:SetPoint("TOP", frame, "TOP",0 , -50)
    scrollBar:SetPoint("BOTTOM", frame, "BOTTOM", 10, 40)
    scrollBar:SetMinMaxValues(0,1)
    scrollBar:SetValueStep(1)
    scrollBar.scrollStep = 1
    
    scrollBar:SetScript("OnValueChanged", function(self, value)
        frame.messageFrame:SetScrollOffset(select(2, scrollBar:GetMinMaxValues()) - value)
    end)
    
    scrollBar:SetValue(select(2, scrollBar:GetMinMaxValues()))

    frame.scroll = scrollBar

    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(self, delta)
        ineNum = frame.messageFrame:GetCurrentLine()
        local cur_val =             frame.scroll:GetValue()
        local min_val, max_val =    frame.scroll:GetMinMaxValues()
        if delta < 0 and cur_val < max_val then
            cur_val = math.min(max_val, cur_val + 1)
            frame.scroll:SetValue(cur_val)
        elseif delta > 0 and cur_val > min_val then
            cur_val = math.max(min_val, cur_val - 1)
            if(cur_val == 0) then cur_val = 1; end;
            frame.scroll:SetValue(cur_val)
        end
    end)
end




-- Resize button
function CreateResizableButton(frame) 
    if frame == nil then print(AddOnName .. " function CreateResizableButton(frame)  frame is nill" ); return; end;
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
        frame.width, frame.height =  frame:GetSize();
      
    end)
end

-- Hide button
function CreateHideButton(frame)
    
    if frame == nil then print(AddOnName .. " function CreateHideButton(frame) frame is nill" ); return; end;
    -- body
    -- Hide button
    local hideMainWindowButton = CreateFrame("Button",nil, frame)
    hideMainWindowButton:SetPoint("TOPRIGHT", -14,-14)
    hideMainWindowButton:SetHeight(buttonSize)
    hideMainWindowButton:SetWidth(buttonSize)

    hideMainWindowButton:SetNormalTexture("Interface\\Addons\\IAAA\\Textures\\icon-reset.tga")
    hideMainWindowButton:SetHighlightTexture("Interface\\Addons\\IAAA\\Textures\\icon-reset.tga")
    hideMainWindowButton:SetPushedTexture("Interface\\Addons\\IAAA\\Textures\\icon-reset.tga")

    hideMainWindowButton:SetScript("OnClick",
    function(self)
        frame:ShowHide()
    end)
end

-- Swtting button
function CreateSettingButton(frame)
    
    if frame == nil then print(AddOnName .. " function CreateHideButton(frame) frame is nill" ); return; end;
    -- body
    -- Hide button UIPanelCloseButton UIPanelButtonTemplate
    local hideMainWindowButton = CreateFrame("Button",nil, frame)

    hideMainWindowButton:SetPoint("TOPRIGHT", -31,-15)
    hideMainWindowButton:SetHeight(buttonSize - 2)
    hideMainWindowButton:SetWidth(buttonSize - 2)
    hideMainWindowButton:SetNormalTexture("Interface\\Addons\\IAAA\\Textures\\icon-config.tga")
    hideMainWindowButton:SetHighlightTexture("Interface\\Addons\\IAAA\\Textures\\icon-config.tga")
    hideMainWindowButton:SetPushedTexture("Interface\\Addons\\IAAA\\Textures\\icon-config.tga")

    hideMainWindowButton:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
    hideMainWindowButton:SetScript("OnClick", 
    function(self)
         ns.WindowSetting:ShowHide()
    end)
end