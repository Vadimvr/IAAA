local AddOnName, ns = ...;

local HEROISM       = UnitFactionGroup("player") == "Horde" and 2825 or 32182 -- Героизм\жажда крови
local REBIRTH       = GetSpellInfo(20484)                                     -- Возрождение
local HOP           = GetSpellInfo(1022)                                      -- Длань защиты
local SOUL_STONE    = GetSpellInfo(20707)                                     -- Воскрешение камнем души
local CABLES        = GetSpellInfo(54732)                                     -- Гномий дефибриллятор

--#region old

ns.dispels          = {
    [2782] = true,  -- "Снятие проклятия"
    [526] = true,   -- "Оздоровление"
    [4987] = true,  -- "Очищение"
    [51886] = true, -- "Очищение духа"
    [32375] = true, -- "Массовое рассеивание"
    [32592] = true, -- "Массовое рассеивание"
    [988] = true,   -- "Рассеивание заклинаний"
    [552] = true,   -- "Устранение болезни"
    [48011] = true, -- "Пожирание магии"
    [528] = true,   -- "Излечение болезни"
    --[19801] = true, -- "Усмиряющий выстрел"
    [475] = true,   -- "Снятие проклятия"
    [10872] = true, -- "Эффект устранения болезни"
    [2893] = true,  -- "Устранение яда"
    [3137] = true,  -- "Эффект устранения яда"
    [1152] = true,  -- "Омовение"
    [57767] = true, -- "Очищение"
}




-- ритуалы

ns.rituals = {
    -- Маг
    [58659] = true, -- Обряд сотворения яств
    -- Лок
    [58887] = true, -- Ритуал душ
    [698] = true,   -- Ритуал призыва
}

ns.icc     = {
    [69409] = true, -- жнец душ 10 об
    [73797] = true, -- жнец душ 25 об
    [73798] = true, -- жнец душ 10 хм
    [73799] = true, -- жнец душ 25 hm
    [71726] = true, -- укус вампира
    [71729] = true, -- укус вампира
    [71727] = true, -- укус вампира
    [71728] = true, -- укус вампира
    [71475] = true, -- укус вампира
    [71476] = true, -- укус вампира
    [71477] = true, -- укус вампира
    [70946] = true, -- укус вампира
    [73914] = true, -- чума
}
-- спелы применяемые на членов рейда
ns.spells  = {
    -- Паладин
    [6940]  = false, -- Длань жертвенности
    [20233] = false, -- Возложение рук
    [20236] = false, -- Возложение рук
    [1044]  = false, -- Длань свободы
    [1038]  = false, -- Длань спасения
    [10278] = false, -- Длань защиты
    [19752] = false, -- Божественное вмешательство
    -- Priest
    [47788] = false, -- Оберегающий дух
    [33206] = false, -- Подавление боли
    [6346]  = false, -- Защита от страха
    -- Hunter
    [34477] = false, -- Перенаправление
    [19801] = false, -- Усмиряющий выстрел
    [20736] = false, -- Отвлекающий выстрел
    -- рога
    [51722] = false, -- Долой оружие
    [57934] = false, -- Маленькие хитрости
    -- дк
    [49016] = false, -- Истерия
    [47528] = false, -- сбить каст
    [47476] = false, -- [Удушение]
    [49005] = false, -- [Кровавая метка]
    -- вар
    [676]   = false, -- Disarm
    [6552]  = false, -- [Зуботычина]
    [3411]  = false, -- [Вмешательство]
    [7386]  = false, -- раскол
    -- маг
    [2139]  = false, -- [Антимагия]
    [475]   = false, -- [Снятие проклятия]
    --друид
    [29166] = false, --Озарение
    [48477] = true,  -- br
}

-- aura applied
ns.taunts  = {
    -- дк
    [56222] = false, -- темная власть дк
    [49560] = false, -- хватка смерти дк
    [49576] = false, -- хватка смерти
    --вар
    [12809] = false, -- [Оглушающий удар]
    [355] = false,   -- Провокация вар
    [694] = false,   -- Дразнящий удар вар
    [1161] = false,  -- [Вызывающий крик] -- таунт
    [6552] = false,  -- [Зуботычина]
    -- пал
    [62124] = false, -- 	Длань возмездия пал
    [31790] = false, -- Праведная защита пал
    [31789] = false, -- [Праведная защита] каст
    [20066] = false, -- [Покаяние]
    [70940] = false, -- [Божественный страж]
    [10308] = false, -- [Молот правосудия]
    -- дру
    [6795] = false,  -- [Рык]
    [5209] = false,  -- [Вызывающий рев]
    [53227] = false, -- [Тайфун]
    [33786] = false, -- смерч
    -- хант
    [20736] = false, -- [Отвлекающий выстрел]
    [20736] = false, -- [Отвлекающий выстрел]
    [20233] = false,
    [20236] = false,
    [10278] = false,
    [71289] = false, -- леди  контроль
}


