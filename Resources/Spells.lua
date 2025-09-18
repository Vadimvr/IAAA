local AddOnName, ns = ...;

local SPELL_AURA_APPLIED = "SPELL_AURA_APPLIED"
local SPELL_CAST_SUCCESS = "SPELL_CAST_SUCCESS"
local SPELL_CAST_START = "SPELL_CAST_START"
local SPELL_CREATE = "SPELL_CREATE"
local SPELL_RESURRECT = "SPELL_RESURRECT"
local SPELL_AURA_REMOVED = "SPELL_AURA_REMOVED"
local UNIT_DIED = "UNIT_DIED";
local SPELL_DISPEL_FAILED = "SPELL_DISPEL_FAILED"
local SPELL_HEAL = "SPELL_HEAL"
local SPELL_MISSED = "SPELL_MISSED"
local SPELL_DAMAGE = "SPELL_DAMAGE"
local SPELL_PERIODIC_HEAL = "SPELL_PERIODIC_HEAL"
local SPELL_DISPEL = "SPELL_DISPEL"
local SPELL_DISPEL_FAILED = "SPELL_DISPEL_FAILED";
local SWING_MISSED = "SWING_MISSED";
local SWING_DAMAGE = "SWING_DAMAGE"
local SPELL_PERIODIC_DAMAGE = "SPELL_PERIODIC_DAMAGE";
local SPELL_PERIODIC_MISSED = "SPELL_PERIODIC_MISSED";

function Used(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)

    return ns.used:format(GetColor(srcGUID, srcName), GetSpellLink(spellID))
end

function TauntMissed(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)

    return ns.tauntMissed:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName))
end

function Cast(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)

    return ns.cast:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName))
end

