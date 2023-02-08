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
    elseif(t == "chat")then
        if(ns.inChat) then
            Print("|cFFFF0000Вывод сообщений отключен|r чтобы включить |cff00ff00/ia chat.|r.")
        else
            Print("|cff00ff00Вывод сообщений активирован|r чтобы отключить |cFFFF0000/ia chat.|r.")
        end
       ns.inChat =ns.inChat== false;
    elseif(t == "raid")then
        local _, instance = IsInInstance();
        if not ns.inRaidChat and instance == "raid" then
            Print("|cff00ff00Вывод сообщений в raid активирован|r чтобы отключить |cFFFF0000/ia raid.|r.")
            ns.inRaidChat = true;
        else
            Print("|cFFFF0000Вывод сообщений в raid отключен|r чтобы включить |cff00ff00/ia raid.|r.")
            ns.inRaidChat =false
        end
    else
        Print("/ia /iaaa    - Открывает настройки аддона.");
        Print("/ia s        - Открывает окно настроек.");
        Print("/ia chat     - Вывод сообщений в чат");
        Print("/ia raid     - Вывод сообщений в райд чат")
    end
end