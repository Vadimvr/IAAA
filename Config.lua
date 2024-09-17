local AddOnName, ns = ...;

ns._listWithLinksToAptitudeCheckButton = {}

ns.sizeButtons = 15; -- hide show close
ns.X_Offset_WindowsCombatLog = 69;
ns.Y_Offset_WindowsCombatLog = 14;
-- ns.SettingInWindowsSetting  =
-- {
--     "Chat" = false,
--     "Raid" = false,
-- }
-- windows setting
ns.FontSizeWindowLog = 16;
ns.AlphaBackGround = 0.3;

ns.ShowLog = true;
ns.ShowLogMineralize = false;

ns.ShowSetting = true;
ns.ShowMinimapIcon = false;

--

-- data and spells
ns.TrackedSpells = {}
ns.NicknameColors = {}
--
-- History
ns.HistoryCombatLogBetweenSessions = {}
--

function ns:Init()
    if (not _Config) then _Config = {} end
    
    -- Show log window
    if (_Config.ShowLog == nil) then _Config.ShowLog = true; end
    ns.ShowLog = _Config.ShowLog;
    -- Show log window
    if (_Config.ShowLogMineralize == nil) then _Config.ShowLogMineralize = false; end
    ns.ShowLogMineralize = _Config.ShowLogMineralize;
    --
    -- Show setting window
    if (_Config.ShowSetting == nil) then _Config.ShowSetting = true; end
    ns.ShowSetting = _Config.ShowSetting;
    --

    -- Show minimap icon
    if (_Config.ShowMinimapIcon == nil) then _Config.ShowMinimapIcon = true; end
    ns.ShowMinimapIcon = _Config.ShowMinimapIcon;
    --

    -- font combat log
    if (_Config.FontSizeWindowLog == nil) then
        _Config.FontSizeWindowLog = ns.FontSizeWindowLog;
    elseif (_Config.FontSizeWindowLog > 30 or _Config.FontSizeWindowLog < 5) then
        _Config.FontSizeWindowLog = ns.FontSizeWindowLog;
    else
        ns.FontSizeWindowLog = _Config.FontSizeWindowLog;
    end
    --

    -- alpha background  combat log
    if (_Config.AlphaBackGround == nil) then
        _Config.AlphaBackGround = ns.AlphaBackGround;
    elseif (_Config.AlphaBackGround > 1 or _Config.AlphaBackGround < 0) then
        _Config.AlphaBackGround = ns.AlphaBackGround;
    else
        ns.AlphaBackGround = _Config.AlphaBackGround;
    end
    --

    -- tracked spells
    if (_Config.TrackedSpells == nil) then
        _Config.TrackedSpells = ns.TrackedSpells;
    else
        ns.TrackedSpells = _Config.TrackedSpells;
    end
    ;
    --

    -- Character name color
    if (_Config.NicknameColors == nil or TableLength(_Config.NicknameColors) >100) then
        _Config.NicknameColors = ns.NicknameColors;
    else
        ns.NicknameColors = _Config.NicknameColors;
    end

    --

    -- history
    if (_Config.HistoryCombatLogBetweenSessions == nil) then
        _Config.HistoryCombatLogBetweenSessions = ns
            .HistoryCombatLogBetweenSessions;
    end
    ns.HistoryCombatLogBetweenSessions = _Config.HistoryCombatLogBetweenSessions;
   -- print(ns.HistoryCombatLogBetweenSessions)
    --
    if (_Config.MinimapIcon == nil) then
        _Config.MinimapIcon = {
            hide = false,
            minimapPos = 110,
            radius = 80,
        };
    end

    ns.MinimapIcon = _Config.MinimapIcon
end

function TableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end


function ns:Exit()
    if (not _Config) then _Config = {} end

    _Config.ShowLog = ns.ShowLog;
    _Config.ShowLogMineralize = ns.ShowLogMineralize;
    _Config.ShowSetting = ns.ShowSetting;
    _Config.ShowMinimapIcon = ns.ShowMinimapIcon;

    _Config.FontSizeWindowLog = ns.FontSizeWindowLog;
    _Config.AlphaBackGround = ns.AlphaBackGround;

    _Config.TrackedSpells = ns.TrackedSpells;
    _Config.NicknameColors = ns.NicknameColors;

    _Config.HistoryCombatLogBetweenSessions = ns.HistoryCombatLogBetweenSessions;
    _Config.MinimapIcon =ns.MinimapIcon ;
end
