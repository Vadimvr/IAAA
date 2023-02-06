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
local data = {
    
    {nil,  SPELL_CAST_SUCCESS,0x00000000007B29C3,"Ypsdva",0x528,0x0000000000000000,nil,0x80000000,58887,"Ритуал душ",0x20},
    {nil, SPELL_CAST_SUCCESS,0x0000000000659B9E,"Берликк",0x528,0x0000000000000000,nil,0x80000000,698,"Ритуал призыва",0x20},
    {nil,SPELL_CAST_SUCCESS,0x000000000030BF0B,"Azog",0x528,0x000000000030BF0B,"Azog",0x528,48707,"Антимагический панцирь",0x20, "BUFF",nil,},
    {nil, SPELL_AURA_APPLIED,0x000000000085ED34,"Zhova",0x528,0x0000000000658701,"Madmoney",0x528,47883,"Воскрешение камнем души",0x20,BUFF},

    {nil,SPELL_AURA_APPLIED,0x0000000000686E8D,"Habero",0x528,0xF1300093FE0006E4,"Прожорливое поганище",0xa28,56222,"Темная власть",0x1,DEBUFF },
    {nil,SPELL_CAST_SUCCESS,0x000000000085D619,"Фанэра",0x528,0x0000000000000000,nil,0x80000000,67826,"Дживс",0x1 },
    {nil, SPELL_AURA_APPLIED,0x0000000000686E8D,"Habero",0x528,0x0000000000686E8D,"Habero",0x528,70654,"Кровавый доспех",0x20,BUFF},
    {nil,SPELL_CAST_START,0x000000000083C4EF,"Колобчело",0x528,0x0000000000000000,nil,0x80000000,57426,"Рыбный пир",0x1 },
    {nil, SPELL_CAST_SUCCESS,0x0000000000827CE5,"Дивайна",0x1228,0x0000000000000000,nil,0x80000000,64843,"Божественный гимн",0x2},
    {nil,SPELL_CREATE,0x00000000007FF79E,"Шакалит",0x528,0xF11002BEE800010B,"Камень встреч - портал призыва",0x4128,49360,"Ритуал призыва",0x20},-- порт в даларан 
    {nil, SPELL_CAST_SUCCESS,0x0000000000347733,"Эншик",0x528,0x0000000000000000,nil,0x80000000,32182,"Героизм",0x8},  
    {nil, SPELL_CAST_SUCCESS,0x000000000040ABF8,"Олфа",0x528,0x0000000000000000,nil,0x80000000,2825,"Жажда крови",0x8},                    -- гера
    {nil,SPELL_RESURRECT,0x0000000000697316,"Kupr",0x528,0x00000000007D9801,"Нуттеллка",0x528,48477,"Возрождение",0x8 },                   -- бр
    {nil, SPELL_AURA_APPLIED,0x000000000064622A,"Bixad",0x528,0x0000000000463EF9,"Drumaniac",0x528,10278,"Длань защиты",0x2,BUFF},          --боп
    
    --- камень души 
    {nil, SPELL_AURA_APPLIED,0x00000000007B29C3,"Ypsdva",0x528,0x00000000005702F3,"Mrkreep",0x528,47883,"Воскрешение камнем души",0x20,BUFF},
    {nil, SPELL_AURA_REMOVED,0x00000000007B29C3,"Ypsdva",0x528,0x00000000005702F3,"Mrkreep",0x528,47883,"Воскрешение камнем души",0x20,BUFF},
    {nil, UNIT_DIED,0x0000000000000000,nil,0x80000000,0x00000000005702F3,"Mrkreep",0x528},
    {nil, },

    
    {1675520058.933, "SPELL_DISPEL_FAILED", "0x0000000000864E39", "Нина", 1320, "0x0000000000670D93", "Поррешка", 1320, 4987, "Очищение", 2, 55360, "Живая бомба", 4, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "attempt to index global 'fails' (a nil value)", true, },
    {nil,SPELL_DISPEL_FAILED,0x0000000000827CE5,"Дивайна",0x528,0x0000000000675CA2,"Ssyslik",0x528,528,"Излечение болезни",0x2,55095,"Озноб",16 },
    
    -- бр 
    {nil,SPELL_CAST_START,0x000000000075F816,"Масилия",0x528,0x0000000000000000,nil,0x80000000,48477,"Возрождение",0x8},
    {nil,SPELL_RESURRECT,0x000000000017191F,"Dearross",0x528,0x000000000082271D,"Грогат",0x528,48477,"Возрождение",0x8 },
    
    {nil, SPELL_AURA_APPLIED,0x000000000085E062,"Gabbr",0x528,0xF130008FB5000261,"Валитрия Сноходица",0xa28,20236,"Возложение рук",0x2,BUFF},
    {nil, SPELL_AURA_APPLIED,0x0000000000724E51,"Hildryg",0x528,0xF140680787000009,"днорекаунта",0x1128,20233,"Возложение рук",0x2,BUFF},
    {nil, SPELL_CAST_SUCCESS,0x000000000079A953,"Хулитопочка",0x528,0x0000000000793779,"Notokay",0x528,19752,"Божественное вмешательство",0x2},
    {nil, SPELL_CAST_SUCCESS,0x0000000000792F99,"Galinazxc",0x528,0x0000000000000000,nil,0x80000000,64205,"Священная жертва",0x1},
    {nil, SPELL_AURA_APPLIED,0x000000000086EAB0,"Liggma",0x528,0x000000000086EAB0,"Liggma",0x528,10278,"Длань защиты",0x2,BUFF},

    {nil, SPELL_AURA_APPLIED,0x00000000005B6841,"Аргентлайт",0x528,0x00000000005B6841,"Аргентлайт",0x528,66233,"Ревностный защитник",0x2,DEBUFF},

    {nil,SPELL_HEAL,0x00000000005EDF5D,"Capthor",0x528,0x00000000005EDF5D,"Capthor",0x528,66235,"Ревностный защитник",0x2,10713,0,0,nil},
    {nil, SPELL_AURA_APPLIED,0x00000000005EDF5D,"Capthor",0x528,0x00000000005EDF5D,"Capthor",0x528,66233,"Ревностный защитник",0x2,DEBUFF},



    {nil, SPELL_AURA_APPLIED,0x00000000007B67A4,"Gazelbnext",0x528,0x00000000007B67A4,"Gazelbnext",0x528,54861,"Нитроускорители",0x1,BUFF},
    {nil, SPELL_CAST_SUCCESS,0x0000000000792F23,"Rosset",0x528,0x0000000000000000,nil,0x80000000,54710,"МЯЛЛ-И",0x1 },


    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },
    {nil, },





}

ns.data = data;

