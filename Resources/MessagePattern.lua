
local AddOnName, ns = ...;

ns.bot	            = "%s использует %s!"
ns.used	 	        = "%s использует %s!"
ns.sw	 	        = "%s спадает с %s!"
ns.cast	 	        = "%s использует %s на %s!"
ns.taunt	        = "%s использует %s на %s!"
ns.castICC 	        = "%s использует %s id %s на %s!"
ns.tauntMissed	    = "%s промазал %s по %s!"

ns.fade	 	        = "%s %s спадает с %s!"
ns.feast            = "%s готовит %s!"
ns.gs	 	        = "%s %s потребляет: %d лечение!"
ns.ad	 	        = "%s %s потребляются!"
ns.res	 	        = "%s %s воскрешен %s!"
ns.portal           = "%s открыт %s!"
ns.create           = "%s создает %s!"
ns.dispel           = "%s %s не удалось рассеять %s's %s!"
ns.ss	 	        = "%s умирает. Может встать %s!"
-- ns.lanaTel	        = "Кровавая королева Лана'тель" 

-- local debuggingMode = true;
-- local spells = ns.spellsNew;


-- local OUTPUT = "RAID"
-- local MIN_TANK_HP = 55000
-- local MIN_HEALER_MANA = 20000
-- local DIVINE_PLEA = false; 
-- local DIVINE_PLEA_ID = 54428 -- клятва привет Enoi
-- local sacredSacrifice = false;
-- local sacredSacrificeId = 64205 -- масс сакра
-- local debuggingMode = false;
	 
-- local sacrifice  = {} -- сюда пойдут id юнитов с диванами и тд
-- local soulStones = {} -- сюда пойдут id юнитов с камнями души (лок рес)
-- local ad_heal	 = false

-- local deadeningPlague = "Мертвящая чума";
-- local deadeningPlagueIsEnabled = true;
-- local outputOfInformationDuringDebugging = false;

-- local HEROISM	= UnitFactionGroup("player") == "Horde" and 2825 or 32182	-- Героизм\жажда крови
-- local REBIRTH 	= GetSpellInfo(20484)										-- Возрождение
-- local HOP 		= GetSpellInfo(1022)										-- Длань защиты
-- local SOUL_STONE = GetSpellInfo(20707)										-- Воскрешение камнем души
-- local CABLES	= GetSpellInfo(54732)		


-- function ns:Send(
-- 	timestamp, -- время применения
-- 	event, -- тип события
-- 	srcGUID, -- GUID источника
-- 	srcName, -- имя источника
-- 	srcFlags, -- флаги ( для получения инфы враг\\друг)
-- 	destGUID,  -- GUID получившего каст
-- 	destName,  -- имя получившего каст
-- 	destFlags, -- флаги
-- 	spellID,  -- id спела
-- 	spellName,  -- название спела
-- 	school,  -- маска школы
-- 	idScattering, -- ид при рассеивании
--     nameScattering, -- заклинание которое рассеяли
--     ...)  -- остальные аргументы
	


-- 	if UnitInRaid(destName) or UnitInParty(destName) or debuggingMode then
-- 		if spellName == SOUL_STONE and event == "SPELL_AURA_REMOVED" then
-- 			if not soulStones[destName] then soulStones[destName] = {} end
-- 			soulStones[destName].time = GetTime()
-- 		elseif spellID == 27827 and event == "SPELL_AURA_APPLIED" then
-- 			soulStones[destName] = {}
-- 			soulStones[destName].SoR = true
-- 		elseif event == "UNIT_DIED" and soulStones[destName] and not UnitIsFeignDeath(destName) then
-- 			if not soulStones[destName].SoR and (GetTime() - soulStones[destName].time) < 2 then
-- 				send(ns.ss:format(destName, GetSpellLink(6203)))
-- 				SendChatMessage(ns.ss:format(destName, GetSpellLink(6203)), "RAID_WARNING")
-- 			end
-- 			soulStones[destName] = nil
-- 		end
--     end
	