ns.bots = {
    [22700] = true,
    [44389] = true,
    [67826] = true,
    [54710] = true,
    [54711] = true,
    [54861] = true,
}

-- использование на себя
ns.use = {
    [72148] = false, -- Исступление на шарке 25 героик
    [28747] = false, -- Бешенство на шарке 25 героик
    -- ДК
    [48982] = false, -- захват рун
    [48707] = false, -- Антимагический панцирь
    [48792] = false, -- Незыблемость льда
    [55233] = false, -- Кровь вампира
    [42650] = false, -- бомжи
    [48743] = false, -- [Смертельный союз]
    -- Друид
    [22812] = false, -- Дубовая кожа
    --[22842] = false,	-- Неистовое восстановление
    [61336] = false, -- Инстинкты выживания
    -- Паладин
    [498]   = false, -- Диван
    [48817] = false, -- [Гнев небес]
    [64205] = true,  -- масс сакра
    [31821] = false, -- Мастер аур
    [54428] = false, -- святая клятва
    [31884] = false, -- гнев карателя
    -- Воин
    [12975] = false, -- Ни шагу назад
    [12976] = false, -- ни шагу назад спадение
    [871]   = false, -- глухая оборона
    [5246]  = false, -- фир
    [2565]  = false, -- [Блок щитом]
    -- Маг
    [45438] = false, -- Ледяная глыба
    -- Trinkets
    [71638] = false, -- Клык
    -- Priest
    [64843] = false, -- Божественный гимн
    [64901] = false, -- [Гимн надежды]
    -- Чмо
    [31224] = false, -- [Плащ Теней]
    -- хант
    [13809] = false, -- [Ледяная ловушка]
    [34600] = false, -- [Змеиная ловушка]
    [23989] = false, -- [Готовность]
    -- шама
    [2825]  = false, -- [Жажда крови]
    [32182] = false, -- gera
    [21169] = false, -- [Перерождение]
    [16190] = false, -- [Тотем прилива маны]
}

-- бонусы от комплектов
ns.bonus = {
    -- ДК
    [70654] = false, -- [4P T10]
    -- Друид
    [70725] = false, -- [4P T10]
    --маг
    [66] = false,    -- [Невидимость]
    -- пал
    [642] = false,   -- бабл
    -- Шарк в цлк
    [72148] = false, -- Исступление на шарке 25 героик
    [28747] = false, -- Бешенство на шарке 25 героик
}

-- Еда
ns.feasts = {
    [57426] = false, -- Рыбный пир
    [57301] = false, -- "Пир на весь мир"
    [66476] = false, -- Богатый пир
}

--  порталы магов
ns.port = {
    [53142] = false, -- Даларан
    [11419] = false, -- Дарнас
    [32266] = false, -- Экзодар
    [11416] = false, -- Стальгорн
    [11417] = false, -- Огри
    [33691] = false, -- Шатрат
    [35717] = false, -- Шатрат
    [32267] = false, -- Луносвет
    [49361] = false, -- Каменор
    [10059] = false, -- Шторм
    [49360] = false, -- Терамор
    [11420] = false, -- Громовой утес
    [11418] = false, -- Подгород
}

ns.reborn = {
    [48153] = true, -- ангел у жреца
    [66233] = true, -- прокладка у пала
    [66235] = true, -- прокладка у пала
}
--#endregion


