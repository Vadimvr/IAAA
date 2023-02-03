local AddOnName, ns = ...;


local Core = CreateFrame("Frame", AddOnName.."_Window", UIParent);
ns.log = Core;

Core:RegisterEvent("ADDON_LOADED");
Core:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end);

function Core:ADDON_LOADED( addOnName )
    if AddOnName ~= addOnName then return; end;
    print("Core:ADDON_LOADED");
    CreateMainWindow(); -- главное окно 
end

function Core:SentMessageInMainWindow( msg )
    local time = time();
    local h , m  =GetGameTime();
    local s = floor(mod(time, 60))
    messageFrame_Frame:AddMessage( string.format("[%02d:%02d:%02d]  ", h,m,s) .. msg)
    local count = messageFrame_Frame:GetNumMessages();
    scrollBar_frame:SetValue(count)
    scrollBar_frame:SetMinMaxValues(0, count)
    messageFrame_Frame:ScrollToBottom()
end

local isMaxSize = true;
local lastHightMainWindow = 600;
local lastWidthMainWindow = 500;
local MainWindow

function CreateMainWindow()
    isMaxSize = true;
    MainWindow = CreateFrame("Frame", "mainWindow_frame" , UIParent);
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
    MainWindow:SetResizable(true)
    MainWindow:SetMinResize(40, 40)
    MainWindow:EnableMouse(true)
    MainWindow:EnableMouseWheel(true)
    --Movable
    MainWindow:SetMovable(true)
    MainWindow:EnableMouse(true)
    MainWindow:SetClampedToScreen(true)
    MainWindow:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            MainWindow:StartMoving()
        end
    end)
    MainWindow:SetScript("OnMouseUp", MainWindow.StopMovingOrSizing)
    
    local hideMainWindowButton = CreateFrame("Button",nil, mainWindow_frame, "UIPanelButtonTemplate")
    hideMainWindowButton:SetPoint("TOPRIGHT", -7,-7)
    hideMainWindowButton:SetHeight(10)
    hideMainWindowButton:SetWidth(20)
    hideMainWindowButton:SetText("")
    hideMainWindowButton:SetScript("OnClick", 
        function(self)
            mainWindow_frame:Hide()
    end)

    local rb = CreateFrame("Button", "mainWindowResizeButton", mainWindow_frame)
    rb:SetPoint("BOTTOMRIGHT", -6, 7)
    rb:SetSize(16, 16)
    
    rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    
    rb:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            -- scrollBar_frame:Hide()
            -- messageFrame_Frame:Hide()
            MainWindow:StartSizing("BOTTOMRIGHT")
            mainWindowResizeButton:GetHighlightTexture():Hide() -- more noticeable
        end
    end)
    rb:SetScript("OnMouseUp", function(self, button)
        -- scrollBar_frame:Show()
        -- messageFrame_Frame:Show()
        MainWindow:StopMovingOrSizing()
        mainWindowResizeButton:GetHighlightTexture():Show()
        print(MainWindow:GetSize());
        MainWindow.width, MainWindow.height =  MainWindow:GetSize();
        -- scrollBar_frame:SetSize(30, MainWindow.height - 90)
        -- messageFrame_Frame:SetSize(MainWindow.width -20, MainWindow.height - 30)
        --MainWindow:SetWidth(MainWindow:GetWidth())
    end)

    --Movable
    MainWindow:SetMovable(true)
    MainWindow:EnableMouse(true)
    MainWindow:SetClampedToScreen(true)
    MainWindow:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            
            MainWindow:StartMoving()
        end
    end)
    MainWindow:SetScript("OnMouseUp",MainWindow.StopMovingOrSizing)

   
    -- ScrollingMessageFrame
    local messageFrame = CreateFrame("ScrollingMessageFrame", "messageFrame_Frame", MainWindow)
    messageFrame:SetPoint("TOP", MainWindow, "TOP", -50, -20)
    messageFrame:SetPoint("RIGHT", MainWindow, "RIGHT", -20, 20)
    messageFrame:SetPoint("BOTTOM", MainWindow, "BOTTOM", -20, 20)
    messageFrame:SetPoint("LEFT", MainWindow, "LEFT", 20, 20)
   -- messageFrame:SetSize(MainWindow.width, MainWindow.height - 50)
    messageFrame:SetFontObject(GameFontNormal)
    messageFrame:SetTextColor(1, 1, 1, 1) -- default color
    messageFrame:SetJustifyH("LEFT")
    messageFrame:SetHyperlinksEnabled(true)
    messageFrame:SetFading(false)
    messageFrame:SetMaxLines(500)
    messageFrame:SetFontObject("ChatFontNormal")
    MainWindow.messageFrame = messageFrame
    
    for i = 1, 100 do
        local time = time();
        local h , m  =GetGameTime();
        local s = floor(mod(time, 60))
        messageFrame_Frame:AddMessage( string.format("[%02d:%02d:%02d]  ", h,m,s) .. "  |cFFFF0000Вы покинули|r подземелье вывод сообщений |cff00ff00Востановлен.|r")
    end
    --messageFrame:ScrollToBottom()
    --messageFrame:ScrollDown()
    print(messageFrame:GetNumMessages(), messageFrame:GetNumLinesDisplayed())
    
    -------------------------------------------------------------------------------
    -- Scroll bar
    -------------------------------------------------------------------------------
    local scrollBar = CreateFrame("Slider", "scrollBar_frame", mainWindow_frame, "UIPanelScrollBarTemplate")
    scrollBar:SetPoint("RIGHT", MainWindow, "RIGHT", -10, 10)
    scrollBar:SetPoint("TOP", MainWindow, "TOP", -50, -40)
    scrollBar:SetPoint("BOTTOM", MainWindow, "BOTTOM", 10, 40)
    --scrollBar:SetSize(30, MainWindow.height - 40)
    scrollBar:SetMinMaxValues(0, messageFrame_Frame:GetNumMessages())
    scrollBar:SetValueStep(1)
    scrollBar.scrollStep = 1
    MainWindow.scrollBar = scrollBar
    
    scrollBar:SetScript("OnValueChanged", function(self, value)
     --   print(value)
        messageFrame:SetScrollOffset(select(2, scrollBar:GetMinMaxValues()) - value)
    end)
    
    scrollBar:SetValue(select(2, scrollBar:GetMinMaxValues()))
    
    MainWindow:SetScript("OnMouseWheel", function(self, delta)
     --   print(messageFrame:GetNumMessages(), messageFrame:GetNumLinesDisplayed())
     print(delta)
        ineNum = messageFrame:GetCurrentLine()

        local cur_val = scrollBar:GetValue()
        local min_val, max_val = scrollBar:GetMinMaxValues()
      --  print(min_val .. "  " .. max_val .. "  " ..  ineNum )
        if delta < 0 and cur_val < max_val then
            cur_val = math.min(max_val, cur_val + 1)
            scrollBar:SetValue(cur_val)
        elseif delta > 0 and cur_val > min_val then
            cur_val = math.max(min_val, cur_val - 1)
            if(cur_val == 0) then cur_val = 1; end;
            print(cur_val)
            scrollBar:SetValue(cur_val)
        end
    end)
    mainWindow_frame:Show();
    SLASH_AHF1 = "/ahf"
    SlashCmdList.AHF = function()
        if mainWindow_frame:IsShown() then
            mainWindow_frame:Hide()
        else
            mainWindow_frame:Show()
        end
    end
end