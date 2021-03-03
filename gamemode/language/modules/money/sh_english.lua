
local lang = gmodI18n.registerLanguage("rpgm", "en", "Tom.bat", 1.0)

lang:addPhrase("cantGiveMoney", "Can't Give Money")
lang:addPhrase("notLookingAtMoneyReceiver", "You're not looking at someone who's close enough to receive money.")

lang:addPhrase("receivedMoney", "Received Money")
lang:addPhrase("playerGaveAmount", "#giverName has gave you #givenAmount.", {giverName = "Someone", givenAmount = "Money"})

lang:addPhrase("gaveMoney", "Gave Money")
lang:addPhrase("gaveAmountTo", "You have given #givenAmount to #receiverName.", {receiverName = "Someone", givenAmount = "Money"})