local AddOnName, ns = ...;

local HEROISM	= UnitFactionGroup("player") == "Horde" and 2825 or 32182	-- Героизм\жажда крови
local REBIRTH 	= GetSpellInfo(20484)										-- Возрождение
local HOP 		= GetSpellInfo(1022)										-- Длань защиты
local SOUL_STONE = GetSpellInfo(20707)										-- Воскрешение камнем души
local CABLES	= GetSpellInfo(54732)										-- Гномий дефибриллятор 


ns.dispels={
    [2782] = true,   -- "Снятие проклятия"
    [526] = true,    -- "Оздоровление"
    [4987] = true,   -- "Очищение"
    [51886] = true,  -- "Очищение духа"
    [32375] = true,  -- "Массовое рассеивание"
    [32592] = true,  -- "Массовое рассеивание"
    [988] = true,    -- "Рассеивание заклинаний"
    [552] = true,    -- "Устранение болезни"
    [48011] = true,  -- "Пожирание магии"
    [528] = true,    -- "Излечение болезни"
    [19801] = true,  -- "Усмиряющий выстрел"
    [475] = true,    -- "Снятие проклятия"
    [10872] = true,  -- "Эффект устранения болезни"
    [2893] = true,   -- "Устранение яда"
    [3137] = true,   -- "Эффект устранения яда"
    [1152] = true,   -- "Омовение"
    [57767] = true,  -- "Очищение"
}



-- ритуалы

ns.rituals  = {
	-- Маг
	[58659] = true, -- Обряд сотворения яств
	-- Лок
	[58887] = true, -- Ритуал душ
	[698]	= true, -- Ритуал призыва
}

ns.icc = {
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
}
-- спелы применяемые на членов рейда
ns.spells = {
   
	-- Паладин
	[6940] 	= false, -- Длань жертвенности
	[20233] = false, -- Возложение рук
	[20236] = false, -- Возложение рук
	[1044] = false,  -- Длань свободы
	[1038] = false,  -- Длань спасения
	[10278] = false, -- Длань защиты
    [19752] = false, -- Божественное вмешательство
	-- Priest
	[47788] = false, -- Оберегающий дух
	[33206] = false, -- Подавление боли
	[6346] = false,  -- Защита от страха
	-- Hunter
	[34477] = false, -- Перенаправление
	[19801] = false, -- Усмиряющий выстрел
	[20736] = false, -- Отвлекающий выстрел
	-- рога
	[51722] = false, -- Долой оружие
	[57934] = false, -- Маленькие хитрости

	-- дк
	[49016] = false, -- Истерия
    [47528] =false,  -- сбить каст
    [47476] =false,  -- [Удушение]
    [49005] =false,  -- [Кровавая метка]

	-- вар
	[676] = false, -- Disarm
    [6552] =false, -- [Зуботычина]
    [3411] =false, -- [Вмешательство]
    
    -- маг 
    [2139] =false, -- [Антимагия]
    [475] =false, -- [Снятие проклятия]

	--друид 
	[29166] = false, --Озарение
    [48477] = true, -- br
   

}

-- aura applied 
ns.taunts = {
    -- дк
	[56222] = false, -- темная власть дк
	[49560] = false, -- хватка смерти дк
	[49576] = false, -- хватка смерти

    --вар
    [12809] =false, -- [Оглушающий удар]
	[355] = false, -- Провокация вар
	[694] = false, -- Дразнящий удар вар
    [1161] = false, -- [Вызывающий крик] -- таунт
    [6552] =false, -- [Зуботычина]

    -- пал
    [62124] = false, -- 	Длань возмездия пал
	[31790] = false, -- Праведная защита пал
    [31789] =false, -- [Праведная защита] каст
    [20066] =false, -- [Покаяние]
    [70940] =false, -- [Божественный страж]
    [10308] =false, -- [Молот правосудия]

    -- дру
    [6795] = false, -- [Рык]
    [5209] = false, -- [Вызывающий рев]
    [53227] =false, -- [Тайфун]
    [33786] = false, -- смерч
    -- хант
    [20736] = false, -- [Отвлекающий выстрел]

    [20736] = false, -- [Отвлекающий выстрел]

    [20233] = false,
    [20236] = false,
    [10278] = false,

    [71289] = false, -- леди  контроль
}


