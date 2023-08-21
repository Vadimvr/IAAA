local _, ns = ...

local setmetatable = setmetatable
local tostring, format = tostring, string.format
local rawset, rawget = rawset, rawget
local L = setmetatable({}, {
	__newindex = function(self, key, value)
		rawset(self, key, value == true and key or value)
	end,
	__index = function(self, key)
		return key
	end
})
function L:F(line, ...)
	line = L[line]
	return format(line, ...)
end
ns.L = L
L["hello"]                                                  = true
L["Apply"]                                                  = true
L["Hide"]                                                   = true
L["Select All"]                                             = true
L["Hide All"]                                               = true
L["BG +"]                                                   = true
L["BG -"]                                                   = true
L["Font +"]                                                 = true
L["Font -"]                                                 = true
L["Test"]                                                   = true
----------------------------------------------------------------------------------------------------------------------------------
L["turned off"]                                             = true
L["turned on"]                                              = true
L["Show or hide log window."]                               = true
L["Show or hide setting window."]                           = true
L["Information about the abilities"]                        = true
L["Successfully uploaded."]                                 = true
----------------------------------------------------------------------------------------------------------------------------------
L["Message output is disabled."]                            = "Message output is disabled."
L["Message output is activated."]                           = "Message output is activated."
L["To turn on, type"]                                       = "To turn on, type"
L["To turn off, type"]                                      = "To turn off, type"
L["The output of messages to the raid is activated."]       = "The output of messages to the raid is activated."
L["The output of messages in raid is disabled."]            = "The output of messages in raid is disabled."
L["Opens the logs window."]                                 = "Opens the logs window."
L["Opens the settings window."]                             = "Opens the settings window."
L["Output of messages to the chat."]                        = "Output of messages to the chat."
L["Output of messages to the ride chat."]                   = "Output of messages to the ride chat."
 --------------------------------------------------------------------------------------------------------------------------------------
L["%s uses %s!"]                                            = "%s uses %s!"                    
L["%s uses %s!"]                                            = "%s uses %s!"                    
L["%s falls from %s!"]                                      = "%s falls from %s!"              
L["%s uses %s on %s!"]                                      = "%s uses %s on %s!"              
L["%s uses %s on %s!"]                                      = "%s uses %s on %s!"              
L["%s uses %s id %s on %s!"]                                = "%s uses %s id %s on %s!"        
L["%s missed %s by %s!"]                                    = "%s missed %s by %s!"            
L["%s %s falls from %s!"]                                   = "%s %s falls from %s!"           
L["%s cooks %s!"]                                           = "%s cooks %s!"                   
L["%s %s consumes: %d treatment!"]                          = "%s %s consumes: %d treatment!"  
L["%s %s consumed!"]                                        = "%s %s consumed!"                
L["%s %s resurrected %s!"]                                  = "%s %s resurrected %s!"          
L["%s is open %s!"]                                         = "%s is open %s!"                 
L["%s creates %s!"]                                         = "%s creates %s!"                 
L["%s %s dissipates %s with %s!"]                           = "%s %s dissipates %s with %s!"   
L["%s dying. Can get up %s!"]                               = "%s dying. Can get up %s!"       
L["%s %s failed to dispel %s's %s!"]                        = "%s %s failed to dispel %s's %s!"
L["%s died lol!"]                                           = "%s died lol!" 
----------------------------------------------------------------------------------------------------------------------------------------
L["DISPELS"]                                                = "Dispels"
L["Engineering"]                                            = "Engineering"
L["Accessories"]                                            = "Accessories"
L["MagicPortals"]                                           = "Portals" 
L["Food"]                                                   = "Food"
L["ICC25HM"]                                                = "ICC"
----------------------------------------------------------------------------------------------------------------------------------------
L["DEATHKNIGHT"]                                            = "Death Knight"
L["DRUID"]                                                  = "Druid"
L["HUNTER"]                                                 = "Hunter"
L["MAGE"]                                                   = "Mage"
L["PALADIN"]                                                = "Paladin"
L["PRIEST"]                                                 = "Priest"
L["ROGUE"]                                                  = "Rogue"
L["SHAMAN"]                                                 = "Shaman"
L["WARLOCK"]                                                = "Warlock"
L["WARRIOR"]                                                = "Warrior"