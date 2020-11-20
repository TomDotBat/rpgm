
local categories = {}

function RPGM.AddCategory(classType, name, color, order)
    if not name then return end
    if not categories[classType] then categories[classType] = {} end

    categories[classType][name] = {
        color = color,
        order = order
    }
end

function RPGM.GetCategories()
    return categories
end

function RPGM.GetClassCategories(classType)
    return categories[classType]
end