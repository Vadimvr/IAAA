local AddOnName, ns = ...;

local isMaxSize = true;
local lastHightMainWindow = 600;
local lastWidthMainWindow = 500;

local MainWindow = CreateFrame("Frame", "WindowCombatLog_Frame", UIParent);
ns.WindowCombatLog = MainWindow;

MainWindow:RegisterEvent("ADDON_LOADED");
MainWindow:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end);

function MainWindow:ADDON_LOADED( addOnName )
    if AddOnName ~= addOnName then return; end;
    print("Core:ADDON_LOADED");
    CreateMainWindow();
    CreateHideButton(MainWindow) -- главное окно 
    CreateResizableButton(MainWindow) 
    CreteScrollingMessageFrame (MainWindow)
    MainWindow:AddMessage( " |cff00ff00 Успешно загружен.|r")
end

function MainWindow:AddMessage( msg )
    local time = time();
    local h , m  =GetGameTime();
    local s = floor(mod(time, 60))
    MainWindow.messageFrame:AddMessage( string.format("[%02d:%02d:%02d]  ", h,m,s) .. msg)
    local count = MainWindow.messageFrame:GetNumMessages();
    MainWindow.scroll:SetValue(count)
    MainWindow.scroll:SetMinMaxValues(0, count)
    MainWindow.messageFrame:ScrollToBottom()
end

-------------------------------------------------------------------------------
-- Window
-------------------------------------------------------------------------------
function CreateMainWindow()
    isMaxSize = true;
    MainWindow:SetPoint("TOPRIGHT",0,0)
   
    MainWindow.width  = 500
    MainWindow.height = 250
    MainWindow:SetSize( MainWindow.width,  MainWindow.height)
    
    
    MainWindow:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    MainWindow:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
    
    MainWindow:EnableMouse(true)
    
    -- Movable
    MainWindow:SetMovable(true)
    MainWindow:SetClampedToScreen(false)
    MainWindow:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            MainWindow:StartMoving()
        end
    end)
    MainWindow:SetScript("OnMouseUp", MainWindow.StopMovingOrSizing)
    -- Movable

    

    MainWindow:EnableMouseWheel(true)
    MainWindow:SetScript("OnMouseWheel", function(self, delta)
        print(delta)
        ineNum = messageFrame:GetCurrentLine()

        local cur_val =  MainWindow.scroll:GetValue()
        local min_val, max_val =  MainWindow.scroll:GetMinMaxValues()
        if delta < 0 and cur_val < max_val then
            cur_val = math.min(max_val, cur_val + 1)
            MainWindow.scroll:SetValue(cur_val)
        elseif delta > 0 and cur_val > min_val then
            cur_val = math.max(min_val, cur_val - 1)
            if(cur_val == 0) then cur_val = 1; end;
            print(cur_val)
            MainWindow.scroll:SetValue(cur_val)
        end
    end)

    WindowCombatLog_Frame:Show();
end

-------------------------------------------------------------------------------
-- ScrollingMessageFrame
-------------------------------------------------------------------------------
function CreteScrollingMessageFrame (frame)


    local messageFrame = CreateFrame("ScrollingMessageFrame", nil, frame)
    messageFrame:SetPoint("TOP", frame, "TOP", -50, -20)
    messageFrame:SetPoint("RIGHT", frame, "RIGHT", -20, 20)
    messageFrame:SetPoint("BOTTOM", frame, "BOTTOM", -20, 20)
    messageFrame:SetPoint("LEFT", frame, "LEFT", 20, 20)
    messageFrame:SetFontObject(GameFontNormal)
    messageFrame:SetTextColor(1, 1, 1, 1) -- default color
    messageFrame:SetJustifyH("LEFT")
    messageFrame:SetHyperlinksEnabled(true)
    messageFrame:SetFading(false)
    messageFrame:SetMaxLines(500)
    messageFrame:SetFontObject("ChatFontNormal")
    frame.messageFrame = messageFrame
    
    for i = 1, 100 do
    local time = time();
    local h , m  =GetGameTime();
    local s = floor(mod(time, 60))
    frame.messageFrame:AddMessage(" |cff00ff00 Успешно загружен.|r")
    end
    -------------------------------------------------------------------------------
    -- ScrollingMessageFrame end
    -------------------------------------------------------------------------------
    
    -------------------------------------------------------------------------------
    -- Scroll bar
    -------------------------------------------------------------------------------
    local scrollBar = CreateFrame("Slider", nil, frame, "UIPanelScrollBarTemplate")
    scrollBar:SetPoint("RIGHT", frame, "RIGHT", -10, 10)
    scrollBar:SetPoint("TOP", frame, "TOP", -50, -40)
    scrollBar:SetPoint("BOTTOM", frame, "BOTTOM", 10, 40)
    --scrollBar:SetSize(30, MainWindow.height - 40)
    scrollBar:SetMinMaxValues(0, frame.messageFrame:GetNumMessages())
    scrollBar:SetValueStep(1)
    scrollBar.scrollStep = 1
    
    scrollBar:SetScript("OnValueChanged", function(self, value)
        frame.messageFrame:SetScrollOffset(select(2, scrollBar:GetMinMaxValues()) - value)
    end)
    
    scrollBar:SetValue(select(2, scrollBar:GetMinMaxValues()))
    
    frame.scroll = scrollBar

    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function(self, delta)
        print(delta)
        ineNum = frame.messageFrame:GetCurrentLine()

        local cur_val =  frame.scroll:GetValue()
        local min_val, max_val =  frame.scroll:GetMinMaxValues()
        if delta < 0 and cur_val < max_val then
            cur_val = math.min(max_val, cur_val + 1)
            frame.scroll:SetValue(cur_val)
        elseif delta > 0 and cur_val > min_val then
            cur_val = math.max(min_val, cur_val - 1)
            if(cur_val == 0) then cur_val = 1; end;
            print(cur_val)
            frame.scroll:SetValue(cur_val)
        end
    end)


end
-------------------------------------------------------------------------------
-- Hide button
function CreateHideButton(frame)
    
    if frame == nil then print(AddOnName .. " function CreateHideButton(frame) frame is nill" ); return; end;
    -- body
    -- Hide button
    local hideMainWindowButton = CreateFrame("Button",nil, frame, "UIPanelButtonTemplate")
    hideMainWindowButton:SetPoint("TOPRIGHT", -7,-7)
    hideMainWindowButton:SetHeight(10)
    hideMainWindowButton:SetWidth(20)
    hideMainWindowButton:SetText("")
    hideMainWindowButton:SetScript("OnClick", 
    function(self)
        frame:Hide()
    end)
end

-------------------------------------------------------------------------------
-- Resize button
function CreateResizableButton(frame) 
    if frame == nil then print(AddOnName .. " function CreateResizableButton(frame)  frame is nill" ); return; end;
    -- Resizable
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
    -- Resizable end
end