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
local SPELL_DISPEL_FAILED = "SPELL_DISPEL_FAILED"

--{id = 0, message = ns.used, event =SPELL_CAST_SUCCESS, print = false, say = false}, --
ns.spellsAll = {
    DEATHKNIGHT = {
        { id = 56222, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Темная власть
        { id = 56222, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Темная власть

        { id = 55233, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Кровь вампира
        { id = 42650, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Войско мертвых
        { id = 48792, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Незыблемость льда
        { id = 48982, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Захват рун
        { id = 70654, message = ns.used,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  Кровавый доспех
        { id = 47528, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Заморозка разума
        { id = 48707, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Антимагический панцирь
        -- { id = 49560, message = ns.cast, event =SPELL_CAST_SUCCESS, print = false, say = false }, --  Хватка смерти
        { id = 49576, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Хватка смерти сам каст
        { id = 49576, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Хватка смерти сам каст
        { id = 48743, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Смертельный союз
        { id = 49016, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Истерия
        { id = 47476, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Удушение
        { id = 49005, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Кровавая метка
    },
    DRUID = {
        { id = 61336, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Инстинкты выживания
        { id = 22812, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Дубовая кожа

        { id = 48477, message = ns.used,        event = SPELL_CAST_START,   print = false, say = false }, --  Возрождение
        { id = 48477, message = ns.cast,        event = SPELL_RESURRECT,    print = false, say = false }, --  Возрождение

        { id = 53227, message = ns.cast,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  Тайфун
        { id = 53227, message = ns.cast,        event = SPELL_DAMAGE,       print = false, say = false }, --  Тайфун

        { id = 06795, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Рык
        { id = 06795, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Рык
        { id = 05209, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Вызывающий рев
        { id = 05209, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Вызывающий рев

        { id = 29166, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Озарение
        { id = 70725, message = ns.used,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  4P T10

        { id = 33786, message = ns.used,        event = SPELL_CAST_START,   print = false, say = false }, --  конроль
        { id = 33786, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  конроль
        { id = 33786, message = ns.cast,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  конроль
    },
    HUNTER = {
        { id = 20736, message = ns.taunt,       event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Отвлекающий выстрел
        { id = 20736, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Отвлекающий выстрел
        { id = 34477, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Перенаправление
        { id = 13809, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ледяная ловушка
        { id = 34600, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Змеиная ловушка
        { id = 19801, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Усмиряющий выстрел
    },
    MAGE = {
        { id = 00066, message = ns.used,   event = SPELL_CAST_SUCCESS, print = false, say = false }, -- Невидимость
        { id = 45438, message = ns.used,   event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ледяная глыба
        { id = 02139, message = ns.cast,   event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Антимагия
        { id = 58659, message = ns.create, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Стол
    },
    PALADIN = {
        { id = 31790, message = ns.taunt,       event = SPELL_AURA_APPLIED, print = false, say = false }, --  Праведная защита пал
        { id = 31789, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Праведная защита каст
        { id = 31789, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Праведная защита каст

        { id = 62124, message = ns.taunt,       event = SPELL_AURA_APPLIED, print = false, say = false }, --  Длань возмездия
        { id = 62124, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Длань возмездия

        { id = 01044, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Длань свободы
        { id = 01038, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Длань спасения
        { id = 06940, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Длань жертвенности
        { id = 10278, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Длань защиты
        { id = 20066, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Покаяние
        { id = 48817, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Гнев небес
        { id = 10308, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Молот правосудия

        { id = 66233, message = ns.used,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  Ревностный защитник

        -- do do ammount
        -- { id = 66235, message = ns.gs,        event = SPELL_HEAL, print = false, say = false }, --  Ревностный защитник

        { id = 31821, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Мастер аур
        { id = 31884, message = ns.used,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  крылья
        { id = 00498, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  50 на 50
        { id = 00642, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  бабл
        { id = 64205, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  масс сакра
        { id = 19752, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  диван
        { id = 54428, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Святая клятва
        { id = 20233, message = ns.cast,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  Возложение рук
        { id = 20236, message = ns.cast,        event = SPELL_AURA_APPLIED, print = false, say = false }, --  Возложение рук
    },
    PRIEST = {
        --hill
        -- { id = 48153, message = ns.reborn , event = SPELL_HEAL, print = false, say = false }, --  Оберегающий дух
        { id = 47788, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Оберегающий дух
        { id = 06346, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Защита от страха
        { id = 33206, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Подавление боли
        { id = 64901, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Гимн надежды
        { id = 64843, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Божественный гимн
    },
    ROGUE = {
        { id = 51722, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Долой оружие
        { id = 57934, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Маленькие хитрости
        { id = 31224, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Плащ Теней
    },
    SHAMAN = {
        { id = 02825, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Жажда крови
        { id = 32182, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Героизм
        { id = 16190, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Тотем прилива маны
        { id = 21169, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Перерождение
    },
    WARLOCK = {
        { id = 58887, message = ns.create, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ритуал душ
        { id = 00698, message = ns.create, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ритуал призыва
    },
    WARRIOR = {
        { id = 00355, message = ns.taunt,       event = SPELL_AURA_APPLIED, print = false, say = false }, --  Провокация
        { id = 00355, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  Провокация
        { id = 00694, message = ns.taunt,       event = SPELL_AURA_APPLIED, print = false, say = false }, --  дразнящий удар
        { id = 00694, message = ns.tauntMissed, event = SPELL_MISSED,       print = false, say = false }, --  дразнящий удар
        { id = 01161, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Вызывающий крик -- таунт

        { id = 07386, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Раскол брони
        { id = 06552, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Зуботычина
        { id = 00676, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Разоружение
        { id = 12809, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Оглушающий удар
        { id = 03411, message = ns.cast,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Вмешательство
        { id = 12975, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ни шагу назад
        { id = 12976, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ни шагу назад
        { id = 00871, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Глухая оборона
        { id = 70845, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Стоицизм т10
        { id = 02565, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Блок щитом
        { id = 05246, message = ns.used,        event = SPELL_CAST_SUCCESS, print = false, say = false }, --  устрашающий-крик
    },

    Engineering = {
        { id = 54861, message = ns.used,   event = SPELL_AURA_APPLIED, print = false, say = false },
        { id = 22700, message = ns.create, event = SPELL_CREATE,       print = false, say = false },
        { id = 44389, message = ns.create, event = SPELL_CREATE,       print = false, say = false },
        { id = 67826, message = ns.create, event = SPELL_CREATE,       print = false, say = false },
        { id = 54710, message = ns.create, event = SPELL_CREATE,       print = false, say = false },
        { id = 54711, message = ns.create, event = SPELL_CREATE,       print = false, say = false },
    },
    Accessories = {
        { id = 71638, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Клык
        { id = 71635, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  клык
        { id = 71586, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  ключ
    },
    MagicPortals = {
        { id = 53142, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Даларан
        { id = 11419, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Дарнас
        { id = 32266, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Экзодар
        { id = 11416, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Стальгорн
        { id = 11417, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Огри
        { id = 33691, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Шатрат
        { id = 32267, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Луносвет
        { id = 35717, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Шатрат
        { id = 49361, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Каменор
        { id = 10059, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Шторм
        { id = 49360, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Терамор
        { id = 11420, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Громовой утес
        { id = 11418, message = ns.create, event = SPELL_CREATE, print = false, say = false }, --  Подгород
    },
    Food = {
        { id = 57426, message = ns.feast, event = SPELL_CREATE, print = false, say = false }, --  Рыбный пир
        { id = 57301, message = ns.feast, event = SPELL_CREATE, print = false, say = false }, --  "Пир на весь мир"
        { id = 66476, message = ns.feast, event = SPELL_CREATE, print = false, say = false }, --  Богатый пир
    },
    ICC25HM = {
        --{ id = 69409, message = ns.used, event =SPELL_CAST_SUCCESS, print = false, say = false }, -- 10 об
        { id = 73797, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  жнец душ  25 об
        { id = 73798, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  жнец душ  10 хм
        { id = 73799, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  жнец душ  --25 хм
        { id = 71726, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира
        { id = 71729, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- босс в 25 хм
        { id = 71727, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- босс в 24 об
        { id = 71728, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- босс в 10 хм
        { id = 71475, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- игрок на игрока в 25 об
        { id = 71476, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- игрок на игрока в 10 хм + 10 об босс на игрока
        { id = 71477, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- игрок на игрока в 25 хм
        { id = 70946, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- 10 об игрок на игрока
        { id = 72148, message = ns.used, event = SPELL_AURA_APPLIED, print = false, say = false }, --  Исступление на шарке 25 героик
        { id = 28747, message = ns.used, event = SPELL_AURA_APPLIED, print = false, say = false }, --  Бешенство на шарке 25 героик
        { id = 71289, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  леди контроль
        { id = 71264, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  Роящиеся тени
        { id = 73914, message = ns.cast, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  чума
    },
    DISPELS = {
        { id = 02782, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Снятие проклятия"
        { id = 00526, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Оздоровление"
        { id = 04987, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Очищение"
        { id = 51886, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Очищение духа"
        { id = 32375, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Массовое рассеивание"
        { id = 32592, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Массовое рассеивание"
        { id = 00988, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Рассеивание заклинаний"
        { id = 00552, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Устранение болезни"
        { id = 48011, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Пожирание магии"
        { id = 00528, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Излечение болезни"
        { id = 00475, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Снятие проклятия"
        { id = 10872, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Эффект устранения болезни"
        { id = 02893, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Устранение яда"
        { id = 03137, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Эффект устранения яда"
        { id = 01152, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Омовение"
        { id = 57767, message = ns.dispel, event = SPELL_DISPEL, print = false, say = false }, --  "Очищение"

        { id = 59752, message = ns.used, event = SPELL_CAST_SUCCESS, print = false, say = false }, --  "Каждый за себя"

        { id = 02782, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Снятие проклятия"
        { id = 00526, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Оздоровление"
        { id = 04987, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Очищение"
        { id = 51886, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Очищение духа"
        { id = 32375, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Массовое рассеивание"
        { id = 32592, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Массовое рассеивание"
        { id = 00988, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Рассеивание заклинаний"
        { id = 00552, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Устранение болезни"
        { id = 48011, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Пожирание магии"
        { id = 00528, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Излечение болезни"
        { id = 00475, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Снятие проклятия"
        { id = 10872, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Эффект устранения болезни"
        { id = 02893, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Устранение яда"
        { id = 03137, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Эффект устранения яда"
        { id = 01152, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Омовение"
        { id = 57767, message = ns.dispelFail, event = SPELL_DISPEL_FAILED, print = false, say = false }, --  "Очищение"
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
        local name, rank = GetSpellInfo(arr[j].id)
        arr[j].name = name;
    end
end
