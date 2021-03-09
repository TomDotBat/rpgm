
local _R = debug.getregistry()

function RPGM.Classes.ItemBase(tbl, name, category, command, model, order, extra, functions)
    local tbl = tbl or setmetatable({}, _R["RPGMItemBase"])

    tbl:setName(name)
    tbl:setCategory(category)
    tbl:setCommand(command)
    tbl:setModel(model)
    tbl:setOrder(order)
    tbl:setExtras(extra)
    tbl:setFunctions(functions)

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end

if _R["RPGMItemBase"] then return end


local itemBase = {}
_R["RPGMItemBase"] = itemBase

itemBase.__index = itemBase
itemBase.__type = "base"

function itemBase:getName() return self._name end
function itemBase:getCategory() return self._category end
function itemBase:getCommand() return self._command end
function itemBase:getModel()
    return istable(self._model) and table.Random(self._model) or self._model
end
function itemBase:getOrder() return self._order end
function itemBase:getExtras() return self._extra end
function itemBase:getFunctions() return self._functions end

function itemBase:setName(val)
    RPGM.Assert(isstring(val), "Item name must be a string.")
    self._name = val
end

function itemBase:setCategory(val)
    RPGM.Assert(isstring(val), "Item category must be a string.")
    self._category = val
    RPGM.AddCategory(self.__type, val)
end

function itemBase:setCommand(val)
    RPGM.Assert(isstring(val), "Item command must be a string with no spaces.")
    RPGM.Assert(not string.find(val, " "), "Item command must be a string with no spaces.")
    self._command = val
end

function itemBase:setModel(val)
    if istable(val) then
        for k, v in pairs(val) do
            RPGM.Assert(isstring(v), "Item model must be a string or table of strings.")
        end
    else
        RPGM.Assert(isstring(val), "Item model must be a string or table of strings.")
    end

    self._model = val
end

function itemBase:setOrder(val)
    RPGM.Assert(isnumber(val), "Item order must be a number.")
    self._order = val
end

function itemBase:setExtras(val)
    if table.IsEmpty(val) then return end
    RPGM.Assert(istable(val) and not table.IsSequential(val), "Item extra data must be a key-value table.")
    self._extra = val
end

function itemBase:setExtra(key, val)
    RPGM.Assert(isstring(key), "Item extra name must be a string.")

    if not istable(self._extra) then self._extra = {} end
    self._extra[key] = val
end

function itemBase:setFunctions(val)
    if table.IsEmpty(val) then return end
    RPGM.Assert(istable(val) and table.IsSequential(val), "Item functions must be a key-value table of functions and names.")

    for k, v in pairs(val) do
        RPGM.Assert(isfunction(v), "Item functions must be a key-value table of functions and names.")
    end

    self._functions = val
end

function itemBase:setFunction(key, val)
    RPGM.Assert(isstring(key), "Item function name must be a string.")
    RPGM.Assert(isfunction(val), "Item function must be a function.")

    if not istable(self._functions) then self._functions = {} end
    self._functions[key] = val
end

function itemBase:doCustomCheck(ply)
    local self._check = self._functions["customCheck"]
    if not self._check then return true end

    return self._check(ply)
end

function itemBase:getNetworkableTable(useCache)
    if useCache and self._netTable then return self._netTable end

    self._netTable = {
        ["name"] = name,
        ["category"] = category,
        ["command"] = command,
        ["model"] = model,
        ["order"] = order,
        ["extra"] = extra
    }

    return self._netTable
end
