
local lang = gmodI18n.registerLanguage("rpgm", "en", "Tom.bat", 1.0)

--Invalid nickname reasons
lang:addPhrase("isBlacklisted", "is blacklisted")
lang:addPhrase("containsIllegalChars", "contains illegal characters")
lang:addPhrase("isToLong", "is too long")
lang:addPhrase("isToShort", "is too short")

--Notifications
lang:addPhrase("invalidNickname", "Invalid Nickname")
lang:addPhrase("nameProvidedInvalid", "The name you provided #reason.", {reason = "is invalid"})

lang:addPhrase("nicknameInUse", "Nickname In Use")
lang:addPhrase("nameProvidedInUse", "The name you provided is already in use.")

lang:addPhrase("nicknameNotFound", "Nickname Not Found")
lang:addPhrase("nameProvidedNotInUse", "The name you provided isn't in use.")

lang:addPhrase("nicknameReset", "Nickname Reset")
lang:addPhrase("nicknameResetBy", "Your nickname has been reset#by.", {by = ""})
lang:addPhrase("byAnAdmin", "by an administrator.")

lang:addPhrase("nicknameRemoved", "Nickname Removed")
lang:addPhrase("nicknameMadeAvailable", "The nickname \"#name\" has been made available.", {name = "Something"})

lang:addPhrase("nicknameChange", "Nickname Change")
lang:addPhrase("changedOldNameTo",  "#oldName changed their nickname to #newName.", {oldName = "Something", newName = "Something"})