--{id = 0, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false}, --
ns.spellsNew1 = {
    DEATHKNIGHT = {
        { id = 56222, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Темная власть
        { id = 55233, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Кровь вампира
        { id = 42650, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Войско мертвых
        { id = 48792, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Незыблемость льда
        { id = 48982, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Захват рун
        { id = 70654, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Кровавый доспех
        { id = 47528, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Заморозка разума
        { id = 48707, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Антимагический панцирь
        { id = 49560, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Хватка смерти
        { id = 49576, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Хватка смерти сам каст
        { id = 48743, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Смертельный союз
        { id = 49016, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Истерия
        { id = 47476, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Удушение
        { id = 49005, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Кровавая метка
    },
    DRUID = {
        { id = 61336, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Инстинкты выживания
        { id = 22812, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Дубовая кожа
        { id = 48477, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Возрождение
        { id = 53227, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Тайфун
        { id = 06795, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Рык
        { id = 05209, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Вызывающий рев
        { id = 29166, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Озарение
        { id = 70725, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  4P T10
        { id = 33786, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  конроль
    },
    HUNTER = {
        { id = 34477, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Перенаправление
        { id = 13809, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Ледяная ловушка
        { id = 19801, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Усмиряющий выстрел
        { id = 20736, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Отвлекающий выстрел
        { id = 34600, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Змеиная ловушка
    },
    MAGE = {
        { id = 00066, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },   -- Невидимость
        { id = 45438, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },   --  Ледяная глыба
        { id = 02139, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },   --  Антимагия
        { id = 58659, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },   --  Стол
    },
    PALADIN = {
        { id = 31790, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Праведная защита пал
        { id = 62124, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань возмездия
        { id = 01044, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань свободы
        { id = 01038, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань спасения
        { id = 06940, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань жертвенности
        { id = 10278, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Длань защиты
        { id = 20066, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Покаяние
        { id = 48817, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Гнев небес
        { id = 10308, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Молот правосудия
        { id = 66233, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ревностный защитник
        { id = 66235, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ревностный защитник
        { id = 31789, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Праведная защита каст
        { id = 31821, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Мастер аур
        { id = 31884, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  крылья
        { id = 00498, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  50 на 50
        { id = 00642, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  бабл
        { id = 64205, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  масс сакра
        { id = 19752, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  диван
        { id = 54428, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Святая клятва
        { id = 20233, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Возложение рук
        { id = 20236, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Возложение рук
        { id = 31884, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  крылья
    },
    PRIEST = {
        { id = 48153, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Оберегающий дух
        { id = 47788, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Оберегающий дух
        { id = 06346, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Защита от страха
        { id = 33206, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Подавление боли
        { id = 64901, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Гимн надежды
        { id = 64843, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Божественный гимн
    },
    ROGUE = {
        { id = 51722, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Долой оружие
        { id = 57934, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Маленькие хитрости
        { id = 31224, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Плащ Теней
    },
    SHAMAN = {
        { id = 02825, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Жажда крови
        { id = 32182, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Героизм
        { id = 16190, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Тотем прилива маны
        { id = 21169, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Перерождение
    },
    WARLOCK = {
        { id = 58887, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ритуал душ
        { id = 00698, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ритуал призыва
    },
    WARRIOR = {
        { id = 00355, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Провокация
        { id = 00694, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  дразнящий удар
        { id = 01161, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Вызывающий крик -- таунт
        { id = 07386, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Раскол брони
        { id = 06552, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Зуботычина
        { id = 00676, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Разоружение
        { id = 12809, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Оглушающий удар
        { id = 03411, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Вмешательство
        { id = 12975, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ни шагу назад
        { id = 12976, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Ни шагу назад
        { id = 00871, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Глухая оборона
        { id = 70845, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Стоицизм т10
        { id = 02565, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  Блок щитом
        { id = 05246, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  устрашающий-крик
    },

    Engineering = {
        { id = 54861, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },
        { id = 22700, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },
        { id = 44389, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },
        { id = 67826, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },
        { id = 54710, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },
        { id = 54711, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },
    },
    Accessories = {
        { id = 71638, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Клык
        { id = 71635, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  клык
        { id = 71586, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  ключ
    },
    MagicPortals = {
        { id = 53142, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Даларан
        { id = 11419, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Дарнас
        { id = 32266, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Экзодар
        { id = 11416, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Стальгорн
        { id = 11417, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Огри
        { id = 33691, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Шатрат
        { id = 35717, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Шатрат
        { id = 32267, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Луносвет
        { id = 49361, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Каменор
        { id = 10059, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Шторм
        { id = 49360, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Терамор
        { id = 11420, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Громовой утес
        { id = 11418, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Подгород
    },
    Food = {
        { id = 57426, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Рыбный пир
        { id = 57301, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  "Пир на весь мир"
        { id = 66476, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Богатый пир
    },
    ICC25HM = {
        { id = 69409, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, -- 10 об
        { id = 73797, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  жнец душ  25 об
        { id = 73798, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  жнец душ  10 хм
        { id = 73799, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  жнец душ  --25 хм
        { id = 71726, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира
        { id = 71729, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- босс в 25 хм
        { id = 71727, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- босс в 24 об
        { id = 71728, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- босс в 10 хм
        { id = 71475, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- игрок на игрока в 25 об
        { id = 71476, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- игрок на игрока в 10 хм + 10 об босс на игрока
        { id = 71477, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- игрок на игрока в 25 хм
        { id = 70946, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  укус вампира  -- 10 об игрок на игрока
        { id = 72148, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Исступление на шарке 25 героик
        { id = 28747, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Бешенство на шарке 25 героик
        { id = 71289, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  леди контроль
        { id = 71264, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  Роящиеся тени
        { id = 73914, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false }, --  чума
    },
    DISPELS = {
        { id = 02782, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Снятие проклятия"
        { id = 00526, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Оздоровление"
        { id = 04987, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Очищение"
        { id = 51886, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Очищение духа"
        { id = 32375, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Массовое рассеивание"
        { id = 32592, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Массовое рассеивание"
        { id = 00988, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Рассеивание заклинаний"
        { id = 00552, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Устранение болезни"
        { id = 48011, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Пожирание магии"
        { id = 00528, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Излечение болезни"
        { id = 00475, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Снятие проклятия"
        { id = 10872, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Эффект устранения болезни"
        { id = 02893, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Устранение яда"
        { id = 03137, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Эффект устранения яда"
        { id = 01152, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Омовение"
        { id = 57767, mes = ns.used, e = SPELL_CAST_SUCCESS, print = false, say = false },  --  "Очищение"
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