-- 	if UnitInRaid(srcName) or UnitInParty(srcName) or debuggingMode then
-- 		--if true then -- Проверка на бой UnitAffectingCombat(srcName) or spellID == 49016
-- 			if event == "SPELL_CAST_SUCCESS"  then
-- 				if spells[spellID] then
-- 					send(ns.cast:format( srcName, GetSpellLink(spellID), destName))
-- 				elseif spellID == 19752 then
-- 					send(ns.cast:format( srcName, GetSpellLink(spellID), destName))
-- 				elseif spells[spellID] then
--                     --Print("Имя"..tostring(srcName).."HP"..tostring(UnitHealthMax(srcName)))
-- 					send(ns.used :format( srcName, GetSpellLink(spellID)))
-- 				elseif spellID == sacredSacrificeId and sacredSacrifice then
-- 					send(ns.used :format( srcName, GetSpellLink(spellID)))
-- 					sacrifice[srcGUID] = true
-- 				elseif spells[spellID] then
-- 					send(ns.used :format( srcName, GetSpellLink(spellID)))
-- 				elseif DIVINE_PLEA and spellID == DIVINE_PLEA_ID then
-- 					send(ns.used :format( srcName, GetSpellLink(spellID)))
-- 					-- elseif taunts[spellID] and destName == ns.lanaTel then  -- 31789
-- 					-- 		send(ns.taunt:format( srcName, GetSpellLink(spellID), destName))
-- 				end
				
-- 			elseif event == "SPELL_AURA_APPLIED" then
-- 				if spellID == 20233 or spellID == 20236 then
-- 					send(ns.cast:format( srcName, GetSpellLink(spellID), destName))
-- 				elseif spells[spellID] then
-- 					send(ns.used :format( srcName, GetSpellLink(spellID)))
-- 				elseif spellID == 66233 then
-- 					if not ad_heal then
-- 						send(ns.ad:format( srcName, GetSpellLink(spellID)))
-- 					end
-- 					ad_heal = false
-- 				elseif spellName == HOP then
-- 					send(ns.cast:format( srcName, GetSpellLink(spellID), destName))
-- 				elseif spells[spellID] then  -- 31789
-- 					send(ns.taunt:format( srcName, GetSpellLink(spellID),  destName))
-- 				end

-- 			elseif event == "SPELL_HEAL" then
-- 				if spellID == 48153 or spellID == 66235 then
-- 					local amount = ...
-- 					ad_heal = true
-- 					send(ns.gs:format( srcName, GetSpellLink(spellID), amount))
-- 				end
-- 			end
-- 		--end
-- 		-- мое
		

-- 		if event == "SPELL_CAST_SUCCESS" then
-- 			if spellID == HEROISM then
-- 				send(ns.used :format( srcName, GetSpellLink(spellID)))
--             elseif spells[spellID] then 
-- 				send(ns.bot 	 :format( srcName, GetSpellLink(spellID)))
-- 			elseif spells[spellID] then
-- 				send(ns.create:format( srcName, GetSpellLink(spellID)))
-- 			end
			
-- 		elseif event == "SPELL_AURA_APPLIED" then
--             if spells[spellID] then 
--                 send(ns.bot:format( srcName, GetSpellLink(spellID)))
-- 			elseif spellName == SOUL_STONE then
-- 				local _, class = UnitClass(srcName)
-- 				if class == "WARLOCK" then
-- 					send(ns.cast:format( srcName, GetSpellLink(6203), destName))
-- 				end
-- 			end
			
-- 		elseif event == "SPELL_CREATE" then
-- 			if spells[spellID] then
-- 				send(ns.portal:format( srcName, GetSpellLink(spellID)))
-- 			-- elseif toys[spellID] then
-- 			-- 	send(ns.bot 	 :format( srcName, GetSpellLink(spellID)))
-- 			end
			
-- 		elseif event == "SPELL_CAST_START" then
-- 			if spells[spellID] then
-- 				send(ns.feast:format( srcName, GetSpellLink(spellID)))
-- 			end
			
-- 		elseif event == "SPELL_RESURRECT" then
-- 			if spellName == REBIRTH then
-- 				send(ns.cast:format( srcName, GetSpellLink(spellID), destName))
-- 			elseif spellName == CABLES then
-- 				send(ns.res:format( srcName, GetSpellLink(spellID), destName))
-- 			end	
			
-- 		elseif event == "SPELL_DISPEL_FAILED" then
-- 			local extraID, extraName = ...
-- 			local target = fails[extraName]
-- 			if target or destName == target then
-- 				send(ns.dispel:format( srcName, GetSpellLink(spellID), destName, GetSpellLink(extraID)))
-- 			end
-- 		end
-- 	end
-- end

-- function send( msg )
--     print(msg)
-- end