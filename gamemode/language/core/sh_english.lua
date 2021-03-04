
local lang = gmodI18n.registerLanguage("rpgm", "en", "Tom.bat", 1.0)

--Buyable Classes
lang:addPhrase("cantBuyItemAs", "You can't buy this item as a #teamName.", {teamName = "Unknown"})

--Teams
lang:addPhrase("alreadyATeam", "You're already a #teamName.", {teamName = "Unknown"})
lang:addPhrase("teamNotFound", "The team #teamName couldn't be found.", {teamName = "INVALID"})

lang:addPhrase("teamChange", "Team Change")
lang:addPhrase("playerBecameA", "#playerName has became a #teamName.", {playerName = "Someone", teamName = "Unknown"})

lang:addPhrase("cantTeamChange", "Can't Change Team")
lang:addPhrase("noSlotsAvailable",  "There are no slots available for #teamName.", {teamName = "Unknown"})
lang:addPhrase("teamRequirementsNotMet", "You don't meet the requirements to join #teamName.", {teamName = "Unknown"})

--Commands
lang:addPhrase("correctSyntax",  "Correct syntax: #cmdName #correctSyntax", {cmdName = "Unknown", correctSyntax = ""})

--Notification Types
lang:addPhrase("notifyTypeInformation", "Information")
lang:addPhrase("notifyTypeError", "Error")
lang:addPhrase("notifyTypeUndone", "Undone")
lang:addPhrase("notifyTypeHint", "Hint")
lang:addPhrase("notifyTypeCleanup", "Cleanup")

--CSS Mount Alert
lang:addPhrase("cssMountAlert",  "WARNING! CSS could not be found on the server.")