ns.bots= {
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
	[48707] = false,	-- Антимагический панцирь
	[48792] = false,	-- Незыблемость льда
	[55233] = false,	-- Кровь вампира
    [42650] = false,   -- бомжи
    [48743] =false, -- [Смертельный союз]

	-- Друид
	[22812] = false,	-- Дубовая кожа
	--[22842] = false,	-- Неистовое восстановление
	[61336] = false,	-- Инстинкты выживания
	-- Паладин
	[498] 	= false, -- Диван
    [48817] = false, -- [Гнев небес]
    [64205] = true, -- масс сакра
	[31821] = false, -- Мастер аур
    [54428] = false, -- святая клятва
	-- Воин
	[12975] = false,	-- Ни шагу назад
	[12976] = false,	-- ни шагу назад спадение
	[871] 	= false,	-- глухая оборона
    [5246] = false, -- фир
    [2565] =false, -- [Блок щитом]
	-- Маг
	[45438] = false, -- Ледяная глыба
	-- Trinkets 
	[71638] = false, -- Клык
	-- Priest
	[64843] = false, -- Божественный гимн
    [64901] =false, -- [Гимн надежды]
    -- Чмо
    [31224] =false, -- [Плащ Теней]

    -- хант
    [13809] =false, -- [Ледяная ловушка]
    [34600] =false, -- [Змеиная ловушка]
    [23989] =false, -- [Готовность]

    -- шама
    [2825] =false, -- [Жажда крови]
    [32182] =false, -- gera
    [21169] =false, -- [Перерождение]
    [16190] =false, -- [Тотем прилива маны]


  
}

-- бонусы от комплектов
ns.bonus = {
	-- ДК
	[70654] = false, -- [4P T10]
	-- Друид
	[70725] = false, -- [4P T10]

    --маг
    [66] =false, -- [Невидимость]

    -- пал 
    [642] =false, -- бабл

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
    [48153]=true, -- ангел у жреца  
    [66233]=true, -- прокладка у пала 
    [66235]=true, -- прокладка у пала
}