function ShadowTrap(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return ns.shadowTrap:format(GetSpellLink(spellID), GetColor(destGUID, destName))
end
function Taunt(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return ns.taunt:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetColor(destGUID, destName))
end

function Feast(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return ns.feast:format(GetColor(srcGUID, srcName), GetSpellLink(spellID))
end

function Dispel(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return ns.dispel:format(GetColor(srcGUID, srcName), GetSpellLink(spellID), GetSpellLink(idScattering),
        GetColor(destGUID, destName))
end

function Create(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return ns.create:format(GetColor(srcGUID, srcName), GetSpellLink(spellID))
end

function DispelFail(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return "DispelFail"
end

function SpiritLady(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    --print(srcGUID, srcName, spellID,destGUID, destName,idScattering)
    return ns.spiritLady:format(GetColor(destGUID, destName))
end

function SoulReaper_APPLIED(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    return ns.soulReaperApplied:format(GetSpellLink(spellID), GetColor(destGUID, destName), idScattering)
end

function SoulReaper_REMOVED(srcGUID, srcName, spellID, destGUID, destName, idScattering)
    return ns.soulReaperRemoved:format(GetSpellLink(spellID), GetColor(destGUID, destName), idScattering)
end

function SoulReaper_SPELL_PERIODIC_MISSED(srcGUID, srcName, spellID, destGUID, destName)
    return ns.soulReaperMissed:format(GetSpellLink(spellID), GetColor(destGUID, destName))
end
function UnitDied(srcGUID, srcName, spellID, destGUID, destName)
    return ns.died:format(GetColor(destGUID, destName))
end
--#region GetColor
function GetColor(guid, name)
    if (ns.NicknameColors[guid] == nil) then
        local _, classFilename = GetPlayerInfoByGUID(tostring(guid))
        local color = ns:GetColor(classFilename)
        ns.NicknameColors[guid] = color .. name .. "|r";
    end

    return ns.NicknameColors[guid];
end

function ns:GetColor(classFilename)
    local color;
    if (classFilename == "DEATHKNIGHT") then
        color = "|cFFC41E3A";
    elseif (classFilename == "WARLOCK") then
        color = "|cFF8788EE";
    elseif (classFilename == "DRUID") then
        color = "|cFFFF7C0A";
    elseif (classFilename == "MAGE") then
        color = "|cFF3FC7EB";
    elseif (classFilename == "HUNTER") then
        color = "|cFFAAD372";
    elseif (classFilename == "PALADIN") then
        color = "|cFFF48CBA";
    elseif (classFilename == "WARRIOR") then
        color = "|cFFC69B6D";
    elseif (classFilename == "ROGUE") then
        color = "|cFFFFF468";
    elseif (classFilename == "SHAMAN") then
        color = "|cFf0070DD";
        -- elseif (classFilename == "PRIEST") then
    else
        color = "|cFFFFFFFF"
    end
    return color;
end

--#endregion

--{id = 0, message = used, event = SPELL_CAST_SUCCESS, print = false, say = false}, --
ns.spellsAll = {
    DEATHKNIGHT = {
        { id = 56222, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Темная власть
        { id = 56222, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Темная власть

        { id = 49576, message = Taunt,       event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Хватка смерти сам каст
        { id = 51399, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Хватка смерти сам каст
        { id = 49576, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Хватка смерти сам каст

        { id = 55233, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Кровь вампира
        { id = 42650, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Войско мертвых
        { id = 48792, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Незыблемость льда
        { id = 48982, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Захват рун
        { id = 70654, message = Used,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  Кровавый доспех
        { id = 47528, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Заморозка разума
        { id = 48707, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Антимагический панцирь
        -- { id = 49560, message = cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Хватка смерти

        { id = 48743, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Смертельный союз
        { id = 49016, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Истерия
        { id = 47476, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Удушение
        { id = 49005, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Кровавая метка
    },
    DRUID = {
        { id = 61336, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Инстинкты выживания
        { id = 22812, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Дубовая кожа

        { id = 48477, message = Used,        event = SPELL_CAST_START,   print = false, say = false },  --  Возрождение
        { id = 48477, message = Cast,        event = SPELL_RESURRECT,    print = false, say = false },  --  Возрождение

        { id = 53227, message = Cast,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  Тайфун
        { id = 53227, message = Cast,        event = SPELL_DAMAGE,       print = false, say = false },  --  Тайфун

        { id = 06795, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Рык
        { id = 06795, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Рык
        { id = 05209, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Вызывающий рев
        { id = 05209, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Вызывающий рев

        { id = 29166, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Озарение
        { id = 70725, message = Used,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  4P T10

        { id = 33786, message = Used,        event = SPELL_CAST_START,   print = false, say = false },  --  конроль
        { id = 33786, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  конроль
        { id = 33786, message = Cast,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  конроль
    },
    HUNTER = {
        { id = 20736, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Отвлекающий выстрел
        { id = 20736, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Отвлекающий выстрел

        { id = 34477, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Перенаправление
        { id = 13809, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ледяная ловушка
        { id = 34600, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Змеиная ловушка
        { id = 19801, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Усмиряющий выстрел
    },
    MAGE = {
        { id = 00066, message = Used,   event = SPELL_CAST_SUCCESS, print = false, say = false },  -- Невидимость
        { id = 45438, message = Used,   event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ледяная глыба
        { id = 02139, message = Cast,   event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Антимагия
        { id = 58659, message = Create, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Стол
    },
    PALADIN = {
        { id = 31790, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Праведная защита пал
        { id = 31789, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Праведная защита каст

        { id = 62124, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Длань возмездия
        { id = 62124, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Длань возмездия

        { id = 01044, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань свободы
        { id = 01038, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань спасения
        { id = 06940, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань жертвенности
        { id = 10278, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань защиты
        { id = 20066, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Покаяние
        { id = 48817, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Гнев небес
        { id = 10308, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Молот правосудия

        { id = 66233, message = Used,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  Ревностный защитник

        -- do do ammount
        -- { id = 66235, message = gs, event =  SPELL_HEAL, print = false, say = false }, --  Ревностный защитник

        { id = 31821, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Мастер аур
        { id = 31884, message = Used,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  крылья
        { id = 00498, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  50 на 50
        { id = 00642, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  бабл
        { id = 64205, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  масс сакра
        { id = 19752, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  диван
        { id = 54428, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Святая клятва
        { id = 20233, message = Cast,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  Возложение рук
        { id = 20236, message = Cast,        event = SPELL_AURA_APPLIED, print = false, say = false },  --  Возложение рук
    },
    PRIEST = {
        --hill
        -- { id = 48153, message = reborn , event =  SPELL_HEAL, print = false, say = false }, --  Оберегающий дух
        { id = 47788, message = Cast, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Оберегающий дух
        { id = 06346, message = Cast, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Защита от страха
        { id = 33206, message = Cast, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Подавление боли
        { id = 64901, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Гимн надежды
        { id = 64843, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Божественный гимн
    },
    ROGUE = {
        { id = 51722, message = Cast, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Долой оружие
        { id = 57934, message = Cast, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Маленькие хитрости
        { id = 31224, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Плащ Теней
    },
    SHAMAN = {
        { id = 02825, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Жажда крови
        { id = 32182, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Героизм
        { id = 16190, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Тотем прилива маны
        { id = 21169, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Перерождение
        { id = 58857, message = Taunt, event = SPELL_AURA_APPLIED, print = false, say = false },  --  Многоголосый вой
    },
    WARLOCK = {
        { id = 58887, message = Create, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ритуал душ
        { id = 00698, message = Create, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ритуал призыва
    },
    WARRIOR = {
        { id = 00355, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Провокация
        { id = 00355, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  Провокация

        { id = 00694, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  дразнящий удар
        { id = 00694, message = TauntMissed, event = SPELL_MISSED,       print = false, say = false },  --  дразнящий удар
        { id = 01161, message = Taunt,       event = SPELL_AURA_APPLIED, print = false, say = false },  --  Вызывающий крик -- таунт

        { id = 07386, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Раскол брони
        { id = 06552, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Зуботычина
        { id = 00676, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Разоружение
        { id = 12809, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Оглушающий удар
        { id = 03411, message = Cast,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Вмешательство
        { id = 12975, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ни шагу назад
        { id = 12976, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ни шагу назад
        { id = 00871, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Глухая оборона
        { id = 70845, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Стоицизм т10
        { id = 02565, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Блок щитом
        { id = 05246, message = Used,        event = SPELL_CAST_SUCCESS, print = false, say = false },  --  устрашающий-крик
    },

    Engineering = {
        { id = 54861, message = Used,   event = SPELL_AURA_APPLIED, print = false, say = false },
        { id = 22700, message = Create, event = SPELL_CREATE,       print = false, say = false },
        { id = 44389, message = Create, event = SPELL_CREATE,       print = false, say = false },
        { id = 67826, message = Create, event = SPELL_CREATE,       print = false, say = false },
        { id = 54710, message = Create, event = SPELL_CREATE,       print = false, say = false },
        { id = 54711, message = Create, event = SPELL_CREATE,       print = false, say = false },
    },
    Accessories = {
        { id = 71638, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  Клык
        { id = 71635, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  клык
        { id = 71586, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  ключ
        { id = 67699, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  скарабей танк
        { id = 67753, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  скарабей танк
        { id = 26467, message = Used, event = SPELL_CAST_SUCCESS, print = false, say = false },  --  скарабей хил
    },
    MagicPortals = {
        { id = 53142, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Даларан
        { id = 11419, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Дарнас
        { id = 32266, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Экзодар
        { id = 11416, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Стальгорн
        { id = 11417, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Огри
        { id = 33691, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Шатрат
        { id = 32267, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Луносвет
        { id = 35717, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Шатрат
        { id = 49361, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Каменор
        { id = 10059, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Шторм
        { id = 49360, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Терамор
        { id = 11420, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Громовой утес
        { id = 11418, message = Create, event = SPELL_CREATE, print = false, say = false },  --  Подгород
    },
    Food = {
        { id = 57426, message = Feast, event = SPELL_CREATE, print = false, say = false },  --  Рыбный пир
        { id = 57301, message = Feast, event = SPELL_CREATE, print = false, say = false },  --  "Пир на весь мир"
        { id = 66476, message = Feast, event = SPELL_CREATE, print = false, say = false },  --  Богатый пир
    },
    ICC25HM = {
        -- { id = 69409, message = used, event = SPELL_CAST_SUCCESS, print = false, say = false }, -- 10 об

        { id = 69409, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  -- 10 об
        { id = 69409, message = SoulReaper_APPLIED,               event = SPELL_DAMAGE,          print = false, say = false },
        { id = 69409, message = SoulReaper_REMOVED,               event = SPELL_PERIODIC_DAMAGE, print = false, say = false },
        { id = 69409, message = SoulReaper_SPELL_PERIODIC_MISSED, event = SPELL_PERIODIC_MISSED, print = false, say = false },

        { id = 73797, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  жнец душ  --25 об
        { id = 73797, message = SoulReaper_APPLIED,               event = SPELL_DAMAGE,          print = false, say = false },
        { id = 73797, message = SoulReaper_REMOVED,               event = SPELL_PERIODIC_DAMAGE, print = false, say = false },
        { id = 73797, message = SoulReaper_SPELL_PERIODIC_MISSED, event = SPELL_PERIODIC_MISSED, print = false, say = false },

        { id = 73798, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  жнец душ  --10 хм
        { id = 73798, message = SoulReaper_APPLIED,               event = SPELL_DAMAGE,          print = false, say = false },
        { id = 73798, message = SoulReaper_REMOVED,               event = SPELL_PERIODIC_DAMAGE, print = false, say = false },
        { id = 73798, message = SoulReaper_SPELL_PERIODIC_MISSED, event = SPELL_PERIODIC_MISSED, print = false, say = false },

        { id = 73799, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  жнец душ  --25 хм
        { id = 73799, message = SoulReaper_APPLIED,               event = SPELL_DAMAGE,          print = false, say = false },
        { id = 73799, message = SoulReaper_REMOVED,               event = SPELL_PERIODIC_DAMAGE, print = false, say = false },
        { id = 73799, message = SoulReaper_SPELL_PERIODIC_MISSED, event = SPELL_PERIODIC_MISSED, print = false, say = false },

        { id = 71726, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира
        { id = 71729, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- босс в 25 хм
        { id = 71727, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- босс в 24 об
        { id = 71728, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- босс в 10 хм
        { id = 71475, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- игрок на игрока в 25 об
        { id = 71476, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- игрок на игрока в 10 хм + 10 об босс на игрока
        { id = 71477, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- игрок на игрока в 25 хм
        { id = 70946, message = Used,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  укус вампира  -- 10 об игрок на игрока
        { id = 72148, message = Used,                             event = SPELL_AURA_APPLIED,    print = false, say = false },  --  Исступление на шарке 25 героик
        { id = 28747, message = Used,                             event = SPELL_AURA_APPLIED,    print = false, say = false },  --  Бешенство на шарке 25 героик
        { id = 71289, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  леди контроль
        { id = 71264, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  Роящиеся тени
        { id = 73914, message = Cast,                             event = SPELL_CAST_SUCCESS,    print = false, say = false },  --  чума

        { id = 73529, message = ShadowTrap,                       event = SPELL_DAMAGE,          print = false, say = false },  --  ловушка 25 гер
        { id = 73775, message = ShadowTrap,                       event = SPELL_DAMAGE,          print = false, say = false },  --  ледяная сфера 25 гер
        { id = 73775, message = UnitDied,                         event = UNIT_DIED,             print = false, say = false },  --  смерть
        { id = 99999,    message = UnitDied,                         event = UNIT_DIED,             print = false, say = false },  --  смерть
    },
    DISPELS = {
        { id = 02782, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Снятие проклятия"
        { id = 00526, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Оздоровление"
        { id = 04987, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Очищение"
        { id = 51886, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Очищение духа"
        { id = 32375, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Массовое рассеивание"
        { id = 32592, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Массовое рассеивание"
        { id = 00988, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Рассеивание заклинаний"
        { id = 00552, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Устранение болезни"
        { id = 48011, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Пожирание магии"
        { id = 00528, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Излечение болезни"
        { id = 00475, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Снятие проклятия"
        { id = 10872, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Эффект устранения болезни"
        { id = 02893, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Устранение яда"
        { id = 03137, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Эффект устранения яда"
        { id = 01152, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Омовение"
        { id = 57767, message = Dispel,     event = SPELL_DISPEL,        print = false, say = false },  --  "Очищение"

        { id = 59752, message = Used,       event = SPELL_CAST_SUCCESS,  print = false, say = false },  --  "Каждый за себя"

        { id = 02782, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Снятие проклятия"
        { id = 00526, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Оздоровление"
        { id = 04987, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Очищение"
        { id = 51886, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Очищение духа"
        { id = 32375, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Массовое рассеивание"
        { id = 32592, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Массовое рассеивание"
        { id = 00988, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Рассеивание заклинаний"
        { id = 00552, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Устранение болезни"
        { id = 48011, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Пожирание магии"
        { id = 00528, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Излечение болезни"
        { id = 00475, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Снятие проклятия"
        { id = 10872, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Эффект устранения болезни"
        { id = 02893, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Устранение яда"
        { id = 03137, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Эффект устранения яда"
        { id = 01152, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Омовение"
        { id = 57767, message = DispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false },  --  "Очищение"
    }
}


ns.NamedCategories = {
    { "DEATHKNIGHT",  ns.L["DEATHKNIGHT"] },
    { "DRUID",        ns.L["DRUID"] },
    { "PALADIN",      ns.L["PALADIN"] },
    { "HUNTER",       ns.L["HUNTER"] },
    { "MAGE",         ns.L["MAGE"] },
    { "PRIEST",       ns.L["PRIEST"] },
    { "ROGUE",        ns.L["ROGUE"] },
    { "SHAMAN",       ns.L["SHAMAN"] },
    { "WARLOCK",      ns.L["WARLOCK"] },
    { "WARRIOR",      ns.L["WARRIOR"] },
    { "DISPELS",      ns.L["DISPELS"] },
    { "Engineering",  ns.L["Engineering"] },
    { "Accessories",  ns.L["Accessories"] },
    { "MagicPortals", ns.L["MagicPortals"] },
    { "Food",         ns.L["Food"] },
    { "ICC25HM",      ns.L["ICC25HM"] },
}

-- setting the name depending on the culture
for i = 1, #ns.NamedCategories do
    local arr = ns.spellsAll[ns.NamedCategories[i][1]]
    for j = 1, #arr do
        local name = ns:GetSpellInfo_local(arr[j].id)
        arr[j].name = name;
    end
end
