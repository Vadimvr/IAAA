local AddOnName, ns = ...;

ns.inChat = false;
ns.inRaidChat = false;

function ns:SetCommands()
    SlashCmdList["IAAA"] = IAAASlashCmd;
    SLASH_IAAA1 = "/ia";
    SLASH_IAAA2 = "/iaaa";
end


function IAAASlashCmd(iaaaSubcommand)
    local t = iaaaSubcommand;
    if(t == "")then
        ns.WindowCombatLog:ShowHide();
    elseif(t == "s") then 
        ns.WindowSetting:ShowHide();
    -- elseif(t == "x") then 
    --     for k, v in pairs(ns.icc) do
    --         local spellName, spellRank = GetSpellInfo(k);
    --         print(spellName, k, v)
    --     end
    elseif(t == "chat")then
        if(ns.inChat) then
            Print("|cFFFF0000".. ns.L["Message output is disabled."].." |r".. ns.L["To turn on, type"].. " |cff00ff00/ia chat.|r.")
        else
            Print("|cff00ff00".. ns.L["Message output is activated."].." |r".. ns.L["To turn off, type"].. " |cFFFF0000/ia chat.|r.")
        end
       ns.inChat =ns.inChat== false;
    elseif(t == "raid")then
        local _, instance = IsInInstance();
        if not ns.inRaidChat and instance == "raid" then
            Print("|cff00ff00".. ns.L["The output of messages to the raid is activated."].." |r".. ns.L["To turn off, type"].. " |cFFFF0000/ia raid.|r.")
            ns.inRaidChat = true;
        else
            Print("|cFFFF0000".. ns.L["The output of messages in raid is disabled."].." |r".. ns.L["To turn on, type"].. " |cff00ff00/ia raid.|r.")
            ns.inRaidChat =false
        end
    else
        Print("/ia      - "..ns.L["Opens the logs window."]);
        Print("/ia s    - "..ns.L["Opens the settings window."]);
        Print("/ia chat - "..ns.L["Output of messages to the chat."]);
        Print("/ia raid - "..ns.L["Output of messages to the ride chat."]);
    end
end