ns.spellsNew1 = {
    DEATHKNIGHT = {
        56222, -- Темная власть
        55233, -- Кровь вампира
        42650, -- Войско мертвых
        48792, -- Незыблемость льда
        48982, -- Захват рун
        70654, -- Кровавый доспех
        47528, -- Заморозка разума
        48707, -- Антимагический панцирь
        49560, -- Хватка смерти
        49576, -- Хватка смерти сам каст
        --51271, -- Несокрушимая броня
        48743, -- Смертельный союз
        49016, -- Истерия
        47476, -- Удушение
        49005, -- Кровавая метка
    },
    DRUID = {
        61336, -- Инстинкты выживания
        22812, -- Дубовая кожа
        --20484,  -- бр 
        48477, -- Возрождение
       -- 48447, -- Спокойствие
        53227, -- Тайфун
        --8983, -- Оглушить
        6795, -- Рык
        5209, -- Вызывающий рев
        29166, -- Озарение
        70725, -- 4P T10
        33786,  -- конроль
    },
    HUNTER = {
        34477, -- Перенаправление
        13809, -- Ледяная ловушка
        --23989, -- Готовность
        --19801, -- Усмиряющий выстрел
        20736, -- Отвлекающий выстрел
        34600, -- Змеиная ловушка
    },
    MAGE = {
        66, -- Невидимость
      --  31687, -- Призыв элементаля воды
        45438, -- Ледяная глыба
        --475, -- Снятие проклятия
        2139, -- Антимагия
        58659, -- Стол
    },
    PALADIN = {
        31790, -- Праведная защита пал
        62124, -- Длань возмездия
    
        1044, -- Длань свободы
        1038, -- Длань спасения
        6940, -- Длань жертвенности
        10278, -- Длань защиты
        
        20066, -- Покаяние
    
        48817, -- Гнев небес
        10308, -- Молот правосудия
        
        -- 31850, -- Ревностный защитник
        66233, -- Ревностный защитник
        66235, -- Ревностный защитник
        
        31789, -- Праведная защита каст
        31821, -- Мастер аур
        --31884, -- крылья
        --53601, -- Священный щит
        498, -- 50 на 50
        
        642, -- бабл
    
        --70940, -- Божественный страж эфект от масс сакры на рейде 
        64205, -- масс сакра
        --31842, -- Божественное просветление
    
        19752, -- диван
        
        54428, -- Святая клятва
        -- 48788, -- Возложение рук
        20233, -- Возложение рук
        20236, -- Возложение рук
    },
    PRIEST = {
        48153, -- Оберегающий дух
        47788, -- Оберегающий дух
        6346, -- Защита от страха
        33206, -- Подавление боли
    
        64901, -- Гимн надежды
        64843, -- Божественный гимн
        
        -- 8122, -- Ментальный крик
        -- 15487, -- Безмолвие
        -- 34433, -- Исчадие Тьмы
        -- 724, -- Колодец Света
        -- 64044, -- Глубинный ужас
        -- 10890, -- Ментальный крик
    
        -- 586, -- Уход в тень
    
        -- 10060, -- Придание сил
    
        -- 47585, -- Слияние с Тьмой
        -- 48113, -- Молитва восстановления
    },
    ROGUE = {
        51722, -- Долой оружие
        57934, -- Маленькие хитрости
            
        -- 26669, -- Ускользание
        -- 13877, -- Шквал клинков
        -- 48659, -- Ложный выпад
        -- 1856, -- Исчезновение
        -- 11305, -- Спринт
        -- 26889, -- Исчезновение
        -- 1766, -- Пинок
        -- 5277, -- Ускользание
        -- 2094, -- Ослепление
        -- 13750, -- Выброс адреналина
        -- 8643, -- Удар по почкам
        -- 14185, -- Подготовка
        -- 51690, -- Череда убийств
        31224, -- Плащ Теней
        --1725, -- Отвлечение
    },
    SHAMAN = {
        2825, -- Жажда крови
        32182, -- Героизм
        16190, -- Тотем прилива маны
        21169, -- Перерождение
    
        -- 16188, -- Природная стремительность
        -- 51533, -- Дух дикого волка
        -- 16166, -- Покорение стихий
        -- 57994, -- Пронизывающий ветер
        -- 30823, -- Ярость шамана
        -- 59159, -- Гром и молния
    
        -- 51514, -- Сглаз
        -- 20608, -- Перерождение
        -- 2894, -- Тотем элементаля огня
        -- 2062, -- Тотем элементаля земли
    },
    WARLOCK = {
        58887, -- Ритуал душ
        698,	-- Ритуал призыва
    
        -- 47241, -- Метаморфоза
        -- 1122, -- Инфернал
        -- 18540, -- Ритуал Рока
        -- 29858, -- Раскол души
        -- 47883, -- Воскрешение камнем души
        -- 47891, -- Заслон от темной магии
        -- 29893, -- Ритуал душ
        -- 698, -- Ритуал призыва
        -- 6203, -- Камень души
    },
    WARRIOR = {
    
        355, -- Провокация
        694, -- дразнящий удар
        1161, -- Вызывающий крик -- таунт
    
        6552, -- Зуботычина
        
        676, -- Разоружение
    
        --55694, -- Безудержное восстановление
        12809, -- Оглушающий удар
        3411, -- Вмешательство
        12975, -- Ни шагу назад
        12976, -- Ни шагу назад
        871, -- Глухая оборона
        70845, -- Стоицизм т10
    
        2565, -- Блок щитом
      --  12323, -- Пронзительный вой
    
        5246, -- устрашающий-крик
    },
    Engineering = {
            -- инженерка 
        54861,
        22700,
        44389,
        67826,
        54710,
        54711,
    },
    Accessories ={
            -- Trinkets 
        71638, -- Клык
    },
    MagicPortals = {
        53142, -- Даларан
        11419, -- Дарнас
        32266, -- Экзодар
        11416, -- Стальгорн 
        11417, -- Огри 
        33691, -- Шатрат    
        35717, -- Шатрат  
        32267, -- Луносвет  
        49361, -- Каменор     
        10059, -- Шторм    
        49360, -- Терамор     
        11420, -- Громовой утес
        11418, -- Подгород   
    },
    Food ={

        --eda
        57426, -- Рыбный пир
        57301, -- "Пир на весь мир"
        66476, -- Богатый пир
    },
    ICC25HM ={
        -- 74320, -- жнец душ баф на личе
        --69409, 10 об
        73797, -- жнец душ  25 об
        -- 73798, -- жнец душ  10 хм
        -- 73799, -- жнец душ  --25 хм
        71726, -- укус вампира
        -- 71729, -- укус вампира  -- босс в 25 хм
        -- 71727, -- укус вампира  -- босс в 24 об
        -- 71728, -- укус вампира  -- босс в 10 хм
        -- 71475, -- укус вампира  -- игрок на игрока в 25 об 
        -- 71476, -- укус вампира  -- игрок на игрока в 10 хм + 10 об босс на игрока
        -- 71477, -- укус вампира  -- игрок на игрока в 25 хм
        -- 70946, -- укус вампира  -- 10 об игрок на игрока  
        72148, -- Исступление на шарке 25 героик
        28747, -- Бешенство на шарке 25 героик
        71289, -- леди контроль 
        71264,
    },
    DISPELS={
        2782,   -- "Снятие проклятия"
        526,    -- "Оздоровление"
        4987,   -- "Очищение"
        51886,  -- "Очищение духа"
        32375,  -- "Массовое рассеивание"
        32592,  -- "Массовое рассеивание"
        988,    -- "Рассеивание заклинаний"
        552,    -- "Устранение болезни"
        48011,  -- "Пожирание магии"
        528,    -- "Излечение болезни"
        --19801,  -- "Усмиряющий выстрел"
        475,    -- "Снятие проклятия"
        10872,  -- "Эффект устранения болезни"
        2893,   -- "Устранение яда"
        3137,   -- "Эффект устранения яда"
        1152,   -- "Омовение"
        57767,  -- "Очищение"
    }
}


ns.NamedCategories = {
    {"DEATHKNIGHT", "Рыцарь смерти"},
    {"DRUID","Друид"},
    {"HUNTER","Охотник"},
    {"MAGE","Маг"},
    {"PALADIN","Паладин"},
    {"PRIEST","Жрец"},
    {"ROGUE","Разбойник"},
    {"SHAMAN","Шаман"},
    {"WARLOCK","Чернокнижник"},
    {"WARRIOR","Вар"},
    {"DISPELS","Расеивания"},
    {"Engineering","Инженеры"},
    {"Accessories","Аксессуары"},
    {"MagicPortals","Порталы магов" },
    {"Food","Еда"},
    {"ICC25HM","ЦЛК"},
}