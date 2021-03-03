
local lang = gmodI18n.registerLanguage("rpgm", "en", "Tom.bat", 1.0)

lang:addPhrase("cantGiveMoney", "Can't Give Money")
lang:addPhrase("notLookingAtMoneyReceiver", "You're not looking at someone who's close enough to receive money.")

lang:addPhrase("receivedMoney", "Received Money")
lang:addPhrase("playerGaveAmount", "#giverName has gave you #givenAmount.", {giverName = "Someone", givenAmount = "Money"})

lang:addPhrase("gaveMoney", "Gave Money")
lang:addPhrase("gaveAmountTo", "You have given #givenAmount to #receiverName.", {receiverName = "Someone", givenAmount = "Money"})

lang:addPhrase("receiverNotFound", "The player you tried to pay could not be found.")
lang:addPhrase("dontHaveEnoughMoney", "You don't have enough money to give.")

lang:addPhrase("salaryPayment", "Salary Payment")
lang:addPhrase("salaryOfAmountPaid", "You have been paid your salary of #salaryAmount", {salaryAmount = "Something"})